
import Foundation
import UIKit

public extension UIBarButtonItem {
    
    public static var defaultFixedSpace: CGFloat {
        return 16
    }
    
    /// Needed to fix the 16pt insets for Bar Buttons with custom views introduced in iOS7
    public static var fixedSpaceItem: UIBarButtonItem {
        let spacer = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FixedSpace, target: nil, action: nil)
        spacer.width = -UIBarButtonItem.defaultFixedSpace
        return spacer
    }
    
}

public enum CDAnimatedBarButtonItemCallbackTiming: Int {
    case Immediately = 0
    case FirstHalf
    case SecondHalf
}


public struct CDAnimatedBarButtonItemOptions {
    public var rippleColor: UIColor = UIColor.blackColor().colorWithAlphaComponent(0.10)
    public var contentMode: UIViewContentMode = .ScaleAspectFit
    public var font: UIFont?
    public var animationDuration: CGFloat = 0.4
    public var animationScaleFactor: CGFloat = 0.65
    public var textColor: UIColor?
    public var frame: CGRect?
    public var title: String?
    public var icon: UIImage?
    public var callback: ((animatedBarButtonItem: CDAnimatedBarButtonItem?) -> Void)? = nil
    public var callbackTiming: CDAnimatedBarButtonItemCallbackTiming = .FirstHalf
    
    public static var defaults: CDAnimatedBarButtonItemOptions {
        return CDAnimatedBarButtonItemOptions()
    }
}

public typealias CDAnimatedBarButtonCallback = (animatedBarButtonItem: CDAnimatedBarButtonItem?) -> Void

public class CDAnimatedBarButtonItem: UIBarButtonItem {
    
    class NotifyingButton: UIButton {
        
        var onDidMoveToSuperView: ((notifyingButton: NotifyingButton, superview: UIView?) -> Void)?
        
        override func didMoveToSuperview() {
            super.didMoveToSuperview()
            
            if let superview = self.superview {
                onDidMoveToSuperView?(notifyingButton: self, superview: superview)
            } else {
                onDidMoveToSuperView?(notifyingButton: self, superview: nil)
                onDidMoveToSuperView = nil
            }
        }
        
        override func alignmentRectInsets() -> UIEdgeInsets {
            return UIEdgeInsetsZero
        }
        
    }
    
    public var options: CDAnimatedBarButtonItemOptions = CDAnimatedBarButtonItemOptions.defaults {
        
        didSet {
            updateUI()
        }
    }
    
    public var onTapCallback: CDAnimatedBarButtonCallback?
    public var onDidMoveToSuperViewCallback: CDAnimatedBarButtonCallback?
    
    
    @IBInspectable public var font: UIFont? {
        set {
            self.options.font = newValue
            updateUI()
        }
        
        get {
            return self.options.font
        }
    }
    
    @IBInspectable public var textColor: UIColor? {
        set {
            self.options.textColor = newValue
            updateUI()
        }
        
        get {
            return self.options.textColor
        }
    }
    
    @IBInspectable public var rippleColor: UIColor? {
        set {
            self.options.rippleColor = newValue ?? CDAnimatedBarButtonItemOptions.defaults.rippleColor
            updateUI()
        }
        
        get {
            return self.options.rippleColor
        }
    }
    
    public var contentMode: UIViewContentMode? {
        set {
            self.options.contentMode = newValue ?? CDAnimatedBarButtonItemOptions.defaults.contentMode
            updateUI()
        }
        
        get {
            return self.options.contentMode
        }
    }
    
    @IBInspectable public var frame: CGRect? {
        set {
            self.options.frame = newValue
            updateUI()
        }
        
        get {
            return self.options.frame
        }
    }
    
    @IBInspectable public var icon: UIImage? {
        set {
            self.options.icon = newValue
            updateUI()
        }
        
        get {
            return self.options.icon
        }
    }
    
    @IBInspectable public var text: String? {
        set {
            self.options.title = newValue
            updateUI()
        }
        
        get {
            return self.options.title
        }
    }
    
    public override var title: String? {
        get {
            return self.options.title
        }
        
        set {
            self.options.title = newValue
            updateUI()
        }
    }
    
    private weak var label: UILabel?
    private weak var imageView: UIImageView?
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    public override init() {
        super.init()
        commonInit()
    }
    public init(title: String?, callback: CDAnimatedBarButtonCallback) {
        super.init()
        onTapCallback = callback
        self.title = title
        commonInit()
    }
    
    public init(icon: UIImage?, callback: CDAnimatedBarButtonCallback) {
        super.init()
        onTapCallback = callback
        self.icon = icon
        commonInit()
        
    }
    
    public init(icon: UIImage?, contentMode: UIViewContentMode, callback: CDAnimatedBarButtonCallback) {
        super.init()
        self.onTapCallback = callback
        self.icon = icon
        commonInit()
        self.contentMode = contentMode
    }
    
    public init(options: CDAnimatedBarButtonItemOptions, callback: CDAnimatedBarButtonCallback) {
        super.init()
        self.options = options
        commonInit()
        self.onTapCallback = callback
    }
    
    public func commonInit() {
        updateUI()
    }
    
    private func updateUI() {
        
        let frame = self.frame ?? CGRectMake(0, 0, 38, 38)
        var buttonCustomView: UIView
        if let text = self.text {
            let label = UILabel()
            label.backgroundColor = UIColor.clearColor()
            label.textColor = self.textColor ?? self.tintColor
            label.font = self.font ?? UIFont.systemFontOfSize(UIFont.buttonFontSize())
            label.text = text
            label.textAlignment = .Center
            label.minimumScaleFactor = 0.2
            label.adjustsFontSizeToFitWidth = true
            buttonCustomView = label
            self.label = label
        } else {
            let imageView = UIImageView()
            imageView.backgroundColor = UIColor.clearColor()
            imageView.image = icon
            imageView.contentMode = self.contentMode ?? .ScaleAspectFit
            imageView.tintColor = tintColor
            buttonCustomView = imageView
            self.imageView = imageView
        }
        
        let button = NotifyingButton(type: UIButtonType.Custom)
        button.onDidMoveToSuperView = { [weak self] (notifyingButton, superview) in
            guard let welf = self else {
                return
            }
            
            welf.onDidMoveToSuperViewCallback?(animatedBarButtonItem: welf)
        }
        
        button.frame = frame
        buttonCustomView.frame = button.bounds
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 0
        button.autoresizingMask = UIViewAutoresizing.FlexibleHeight.union(.FlexibleWidth)
        button.addSubview(buttonCustomView)
        button.addTarget(self, action: #selector(tapAction(_:)), forControlEvents: .TouchUpInside)
        button.setNeedsUpdateConstraints()
        button.setNeedsLayout()
        button.setNeedsDisplay()
        button.updateConstraintsIfNeeded()
        button.layoutIfNeeded()
        self.customView = button
    }
    
    public func addTargetForAction(target: AnyObject, action: Selector) {
        self.target = target
        self.action = action
    }
    
    public func tapAction(sender: AnyObject?) {
        
        guard let button = self.customView as? UIButton else {
            onTapCallback?(animatedBarButtonItem: self)
            return
        }
        
        guard let subview = button.subviews.first else {
            onTapCallback?(animatedBarButtonItem: self)
            return
        }
        
        if self.options.callbackTiming == .Immediately {
            onTapCallback?(animatedBarButtonItem: self)
        }
        
        let halfDuration = Double(self.options.animationDuration/2)
        UIView.animateWithDuration(halfDuration, animations: {
            subview.transform = CGAffineTransformMakeScale(self.options.animationScaleFactor, self.options.animationScaleFactor)
            button.backgroundColor = self.options.rippleColor
        }) { complete in
            
            if self.options.callbackTiming == .FirstHalf {
                self.onTapCallback?(animatedBarButtonItem: self)
            }
            
            UIView.animateWithDuration(halfDuration, animations: {
                button.backgroundColor = UIColor.clearColor()
                subview.transform = CGAffineTransformIdentity
            }) { complete in
                if self.options.callbackTiming == .SecondHalf {
                    self.onTapCallback?(animatedBarButtonItem: self)
                }
            }
        }
    }
}
