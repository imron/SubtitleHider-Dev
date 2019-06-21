#!/bin/bash

rm -rf stage
mkdir stage

BASE_NAME="subtitle-hider"
VERSION="1.0.0"
PROJECT="Subtitle Hider.xcodeproj"
SCHEME="Subtitle Hider"

PLIST_FILE="./Subtitle Hider/Info.plist"

BUILD_NUM=$(/usr/libexec/PlistBuddy -c "Print :CFBundleVersion" "$PLIST_FILE")
if [ $? -ne 0 ]; then
    BUILD_NUM=1
    /usr/libexec/PlistBuddy -c "Add :CFBundleVersion string $BUILD_NUM" "$PLIST_FILE"
else
    BUILD_NUM=$(($BUILD_NUM + 1))
    /usr/libexec/PlistBuddy -c "Set :CFBundleVersion $BUILD_NUM" "$PLIST_FILE"
fi

/usr/libexec/PlistBuddy -c "Set :CFBundleShortVersionString $VERSION" "$PLIST_FILE"

xcodebuild -project "$PROJECT" -scheme "$SCHEME" -configuration Release -archivePath "stage/$BASE_NAME" clean

xcodebuild -project "$PROJECT" -scheme "$SCHEME" -configuration Release -archivePath "stage/$BASE_NAME" archive
if [ $? -ne 0 ]; then
    echo "Error building archive"
    exit 1
fi

./package-dmg.sh "stage/$BASE_NAME.xcarchive/Products/Applications/Subtitle Hider.app" "$1"
