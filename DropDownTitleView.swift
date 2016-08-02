/**
	Copyright (C) 2015 Quentin Mathe
 
	Date:  June 2015
	License:  MIT
 */

import UIKit

public class DropDownTitleView : UIControl {

	static var iconSize = CGSize(width: 12, height: 12)
	lazy var menuDownImageView: UIImageView = {
		let menuDownImageView = UIImageView(image: UIImage(named: "Ionicons-chevron-up"))

		menuDownImageView.frame.size = DropDownTitleView.iconSize
		menuDownImageView.transform = CGAffineTransformMakeScale(1, -1)

		return menuDownImageView
	}()
	lazy var menuUpImageView: UIImageView = {
		let menuUpImageView = UIImageView(image: UIImage(named: "Ionicons-chevron-up"))

		menuUpImageView.frame.size = DropDownTitleView.iconSize

		return menuUpImageView
	}()
	lazy var imageView: UIView = {
		// For flip animation, we need a container view
		// See http://stackoverflow.com/questions/11847743/transitionfromview-and-strange-behavior-with-flip
		let imageView = UIView(frame: CGRect(origin: CGPoint.zero, size: DropDownTitleView.iconSize))
		
		imageView.autoresizingMask = [.FlexibleTopMargin, .FlexibleBottomMargin]

		return imageView
	}()
	lazy var titleLabel: UILabel = {
		let titleLabel = UILabel()

		titleLabel.font = UIFont.boldSystemFontOfSize(titleLabel.font.pointSize)
		titleLabel.textColor = UIColor.whiteColor()
		titleLabel.autoresizingMask = [.FlexibleTopMargin, .FlexibleBottomMargin]

		return titleLabel
	}()
	public var title: String? {
		get {
			return titleLabel.text
		}
		set {
			titleLabel.text = newValue
	
			titleLabel.sizeToFit()
			layoutSubviews()
			sizeToFit()
		}
	}
	public var isUp: Bool { return menuUpImageView.superview != nil }
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setUp()
	}

	required public init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	// To support adding outlets/actions later and access them during initialization
	override public func awakeFromNib() {
		setUp()
	}

	func setUp() {
		imageView.addSubview(menuDownImageView)

		addSubview(titleLabel)
		addSubview(imageView)

		let recognizer = UITapGestureRecognizer(target: self, action: #selector(DropDownTitleView.toggleMenu))
	
		userInteractionEnabled = true
		addGestureRecognizer(recognizer)
		
		title = "Untitled"
	}
	
	override public func sizeThatFits(size: CGSize) -> CGSize {
		return CGSize(width: imageView.frame.maxX, height: frame.size.height)
	}
	
	public override func layoutSubviews() {
		super.layoutSubviews()
		
		titleLabel.frame.origin.x = 0
		titleLabel.center.y = frame.height / 2

		imageView.frame.origin.x = titleLabel.frame.maxX + 4
		imageView.center.y = frame.height / 2
	}
	
	public func toggleMenu() {
		let viewToReplace = isUp ? menuUpImageView : menuDownImageView
		let replacementView = isUp ? menuDownImageView : menuUpImageView
		let options = isUp ? UIViewAnimationOptions.TransitionFlipFromTop : UIViewAnimationOptions.TransitionFlipFromBottom
		
		sendActionsForControlEvents(.TouchUpInside)

		UIView.transitionFromView(viewToReplace,
		                  toView: replacementView,
		                duration: 0.4,
		                 options: options,
		              completion: { (Bool) in self.sendActionsForControlEvents(.ValueChanged) })
	}
}
