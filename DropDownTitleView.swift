/**
	Copyright (C) 2015 Quentin Mathe
 
	Date:  June 2015
	License:  MIT
 */

import UIKit

public struct DropDownTitleConfig {
    let menuDownImageView : UIImageView
    let menuUpImageView: UIImageView
    
    public init(menuUpImage: UIImage, menuDownImage: UIImage) {
        self.menuUpImageView = UIImageView(image: menuUpImage)
        self.menuDownImageView = UIImageView(image: menuDownImage)
    }
}

open class DropDownTitleView : UIControl {
    
    open static var iconSize = CGSize(width: 12, height: 12)
    fileprivate var config : DropDownTitleConfig?
    
    open lazy var menuDownImageView: UIImageView = {
        if let imageView = self.config?.menuDownImageView {
            imageView.transform = CGAffineTransform(scaleX: 1, y: -1)
            return imageView
        } else {
            let menuDownImageView = UIImageView(image: self.imageNamed("Ionicons-chevron-up"))
            
            menuDownImageView.frame.size = DropDownTitleView.iconSize
            menuDownImageView.transform = CGAffineTransform(scaleX: 1, y: -1)
            
            return menuDownImageView
        }
    }()
    open lazy var menuUpImageView: UIImageView = {
        if let imageView = self.config?.menuUpImageView {
            return imageView
        } else {
            let menuUpImageView = UIImageView(image: self.imageNamed("Ionicons-chevron-up"))
            
            menuUpImageView.frame.size = DropDownTitleView.iconSize
            
            return menuUpImageView
        }
    }()
    open lazy var imageView: UIView = {
        // For flip animation, we need a container view
        // See http://stackoverflow.com/questions/11847743/transitionfromview-and-strange-behavior-with-flip
        let imageView = UIView(frame: CGRect(origin: CGPoint.zero, size: DropDownTitleView.iconSize))
        
        imageView.autoresizingMask = [.flexibleTopMargin, .flexibleBottomMargin]
        
        return imageView
    }()
    open lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        
        titleLabel.font = UIFont.boldSystemFont(ofSize: titleLabel.font.pointSize)
        titleLabel.textColor = UIColor.white
        titleLabel.autoresizingMask = [.flexibleTopMargin, .flexibleBottomMargin]
        
        return titleLabel
    }()
    open var title: String? {
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
    open var isUp: Bool { return menuUpImageView.superview != nil }
    open var toggling = false
    
    // MARK: - Initialization
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    public init(frame: CGRect, config: DropDownTitleConfig) {
        super.init(frame: frame)
        self.config = config
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
    
    override open func sizeThatFits(_ size: CGSize) -> CGSize {
        return CGSize(width: imageView.frame.maxX, height: frame.size.height)
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        
        titleLabel.frame.origin.x = 0
        titleLabel.center.y = frame.height / 2
        
        imageView.frame.origin.x = titleLabel.frame.maxX + 4
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
