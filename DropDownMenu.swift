/**
	Copyright (C) 2015 Quentin Mathe
 
	Date:  May 2015
	License:  MIT
 */

import UIKit

@objc public protocol DropDownMenuDelegate {
	func didTapInDropDownMenuBackground(menu: DropDownMenu)
}

public enum DropDownMenuRevealDirection {
	case Up
	case Down
}


public class DropDownMenu : UIView, UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate {

	public weak var delegate: DropDownMenuDelegate?
	public var container: UIView! {
		didSet {
			removeFromSuperview()
			container.addSubview(self)
		}
	}
	// The content view fills the entire container, so we can use it to fade 
	// the background view in and out.
	//
	// By default, it contains the menu view, but other subviews can be added to 
	// it and laid out by overriding -layoutSubviews.
	public let contentView: UIView
	// This hidden offset can be used to customize the position of the menu at
	// the end of the hiding animation.
	//
	// If the container doesn't extend under the toolbar and navigation bar,
	// this is useful to ensure the hiding animation continues until the menu is
	// positioned outside of the screen, rather than stopping the animation when 
	// the menu is covered by the toolbar or navigation bar.
	public var hiddenContentOffset = CGFloat(0)
	// This visible offset can be used to customize the position of the menu 
	// at the end of the showing animation.
	//
	// If the container extends under the toolbar and navigation bar, this is 
	// useful to ensure the menu won't be covered by the toolbar or navigation 
	// bar once the showing animation is done.
	public var visibleContentOffset = CGFloat(0) {
		didSet {
			if hidden {
				return
			}
			if direction == .Down {
				contentView.frame.origin.y = visibleContentOffset
			}
			else {
				contentView.frame.origin.y = container.frame.height - contentView.frame.height - visibleContentOffset
			}
		}
	}
	public var direction = DropDownMenuRevealDirection.Down
	public let menuView: UITableView
	public var menuCells = [DropDownMenuCell]() {
		didSet {
			menuView.reloadData()
		}
	}
	// The background view to be faded out with the background alpha, when the 
	// menu slides over it
	public var backgroundView: UIView? {
		didSet {
			oldValue?.removeFromSuperview()
			backgroundView?.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
			if let backgroundView = backgroundView {
				insertSubview(backgroundView, belowSubview: contentView)
			}
		}
	}
	public var backgroundAlpha = CGFloat(1)
	
	// MARK: - Initialization
	
	override public init(frame: CGRect) {
		contentView = UIView(frame: CGRect(origin: CGPoint.zero, size: frame.size))
		contentView.autoresizingMask = [.FlexibleWidth, .FlexibleBottomMargin]
		
		menuView = UITableView(frame: CGRect(origin: CGPoint.zero, size: frame.size))
		menuView.autoresizingMask = .FlexibleWidth
		menuView.scrollEnabled = false

		contentView.addSubview(menuView)

		super.init(frame: frame)
		
		let gesture = UITapGestureRecognizer(target: self, action: #selector(DropDownMenu.tap(_:)))
		gesture.delegate = self
		addGestureRecognizer(gesture)

		menuView.dataSource = self
		menuView.delegate = self

		autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
		hidden = true

		addSubview(contentView)
	}

	required public init?(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - Layout
	
	public override func layoutSubviews() {
		super.layoutSubviews()
		
		menuView.sizeToFit()
		contentView.frame.size.height = menuView.frame.size.height
	}
	
	// MARK: - Actions
	
	@IBAction public func tap(sender: AnyObject) {
		delegate?.didTapInDropDownMenuBackground(self)
	}
	
	// If we declare a protocol method private, it is not called anymore.
	public func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
		precondition(gestureRecognizer.view == self)

		guard let touchedView = touch.view else {
			return true
		}
		return !touchedView.isDescendantOfView(menuView)
	}
	
	@IBAction public func show() {
		precondition(container != nil, "DropDownMenu.container must be set in [presentingController viewDidAppear:]")
		
		if !hidden {
			return
		}

		backgroundView?.alpha = 0
		if direction == .Down {
			contentView.frame.origin.y = -(contentView.frame.height + hiddenContentOffset)
		}
		else {
			contentView.frame.origin.y = container.frame.height + hiddenContentOffset
		}
		hidden = false

		UIView.animateWithDuration(0.4,
		                    delay: 0,
		   usingSpringWithDamping: 1,
		    initialSpringVelocity: 1,
		                  options: .CurveEaseInOut,
		               animations: {
			if self.direction == .Down {
				self.contentView.frame.origin.y = self.visibleContentOffset
			}
			else {
				self.contentView.frame.origin.y = self.container.frame.height - self.contentView.frame.height  - self.visibleContentOffset
			}
			self.backgroundView?.alpha = self.backgroundAlpha
		},
		               completion: nil)
	}
	
	@IBAction public func hide() {
	
		if hidden {
			return
		}

		if direction == .Down {
			contentView.frame.origin.y = visibleContentOffset
		}
		else {
			contentView.frame.origin.y = container.frame.height - contentView.frame.height - visibleContentOffset
		}
		hidden = false
		
		UIView.animateWithDuration(0.4,
		                    delay: 0,
		   usingSpringWithDamping: 1,
		    initialSpringVelocity: 1,
		                  options: .CurveEaseInOut,
		               animations: {
			if self.direction == .Down {
				self.contentView.frame.origin.y = -(self.contentView.frame.height + self.hiddenContentOffset)
			}
			else {
				self.contentView.frame.origin.y = self.container.frame.height + self.hiddenContentOffset
			}
			self.backgroundView?.alpha = 0
		},
				       completion: { (Bool) in
			self.hidden = true
		})
	}
	
	// MARK: - Table View
	
	public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 1
	}

	public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return menuCells.count
	}

	public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		return menuCells[indexPath.row]
	}
	
	public func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
		return menuCells[indexPath.row].menuAction != nil
	}

	public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		let cell = menuCells[indexPath.row]
		
		for cell in menuCells {
			cell.accessoryType = .None
		}
		cell.accessoryType = cell.showsCheckmark ? .Checkmark : .None
		
		tableView.deselectRowAtIndexPath(indexPath, animated: true)
		
		if cell.menuAction == nil {
			return
		}

		UIApplication.sharedApplication().sendAction(cell.menuAction, to: cell.menuTarget, from: cell, forEvent: nil)
	}
}
