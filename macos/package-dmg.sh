#!/bin/bash

if [ -z "$1" ]; then
    echo "Usage: package-dmg.sh <App Bundle> <key>"
    exit 1
fi

SIGNING_KEY="$2"
APP="$1"
BASE_APP_NAME=$(basename "$APP")

BASE_NAME="subtitle-hider"
VERSION="1.0.0"
PRODUCT_DISPLAY_NAME="$BASE_APP_NAME"
OUTPUT_FILE="$BASE_NAME-$VERSION-install.dmg"
DMG_FILE=pkg/install-template.dmg
BASE_DIR=installer
EXTRA_MB=2

function run {

    "$@"
    local RC=$?
    if [ $RC -ne 0 ]; then
        echo "Error with $@" >& 2
        exit $RC
    fi
    return $RC
}

rm -rf pkg
mkdir pkg

APP_SIZE=$(du -sm "$APP" | cut -f 1)
DMG_SIZE=$(($APP_SIZE + $EXTRA_MB))

run rm -f "$BASE_DIR/.background/background.png"
run mkdir -p "$BASE_DIR/.background"
run tiffutil -cathidpicheck "./install-assets/background.png" "./install-assets/background@2x.png" -out "$BASE_DIR/.background/background.png"

run hdiutil create -ov -volname "$PRODUCT_DISPLAY_NAME" -srcfolder "$BASE_DIR" -size ${DMG_SIZE}m -format UDRW -fs HFS+ "$DMG_FILE"

DEVS=$(hdiutil attach "$DMG_FILE")
DEV=$(echo $DEVS | cut -f 1 -d ' ')
VOL=$(echo $DEVS | cut -f 5- -d ' ')

if [ ! -d "$VOL" ]; then
    echo "$VOL does not exist"
    exit 1
fi

pushd "$VOL"
run ln -s /Applications .
run SetFile -c icnC "$VOL/.VolumeIcon.icns"
run SetFile -a C "$VOL"
popd

run cp -R "$APP" "$VOL"

run python tools/create-dsstore.py "$VOL" "$BASE_APP_NAME"

run hdiutil detach $DEV

run hdiutil convert -format UDZO "$DMG_FILE" -ov -o "$OUTPUT_FILE"

run codesign -s "$SIGNING_KEY" --timestamp "$OUTPUT_FILE"
