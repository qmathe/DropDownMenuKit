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

Installation
------------

Just drop DropDownMenu.swift and DropDownTitleView.swift in your Xcode project.
