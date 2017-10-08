/**
	Copyright (C) 2015 Quentin Mathe
 
	Date:  May 2015
	License:  MIT
 */

import UIKit

open class DropDownMenuCell : UITableViewCell {
	
	open var customView: UIView? {
		didSet {
			guard let customView = customView else {
				return
			}
			contentView.addSubview(customView)
		}
	}
	open var menuAction: Selector!
	open weak var menuTarget: AnyObject!
	open var showsCheckmark = true
	open var rowHeight: CGFloat = 44

	// MARK: - Initialization

	override public init(style: UITableViewCellStyle, reuseIdentifier: String?) {
		 fatalError("init(style:reuseIdentifier:) is not supported")
	}
	
	public init() {
		super.init(style: .default, reuseIdentifier: NSStringFromClass(DropDownMenuCell.self))
		textLabel?.text = "Untitled"
	}

	required public init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - Layout
	
	open var iconSize = CGSize(width: 24, height: 24)

	override open func layoutSubviews() {
	
		if let textLabel = textLabel {
			if customView != nil && textLabel.text == nil {
				textLabel.text = "Custom View Origin Hint"
			}
			textLabel.isHidden = customView != nil
		}

		super.layoutSubviews()

		if let imageView = imageView, imageView.image != nil {
			imageView.frame.size = iconSize
			imageView.center = CGPoint(x: imageView.center.x, y: bounds.size.height / 2)
		}
		
		if let customView = customView {
			if let textLabel = textLabel, imageView?.image != nil {
				customView.frame.origin.x = textLabel.frame.origin.x
			} else {
				customView.center.x = bounds.width / 2
			}
			customView.center.y =  bounds.height / 2
			
			let margin: CGFloat = 5 // imageView?.frame.origin.x ?? 15
			
			if customView.frame.maxX + margin > bounds.width {
				customView.frame.size.width = bounds.width - customView.frame.origin.x - margin
			}
		}
	}
}
