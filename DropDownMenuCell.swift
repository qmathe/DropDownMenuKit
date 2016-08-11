/**
	Copyright (C) 2015 Quentin Mathe
 
	Date:  May 2015
	License:  MIT
 */

import UIKit

public class DropDownMenuCell : UITableViewCell {
	
	public var customView: UIView? {
		didSet {
			guard let customView = customView else {
				return
			}
			contentView.addSubview(customView)
		}
	}
	public var menuAction: Selector!
	public weak var menuTarget: AnyObject!
	public var showsCheckmark = true
	
	// MARK: - Initialization

	override public init(style: UITableViewCellStyle, reuseIdentifier: String?) {
		 fatalError("init(style:reuseIdentifier:) is not supported")
	}
	
	public init() {
		super.init(style: .Default, reuseIdentifier: NSStringFromClass(DropDownMenuCell.self))
	}

	required public init?(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - Layout
	
	private var iconSize = CGSize(width: 24, height: 24)

	override public func layoutSubviews() {
	
		if let textLabel = textLabel {
			if customView != nil && textLabel.text == nil {
				textLabel.text = "Custom View Origin Hint"
			}
			textLabel.hidden = customView != nil
		}

		super.layoutSubviews()

		if let imageView = imageView where imageView.image != nil {
			imageView.frame.size = iconSize
			imageView.center = CGPoint(x: imageView.center.x, y: bounds.size.height / 2)
		}
		
		if let customView = customView {
			if let textLabel = textLabel where imageView?.image != nil {
				customView.frame.origin.x = textLabel.frame.origin.x
			}
			else
			{
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
