from ds_store import DSStore
from mac_alias import Alias
from mac_alias import Bookmark

import sys
import biplist

if len( sys.argv ) != 3:
    print 'Usage: python create-dsstore.py <VolumeName> <Application>'
    exit( 1 )

volume = sys.argv[1]
app = sys.argv[2]

image_file = volume + '/.background/background.png'

alias = Alias.for_file( image_file )
bookmark = Bookmark.for_file( image_file )

with DSStore.open( volume + '/.DS_Store', 'w+' ) as ds:
    ds['.']['bwsp'] = {'ShowStatusBar': False, 'WindowBounds': '{{320, 320}, {400, 200}}', 'ContainerShowSidebar': False, 'SidebarWidth': 0, 'ShowTabView': False, 'PreviewPaneVisibility': False, 'ShowToolbar': False, 'ShowPathbar': False, 'ShowSidebar': False}
    ds['.']['icvp'] =  {'gridSpacing': 50.0, 'textSize': 15.0, 'viewOptionsVersion': 1, 'backgroundColorBlue': 1.0, 'iconSize': 90.0, 'backgroundColorGreen': 1.0, 'arrangeBy': 'none', 'showIconPreview': True, 'gridOffsetX': 0.0, 'gridOffsetY': 0.0, 'showItemInfo': False, 'labelOnBottom': True, 'backgroundType': 2, 'backgroundImageAlias': biplist.Data( alias.to_bytes() ), 'backgroundColorRed': 1.0}
    ds['.']['pBBk'] = bookmark
    ds['Applications']['Iloc'] = (260, 100)
    ds[app]['Iloc'] = (0, 100)
