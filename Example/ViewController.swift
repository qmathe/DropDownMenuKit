/*
	Copyright (C) 2016 Quentin Mathe
 
	Date:  August 2016
	License:  MIT
 */

import UIKit
import DropDownMenuKit

class ViewController: UIViewController, DropDownMenuDelegate {

	var titleView: DropDownTitleView!
	@IBOutlet var navigationBarMenu: DropDownMenu!
	@IBOutlet var toolbarMenu: DropDownMenu!

	override func viewDidLoad() {
		super.viewDidLoad()
		
		let title = prepareNavigationBarMenuTitleView()

		prepareNavigationBarMenu(title)
		prepareToolbarMenu()
		updateMenuContentOffsets()
	}
	
	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)

		navigationBarMenu.container = view
		toolbarMenu.container = view
	}

	func prepareNavigationBarMenuTitleView() -> String {
		// Both title label and image view are fixed horizontally inside title
		// view, UIKit is responsible to center title view in the navigation bar.
		// We want to ensure the space between title and image remains constant, 
		// even when title view is moved to remain centered (but never resized).
		titleView = DropDownTitleView(frame: CGRect(x: 0, y: 0, width: 150, height: 40))
		titleView.addTarget(self,
		            action: #selector(ViewController.willToggleNavigationBarMenu(_:)),
		          forControlEvents: .TouchUpInside)
		titleView.addTarget(self,
		                    action: #selector(ViewController.didToggleNavigationBarMenu(_:)),
		          forControlEvents: .ValueChanged)
		titleView.titleLabel.textColor = UIColor.blackColor()
		titleView.title = "Large"

		navigationItem.titleView = titleView
		
		return titleView.title!
	}
	
	func prepareNavigationBarMenu(currentChoice: String) {
		navigationBarMenu = DropDownMenu(frame: view.bounds)
		navigationBarMenu.delegate = self
		
		let firstCell = DropDownMenuCell()
		
		firstCell.textLabel!.text = "Large"
		firstCell.menuAction = #selector(ViewController.choose(_:))
		firstCell.menuTarget = self
		if currentChoice == "Large" {
			firstCell.accessoryType = .Checkmark
		}
		
		let secondCell = DropDownMenuCell()
		
		secondCell.textLabel!.text = "Small"
		secondCell.menuAction = #selector(ViewController.choose(_:))
		secondCell.menuTarget = self
		if currentChoice == "Small" {
			firstCell.accessoryType = .Checkmark
		}

		navigationBarMenu.menuCells = [firstCell, secondCell]
		
		// If we set the container to the controller view, the value must be set
		// on the hidden content offset (not the visible one)
		navigationBarMenu.visibleContentOffset =
			navigationController!.navigationBar.frame.size.height + statusBarHeight()

		// For a simple gray overlay in background
		navigationBarMenu.backgroundView = UIView(frame: navigationBarMenu.bounds)
		navigationBarMenu.backgroundView!.backgroundColor = UIColor.blackColor()
		navigationBarMenu.backgroundAlpha = 0.7
	}

	func prepareToolbarMenu() {
		toolbarMenu = DropDownMenu(frame: view.bounds)
		toolbarMenu.delegate = self
		
		let selectCell = DropDownMenuCell()
		
		selectCell.textLabel!.text = "Select"
		selectCell.imageView!.image = UIImage(named: "Ionicons-ios-checkmark-outline")
		selectCell.showsCheckmark = false
		selectCell.menuAction = #selector(ViewController.select as (ViewController) -> () -> ())
		selectCell.menuTarget = self
		
		let sortKeys = ["Name", "Date", "Size"]
		let sortCell = DropDownMenuCell()
		let sortSwitcher = UISegmentedControl(items: sortKeys)

		sortSwitcher.selectedSegmentIndex = sortKeys.indexOf("Name")!
		sortSwitcher.addTarget(self, action: #selector(ViewController.sort(_:)), forControlEvents: .ValueChanged)

		sortCell.customView = sortSwitcher
		sortCell.textLabel!.text = "Sort"
		sortCell.imageView!.image = UIImage(named: "Ionicons-ios-search")
		sortCell.showsCheckmark = false

		toolbarMenu.menuCells = [selectCell, sortCell]
		toolbarMenu.direction = .Up

		// For a simple gray overlay in background
		toolbarMenu.backgroundView = UIView(frame: toolbarMenu.bounds)
		toolbarMenu.backgroundView!.backgroundColor = UIColor.blackColor()
		toolbarMenu.backgroundAlpha = 0.7
	}

	func updateMenuContentOffsets() {
		navigationBarMenu.visibleContentOffset =
			navigationController!.navigationBar.frame.size.height + statusBarHeight()
		toolbarMenu.visibleContentOffset =
			navigationController!.toolbar.frame.size.height
	}
	
	override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
		super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)

		coordinator.animateAlongsideTransition({ (context) in
			// If we put this only in -viewDidLayoutSubviews, menu animation is 
			// messed up when selecting an item
			self.updateMenuContentOffsets()
		}, completion: nil)
	}

	@IBAction func choose(sender: AnyObject) {
		titleView.title = (sender as! DropDownMenuCell).textLabel!.text
	}

	@IBAction func select() {
		print("Sent select action")
	}

	@IBAction func sort(sender: AnyObject) {
		print("Sent sort action")
	}

	@IBAction func showToolbarMenu() {
		if titleView.isUp {
			titleView.toggleMenu()
		}
		toolbarMenu.show()
	}

	@IBAction func willToggleNavigationBarMenu(sender: DropDownTitleView) {
		toolbarMenu.hide()

		if sender.isUp {
			navigationBarMenu.hide()
		}
		else {
			navigationBarMenu.show()
		}
	}

	@IBAction func didToggleNavigationBarMenu(sender: DropDownTitleView) {
		print("Sent did toggle navigation bar menu action")
	}

	func didTapInDropDownMenuBackground(menu: DropDownMenu) {
		if menu == navigationBarMenu {
			titleView.toggleMenu()
		}
		else {
			menu.hide()
		}
	}
}


func statusBarHeight() -> CGFloat {
	let statusBarSize = UIApplication.sharedApplication().statusBarFrame.size
	return min(statusBarSize.width, statusBarSize.height)
}
