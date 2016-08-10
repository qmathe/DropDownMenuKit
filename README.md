Drop Down Menu
==============

[![Build Status](https://travis-ci.org/qmathe/DropDownMenu.svg?branch=master)](https://travis-ci.org/qmathe/DropDownMenu)
[![Platforms iOS](https://img.shields.io/badge/Platforms-iOS-lightgray.svg?style=flat)](http://www.apple.com)
[![Language Swift 2.2](https://img.shields.io/badge/Language-Swift%202.2-orange.svg?style=flat)](https://swift.org)
[![License MIT](https://img.shields.io/badge/license-MIT-blue.svg?style=flat)](https://github.com/qmathe/DropDownMenu/LICENSE)

DropDownMenu is a custom UIKit control to show a menu attached to the navigation bar or toolbar. The menu appears with a sliding animation and can be deeply customized. For example, with icons, embedded controls, or a checkmark to denote a selected row among multiple menu cells.

The control is made up of three parts: 

- DropDownMenu: the menu itself, a UIView subclass that contains a UITableView presenting one or more DropDownMenuCell(s)
- DropDownMenuCell: a menu entry, implemented as a UITableViewCell subclass
- DropDownMenuTitleView: an optional title view to toggle the menu, which is usually put in the navigation bar and acts as a disclosure indicator

<img src="http://www.quentinmathe.com/github/DropDownMenu/History%20Views%20-%20iPhone%205.png" width="700" alt="Screenshot" />

To see in action, take a look at the very beginning of [Placeboard](http://www.placeboardapp.com) demo video.

Compatibility
-------------

DropDownMenu requires iOS 7 or higher and is written in Swift 2.2.

**Note**: If you use Carthage, CocoaPods or manually install it as a framework, iOS 8 is required.

Installation
------------

### Carthage

Add the following line to your Cartfile, run `carthage update` to build the framework and drag the built DropDownMenu.framework into your Xcode project.

    github "qmathe/DropDownMenu"
	
### CocoaPods

Add the following lines to your Podfile and run `pod install` with CocoaPods 0.36 or newer.

	use_frameworks!
	
	pod "DropDownMenu"

### Manually

If you don't use Carthage or CocoaPods, it's possible to drag the built framework or embed the source files into your project.

#### Framework

Build DropDownMenu framework and drop it into your Xcode project.

#### Files

Drop DropDownMenu.swift, DropDownTitleView.swift and DropDownMenu.xcassets into your Xcode project.
