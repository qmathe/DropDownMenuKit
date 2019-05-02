/*
	Copyright (C) 2016 Quentin Mathe
 
	Date:  August 2016
	License:  MIT
 */

import UIKit
import DropDownMenuKit

class ViewController: UIViewController, DropDownMenuDelegate {

	// MARK: - UI Elements

	var titleView: DropDownTitleView!
	@IBOutlet var navigationBarMenu: DropDownMenu!
	@IBOutlet var toolbarMenu: DropDownMenu!

	// MARK: - Initialization

	override func viewDidLoad() {
		super.viewDidLoad()
		let title = prepareNavigationBarMenuTitleView()

		prepareNavigationBarMenu(title)
		prepareToolbarMenu()

		navigationBarMenu.container = view
		toolbarMenu.container = view
	}

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		updateMenuContentInsets()
	}

	func prepareNavigationBarMenuTitleView() -> String {
		titleView = DropDownTitleView()
		titleView.addTarget(self,
		            action: #selector(ViewController.willToggleNavigationBarMenu(_:)),
		               for: .touchUpInside)
		titleView.addTarget(self,
		            action: #selector(ViewController.didToggleNavigationBarMenu(_:)),
		               for: .valueChanged)
		titleView.titleLabel.textColor = UIColor.black

		navigationItem.titleView = titleView
		
		return titleView.title!
	}
	
	func prepareNavigationBarMenu(_ currentChoice: String) {
		navigationBarMenu = DropDownMenu(frame: view.bounds)
		navigationBarMenu.delegate = self
		
		let firstCell = DropDownMenuCell()
		let longTitle = "The quick brown fox jumps over the lazy dog"
		
		firstCell.textLabel!.text = longTitle
		firstCell.menuAction = #selector(ViewController.choose(_:))
		firstCell.menuTarget = self
		if currentChoice == longTitle {
			firstCell.accessoryType = .checkmark
		}
		
		let secondCell = DropDownMenuCell()
		let shortTitle = "Short"
		
		secondCell.textLabel!.text = shortTitle
		secondCell.rowHeight = 60
		secondCell.menuAction = #selector(ViewController.choose(_:))
		secondCell.menuTarget = self
		if currentChoice == shortTitle {
			firstCell.accessoryType = .checkmark
		}

		navigationBarMenu.menuCells = [firstCell, secondCell]
		navigationBarMenu.selectMenuCell(secondCell)

		// For a simple gray overlay in background
		navigationBarMenu.backgroundView = UIView(frame: navigationBarMenu.bounds)
		navigationBarMenu.backgroundView!.backgroundColor = UIColor.black
		navigationBarMenu.backgroundAlpha = 0.7
	}

	func prepareToolbarMenu() {
		toolbarMenu = DropDownMenu(frame: view.bounds)
		toolbarMenu.delegate = self
		
		let selectCell = DropDownMenuCell()
		
		selectCell.textLabel!.text = "Change Title Icons"
		selectCell.imageView!.image = UIImage(named: "Ionicons-ios-checkmark-outline")
		selectCell.showsCheckmark = false
		selectCell.menuAction = #selector(ViewController.changeTitleIcons as (ViewController) -> () -> ())
		selectCell.menuTarget = self
		
		let sortKeys = ["Name", "Date", "Size"]
		let sortCell = DropDownMenuCell()
		let sortSwitcher = UISegmentedControl(items: sortKeys)

		sortSwitcher.selectedSegmentIndex = sortKeys.firstIndex(of: "Name")!
		sortSwitcher.addTarget(self, action: #selector(ViewController.sort(_:)), for: .valueChanged)

		sortCell.customView = sortSwitcher
		sortCell.textLabel!.text = "Sort"
		sortCell.imageView!.image = UIImage(named: "Ionicons-ios-search")
		sortCell.showsCheckmark = false

		toolbarMenu.menuCells = [selectCell, sortCell]
		toolbarMenu.direction = .up

		// For a simple gray overlay in background
		toolbarMenu.backgroundView = UIView(frame: toolbarMenu.bounds)
		toolbarMenu.backgroundView!.backgroundColor = UIColor.black
		toolbarMenu.backgroundAlpha = 0.7
	}

	// MARK: - Layout

	func updateMenuContentInsets() {
		var visibleContentInsets: UIEdgeInsets

		if #available(iOS 11, *) {
			visibleContentInsets = view.safeAreaInsets
		} else {
			visibleContentInsets =
				UIEdgeInsets(top: navigationController!.navigationBar.frame.size.height + statusBarHeight(),
				            left: 0,
				          bottom: navigationController!.toolbar.frame.size.height,
				           right: 0)
		}

		navigationBarMenu.visibleContentInsets = visibleContentInsets
		toolbarMenu.visibleContentInsets = visibleContentInsets
	}
	
	override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
		super.viewWillTransition(to: size, with: coordinator)

		coordinator.animate(alongsideTransition: { _ in
			// If we put this only in -viewDidLayoutSubviews, menu animation is 
			// messed up when selecting an item
			self.updateMenuContentInsets()
		}, completion: nil)
	}

	// MARK: - Updating UI

	func validateBarItems() {
		navigationItem.leftBarButtonItem?.isEnabled = titleView.isUp && !navigationBarMenu.menuCells.isEmpty
		navigationItem.rightBarButtonItem?.isEnabled = titleView.isUp
	}

	// MARK: - Actions

	@IBAction func choose(_ sender: AnyObject) {
		titleView.title = (sender as! DropDownMenuCell).textLabel!.text
	}

	@IBAction func removeNavigationBarMenuCell() {
		navigationBarMenu.menuCells = Array(navigationBarMenu.menuCells.dropLast())
		validateBarItems()
	}

	@IBAction func addNavigationBarMenuCell() {
		let cell = DropDownMenuCell()

		cell.textLabel!.text = String(navigationBarMenu.menuCells.count)
		cell.menuAction = #selector(ViewController.choose(_:))
		cell.menuTarget = self

		navigationBarMenu.menuCells += [cell]
		validateBarItems()
	}

	@IBAction func changeTitleIcons() {
		titleView.iconSize = CGSize(width: 24, height: 24)
        titleView.menuDownImageView.image = UIImage(named: "Ionicons-ios-checkmark-outline")
        titleView.menuDownImageView.transform = CGAffineTransform.identity
        titleView.menuDownImageView.tintColor = UIColor.green
        titleView.menuUpImageView.image = UIImage(named: "Ionicons-ios-search")
	}

	@IBAction func sort(_ sender: AnyObject) {
		print("Sent sort action")
	}

	@IBAction func showToolbarMenu() {
		if titleView.isUp {
			titleView.toggleMenu()
		}
		toolbarMenu.show()
	}

	@IBAction func willToggleNavigationBarMenu(_ sender: DropDownTitleView) {
		toolbarMenu.hide()

		if sender.isUp {
			navigationBarMenu.hide()
		} else {
			navigationBarMenu.show()
		}
	}

	@IBAction func didToggleNavigationBarMenu(_ sender: DropDownTitleView) {
		print("Sent did toggle navigation bar menu action")
		validateBarItems()
	}

	func didTapInDropDownMenuBackground(_ menu: DropDownMenu) {
		if menu == navigationBarMenu {
			titleView.toggleMenu()
		} else {
			menu.hide()
		}
	}
}


func statusBarHeight() -> CGFloat {
	let statusBarSize = UIApplication.shared.statusBarFrame.size
	return min(statusBarSize.width, statusBarSize.height)
}
