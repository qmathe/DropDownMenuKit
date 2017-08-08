/**
	Copyright (C) 2015 Quentin Mathe
 
	Date:  June 2015
	License:  MIT
 */

import UIKit

open class DropDownTitleView : UIControl {

    open var iconSize = CGSize(width: 12, height: 12) {
        didSet {
            setNeedsLayout()
        }
    }
	open lazy var menuDownImageView: UIImageView = {
		let menuDownImageView = UIImageView(image: self.imageNamed("Ionicons-chevron-up"))

        menuDownImageView.tintColor = UIColor.black
		menuDownImageView.transform = CGAffineTransform(scaleX: 1, y: -1)

		return menuDownImageView
	}()
	open lazy var menuUpImageView: UIImageView = {
		let menuUpImageView = UIImageView(image: self.imageNamed("Ionicons-chevron-up"))

        menuUpImageView.tintColor = UIColor.black

		return menuUpImageView
	}()
	open lazy var imageView: UIView = {
		// For flip animation, we need a container view
		// See http://stackoverflow.com/questions/11847743/transitionfromview-and-strange-behavior-with-flip
		return UIView(frame: CGRect(origin: CGPoint.zero, size: self.iconSize))
	}()
	open lazy var titleLabel: UILabel = {
		let titleLabel = UILabel()

		titleLabel.font = UIFont.boldSystemFont(ofSize: titleLabel.font.pointSize)
		titleLabel.textColor = UIColor.white

		return titleLabel
	}()
	open var title: String? {
		get {
			return titleLabel.text
		}
		set {
			titleLabel.text = newValue
            titleLabel.sizeToFit()
            titleWidth = titleLabel.frame.width
			layoutSubviews()
		}
	}
    private var titleWidth: CGFloat = 0
	open var isUp: Bool { return menuUpImageView.superview != nil }
	open var toggling = false
	
	// MARK: - Initialization
	
	override public init(frame: CGRect) {
		super.init(frame: frame)
		setUp()
	}

	required public init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	// To support adding outlets/actions later and access them during initialization
	override open func awakeFromNib() {
		setUp()
	}

	func setUp() {
		imageView.addSubview(menuDownImageView)

		addSubview(titleLabel)
		addSubview(imageView)
        
        autoresizingMask = [.flexibleWidth, .flexibleHeight]

		let recognizer = UITapGestureRecognizer(target: self, action: #selector(DropDownTitleView.toggleMenu))
	
		isUserInteractionEnabled = true
		addGestureRecognizer(recognizer)
		
		title = "Untitled"
	}
	
	func imageNamed(_ name: String) -> UIImage {
		let bundle = Bundle(for: type(of: self))
		return UIImage(named: name, in: bundle, compatibleWith: nil)!
	}
	
	// MARK: - Layout
    
    private  let spacing: CGFloat = 4
    
    open override func willMove(toSuperview newSuperview: UIView?) {
        guard let superview = newSuperview else {
            return
        }
		// Will trigger layoutSubviews() without having resize the title view yet
		// e.g. (origin = (x = 0, y = 0), size = (width = 320, height = 44)
        frame = superview.bounds
    }

	// Centers the title when DropDownMenu.selectMenuCell() isn't called while creating the menu
	open override func didMoveToWindow() {
		// Will trigger layoutSubviews() with the title view resized according to autoresizing
		// e.g. (origin = (x = 58, y = 0), size = (width = 211.5, height = 44))
		layoutSubviews()
	}
	
	open override func layoutSubviews() {
		super.layoutSubviews()

        menuDownImageView.frame.size = iconSize
        menuUpImageView.frame.size = iconSize
        imageView.frame.size = iconSize
        
        let maxTitleWidth = frame.width - 2 * (spacing + imageView.frame.width)
		
		titleLabel.center = CGPoint(x: frame.width / 2, y: frame.height / 2)
        if titleWidth > maxTitleWidth {
            titleLabel.frame.origin.x = spacing + imageView.frame.width
            titleLabel.frame.size.width = maxTitleWidth
        } else {
            titleLabel.frame.size.width = titleWidth
        }

		imageView.frame.origin.x = titleLabel.frame.maxX + spacing
		imageView.center.y = frame.height / 2
	}
	
	// MARK: - Actions
	
	@IBAction open func toggleMenu() {
		if toggling {
			return
		}
		toggling = true
		let viewToReplace = isUp ? menuUpImageView : menuDownImageView
		let replacementView = isUp ? menuDownImageView : menuUpImageView
		let options = isUp ? UIViewAnimationOptions.transitionFlipFromTop : UIViewAnimationOptions.transitionFlipFromBottom
		
		sendActions(for: .touchUpInside)

		UIView.transition(from: viewToReplace,
		                  to: replacementView,
		                duration: 0.4,
		                 options: options,
		              completion: { (Bool) in
			self.sendActions(for: .valueChanged)
			self.toggling = false
		})
	}
}
