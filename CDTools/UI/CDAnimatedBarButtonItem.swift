
import Foundation
import UIKit

public extension UIBarButtonItem {
    
    public static var defaultFixedSpace: CGFloat {
        return 16
    }
    
    /// Needed to fix the 16pt insets for Bar Buttons with custom views introduced in iOS7
    public static var fixedSpaceItem: UIBarButtonItem {
        let spacer = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.fixedSpace, target: nil, action: nil)
        spacer.width = -UIBarButtonItem.defaultFixedSpace
        return spacer
    }
    
}

public enum CDAnimatedBarButtonItemCallbackTiming: Int {
    case immediately = 0
    case firstHalf
    case secondHalf
}


public struct CDAnimatedBarButtonItemOptions {
    public var rippleColor: UIColor = UIColor.black.withAlphaComponent(0.10)
    public var contentMode: UIViewContentMode = .scaleAspectFit
    public var font: UIFont?
    public var animationDuration: CGFloat = 0.4
    public var animationScaleFactor: CGFloat = 0.65
    public var textColor: UIColor?
    public var frame: CGRect?
    public var title: String?
    public var icon: UIImage?
    public var callback: ((_ animatedBarButtonItem: CDAnimatedBarButtonItem?) -> Void)? = nil
    public var callbackTiming: CDAnimatedBarButtonItemCallbackTiming = .firstHalf
    
    public static var defaults: CDAnimatedBarButtonItemOptions {
        return CDAnimatedBarButtonItemOptions()
    }
}

public typealias CDAnimatedBarButtonCallback = (_ animatedBarButtonItem: CDAnimatedBarButtonItem?) -> Void

open class CDAnimatedBarButtonItem: UIBarButtonItem {
    
    class NotifyingButton: UIButton {
        
        var onDidMoveToSuperView: ((_ notifyingButton: NotifyingButton, _ superview: UIView?) -> Void)?
        
        override func didMoveToSuperview() {
            super.didMoveToSuperview()
            
            if let superview = self.superview {
                onDidMoveToSuperView?(self, superview)
            } else {
                onDidMoveToSuperView?(self, nil)
                onDidMoveToSuperView = nil
            }
        }
        
        override var alignmentRectInsets : UIEdgeInsets {
            return UIEdgeInsets.zero
        }
        
    }
    
    open var options: CDAnimatedBarButtonItemOptions = CDAnimatedBarButtonItemOptions.defaults {
        
        didSet {
            updateUI()
        }
    }
    
    open var onTapCallback: CDAnimatedBarButtonCallback?
    open var onDidMoveToSuperViewCallback: CDAnimatedBarButtonCallback?
    
    
    @IBInspectable open var font: UIFont? {
        set {
            self.options.font = newValue
            updateUI()
        }
        
        get {
            return self.options.font
        }
    }
    
    @IBInspectable open var textColor: UIColor? {
        set {
            self.options.textColor = newValue
            updateUI()
        }
        
        get {
            return self.options.textColor
        }
    }
    
    @IBInspectable open var rippleColor: UIColor? {
        set {
            self.options.rippleColor = newValue ?? CDAnimatedBarButtonItemOptions.defaults.rippleColor
            updateUI()
        }
        
        get {
            return self.options.rippleColor
        }
    }
    
    open var contentMode: UIViewContentMode? {
        set {
            self.options.contentMode = newValue ?? CDAnimatedBarButtonItemOptions.defaults.contentMode
            updateUI()
        }
        
        get {
            return self.options.contentMode
        }
    }
    
    open var frame: CGRect? {
        set {
            self.options.frame = newValue
            updateUI()
        }
        
        get {
            return self.options.frame
        }
    }
    
    @IBInspectable open var icon: UIImage? {
        set {
            self.options.icon = newValue
            updateUI()
        }
        
        get {
            return self.options.icon
        }
    }
    
    @IBInspectable open var text: String? {
        set {
            self.options.title = newValue
            updateUI()
        }
        
        get {
            return self.options.title
        }
    }
    
    open override var title: String? {
        get {
            return self.options.title
        }
        
        set {
            self.options.title = newValue
            updateUI()
        }
    }
    
    fileprivate weak var label: UILabel?
    fileprivate weak var imageView: UIImageView?
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    public override init() {
        super.init()
        commonInit()
    }
    public init(title: String?, callback: @escaping CDAnimatedBarButtonCallback) {
        super.init()
        onTapCallback = callback
        self.title = title
        commonInit()
    }
    
    public init(icon: UIImage?, callback: @escaping CDAnimatedBarButtonCallback) {
        super.init()
        onTapCallback = callback
        self.icon = icon
        commonInit()
        
    }
    
    public init(icon: UIImage?, contentMode: UIViewContentMode, callback: @escaping CDAnimatedBarButtonCallback) {
        super.init()
        self.onTapCallback = callback
        self.icon = icon
        commonInit()
        self.contentMode = contentMode
    }
    
    public init(options: CDAnimatedBarButtonItemOptions, callback: @escaping CDAnimatedBarButtonCallback) {
        super.init()
        self.options = options
        commonInit()
        self.onTapCallback = callback
    }
    
    open func commonInit() {
        updateUI()
    }
    
    fileprivate func updateUI() {
        
        let frame = self.frame ?? CGRect(x: 0, y: 0, width: 38, height: 38)
        var buttonCustomView: UIView
        if let text = self.text {
            let label = UILabel()
            label.backgroundColor = UIColor.clear
            label.textColor = self.textColor ?? self.tintColor
            label.font = self.font ?? UIFont.systemFont(ofSize: UIFont.buttonFontSize)
            label.text = text
            label.textAlignment = .center
            label.minimumScaleFactor = 0.2
            label.adjustsFontSizeToFitWidth = true
            buttonCustomView = label
            self.label = label
        } else {
            let imageView = UIImageView()
            imageView.backgroundColor = UIColor.clear
            imageView.image = icon
            imageView.contentMode = self.contentMode ?? .scaleAspectFit
            imageView.tintColor = tintColor
            buttonCustomView = imageView
            self.imageView = imageView
        }
        
        let button = NotifyingButton(type: UIButtonType.custom)
        button.onDidMoveToSuperView = { [weak self] (notifyingButton, superview) in
            guard let welf = self else {
                return
            }
            
            welf.onDidMoveToSuperViewCallback?(welf)
        }
        
        button.frame = frame
        buttonCustomView.frame = button.bounds
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 0
        button.autoresizingMask = UIViewAutoresizing.flexibleHeight.union(.flexibleWidth)
        button.addSubview(buttonCustomView)
        button.addTarget(self, action: #selector(tapAction(_:)), for: .touchUpInside)
        button.setNeedsUpdateConstraints()
        button.setNeedsLayout()
        button.setNeedsDisplay()
        button.updateConstraintsIfNeeded()
        button.layoutIfNeeded()
        self.customView = button
    }
    
    open func addTargetForAction(_ target: AnyObject, action: Selector) {
        self.target = target
        self.action = action
    }
    
    open func tapAction(_ sender: AnyObject?) {
        
        guard let button = self.customView as? UIButton else {
            onTapCallback?(self)
            return
        }
        
        guard let subview = button.subviews.first else {
            onTapCallback?(self)
            return
        }
        
        if self.options.callbackTiming == .immediately {
            onTapCallback?(self)
        }
        
        let halfDuration = Double(self.options.animationDuration/2)
        UIView.animate(withDuration: halfDuration, animations: {
            subview.transform = CGAffineTransform(scaleX: self.options.animationScaleFactor, y: self.options.animationScaleFactor)
            button.backgroundColor = self.options.rippleColor
        }, completion: { complete in
            
            if self.options.callbackTiming == .firstHalf {
                self.onTapCallback?(self)
            }
            
            UIView.animate(withDuration: halfDuration, animations: {
                button.backgroundColor = UIColor.clear
                subview.transform = CGAffineTransform.identity
            }, completion: { complete in
                if self.options.callbackTiming == .secondHalf {
                    self.onTapCallback?(self)
                }
            }) 
        }) 
    }
    
    open func updateImage(newImage image: UIImage?) {
        guard let customView = (self.customView as? UIButton)?.subviews.first as? UIImageView else {
            return
        }
        UIView.transition(with: customView, duration: 0.4, options: UIViewAnimationOptions.transitionCrossDissolve, animations: {
            customView.image = image
        }, completion: nil)
        
    }
}

