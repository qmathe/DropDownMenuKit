DropDownMenuKit NEWS
====================

0.9
---

- Migrated to Swift 5
- New custom transition API
- Fixed menu cells not always visible during hiding animation on iOS 11 and higher

0.8.6
-----

- Migrated to Swift 4.2

0.8.5
-----

- Migrated to Swift 4
- Improved example to showcase:
	- adding/removing menu entries
	- menu scrolling
	- long title support
- Now usable in app extensions 
	- DropDownMenuKit > Build Settings > Other Swift Flags must include -DAPP_EXTENSION 

0.8.4
-----

- iOS 11 support
- Improved menu to become scrollable menu when too many rows are presented
	- DropDownMenu.visibleContentOffset has been replaced with visibleContentInsets to support this
- Fixed memory leak preventing menu to be released

0.8.3
-----

- New customization options
	- row height
	- icon size
	- up/down images
- Fixed title to always appear correctly centered in navigation bar
	- long titles are now supported
- Fixed height of menu view when setting its cells after it has been resized

0.8.2
-----

- Migrated to Swift 3

0.8.1
-----

- Added DropDownMenu.selectMenuCell(:)
- Fixed incorrect arrow orientation after 3 quick taps on the title view
    - Don't let the user toggles the menu when a toggling animation is already underway

0.8
---

- First release

