DropDownMenuKit
===============

[![Build Status](https://travis-ci.org/qmathe/DropDownMenuKit.svg?branch=master)](https://travis-ci.org/qmathe/DropDownMenuKit)
[![Platforms iOS](https://img.shields.io/badge/Platforms-iOS-lightgray.svg?style=flat)](http://www.apple.com)
[![Language Swift 3.0](https://img.shields.io/badge/Language-Swift%203.0-orange.svg?style=flat)](https://swift.org)
[![License MIT](https://img.shields.io/badge/license-MIT-blue.svg?style=flat)](https://github.com/qmathe/DropDownMenuKit/LICENSE)
[![README Russian](https://img.shields.io/badge/readme-Russian-yellow.svg)](http://gargo.of.by/dropdownmenukit/)

DropDownMenuKit is a custom UIKit control to show a menu attached to the navigation bar or toolbar. The menu appears with a sliding animation and can be deeply customized. For example, with icons, embedded controls, or a checkmark to denote a selected row among multiple menu cells.

The control is made up of three parts: 

- DropDownMenu: the menu itself, a UIView subclass that contains a UITableView presenting one or more DropDownMenuCell(s)
- DropDownMenuCell: a menu entry, implemented as a UITableViewCell subclass
- DropDownMenuTitleView: an optional title view to toggle the menu, which is usually put in the navigation bar and acts as a disclosure indicator

<img src="http://www.quentinmathe.com/github/DropDownMenuKit/Place%20List%20Action%20Menu%20-%20iPhone%205.png" height="700" alt="Screenshot" />
<img src="http://www.quentinmathe.com/github/DropDownMenuKit/App%20History%20Menu%20-%20iPhone%205.png" height="700" alt="Screenshot" />

To see in action, take a look at the very beginning of [Placeboard](http://www.placeboardapp.com) demo video.

Compatibility
-------------

DropDownMenuKit requires iOS 8 or higher and is written in Swift 3. For Swift 2 support, use the release 0.8.1 or branch [swift-2.2](https://github.com/qmathe/DropDownMenuKit/tree/swift-2.2).

**Note**: If you are interested in iOS 7 support, rewrite DropDownTitleView.imageNamed(:).

Installation
------------

### Carthage

Add the following line to your Cartfile, run `carthage update` to build the framework and drag the built DropDownMenuKit.framework into your Xcode project.

    github "qmathe/DropDownMenuKit"
	
### CocoaPods

Add the following lines to your Podfile and run `pod install` with CocoaPods 0.36 or newer.

	use_frameworks!
	
	pod "DropDownMenuKit"

### Manually

If you don't use Carthage or CocoaPods, it's possible to drag the built framework or embed the source files into your project.

#### Framework

Build DropDownMenuKit framework and drop it into your Xcode project.

#### Files

Drop DropDownMenu.swift, DropDownMenuCell.swift, DropDownTitleView.swift and DropDownMenuKit.xcassets into your Xcode project.
