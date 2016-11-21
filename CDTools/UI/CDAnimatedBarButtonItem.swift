//
//  AnimatedBarButtonItem.swift
//  Wishlist
//
//  Created by Christian Deckert on 15.11.16.
//  Copyright © 2016 x-root Software GmbH. All rights reserved.
//

import Foundation
import UIKit

public struct CDAnimatedBarButtonItemOptions {
    var rippleColor: UIColor = UIColor.blackColor().colorWithAlphaComponent(0.10)
    var contentMode: UIViewContentMode = .ScaleAspectFit
    var font: UIFont?
    var animationDuration: CGFloat = 0.4
    var animationScaleFactor: CGFloat = 0.65
    var textColor: UIColor?
    var frame: CGRect?
    var title: String?
    var icon: UIImage?
    var callback: ((animatedBarButtonItem: CDAnimatedBarButtonItem?) -> Void)? = nil
    
    static var defaults: CDAnimatedBarButtonItemOptions {
        return CDAnimatedBarButtonItemOptions()
    }
}

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
    
    public var onTapCallback: ((animatedBarButtonItem: CDAnimatedBarButtonItem?) -> Void)?
    public var onDidMoveToSuperViewCallback: ((animatedBarButtonItem: CDAnimatedBarButtonItem) -> Void)?
    
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
    public init(title: String?, callback: ((animatedBarButtonItem: CDAnimatedBarButtonItem?) -> Void)) {
        super.init()
        onTapCallback = callback
        self.title = title
        commonInit()
    }
    
    public init(icon: UIImage?, callback: (animatedBarButtonItem: CDAnimatedBarButtonItem?) -> Void) {
        super.init()
        onTapCallback = callback
        self.icon = icon
        commonInit()
        
    }
    
    public init(icon: UIImage?, contentMode: UIViewContentMode, callback: (animatedBarButtonItem: CDAnimatedBarButtonItem?) -> Void) {
        super.init()
        onTapCallback = callback
        self.icon = icon
        commonInit()
        self.contentMode = contentMode
    }
    
    public init(options: CDAnimatedBarButtonItemOptions) {
        super.init()
        commonInit()
        self.options = options
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
            //            guard let superview = superview else {
            //                return
            //            }
            
            guard let welf = self else {
                return
            }
            
            //            let isRightButton = notifyingButton.frame.origin.x > superview.frame.width / 2
            //            welf.label?.textAlignment = isRightButton ? .Right : .Left
            
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
        
        let halfDuration = Double(self.options.animationDuration/2)
        UIView.animateWithDuration(halfDuration, animations: {
            subview.transform = CGAffineTransformMakeScale(self.options.animationScaleFactor, self.options.animationScaleFactor)
            button.backgroundColor = self.options.rippleColor
        }) { complete in
            
            self.onTapCallback?(animatedBarButtonItem: self)
            
            UIView.animateWithDuration(halfDuration, animations: {
                button.backgroundColor = UIColor.clearColor()
                subview.transform = CGAffineTransformIdentity
            }) { complete in
            }
        }
    }
}
