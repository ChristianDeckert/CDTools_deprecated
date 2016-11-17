//
//  AnimatedBarButtonItem.swift
//  Wishlist
//
//  Created by Christian Deckert on 15.11.16.
//  Copyright © 2016 Christian Deckert
//

import Foundation
import UIKit

class CDAnimatedBarButtonItem: UIBarButtonItem {
    
    public var onTapCallback: ((animatedBarButtonItem: CDAnimatedBarButtonItem?) -> Void)?
    public var rippleColor: UIColor = UIColor.blackColor()
    public var font: UIFont?
    public var contentMode: UIViewContentMode?
    
    @IBInspectable public var frame: CGRect? {
        didSet {
            updateUI()
        }
    }
    
    @IBInspectable public var icon: UIImage? {
        didSet {
            updateUI()
        }
    }
    
    @IBInspectable public var text: String? {
        didSet {
            updateUI()
        }
    }
    
    public override var title: String? {
        get {
            return self.text
        }
        
        set {
            self.text = newValue
            updateUI()
        }
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
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
    
    public func commonInit() {
        updateUI()
    }
    
    private func updateUI() {
        
        let frame = self.frame ?? CGRectMake(0, 0, 38, 38)
        var buttonCustomView: UIView
        if let text = self.text {
            let label = UILabel(frame: frame)
            label.backgroundColor = UIColor.clearColor()
            label.textColor = self.tintColor
            label.font = self.font ?? UIFont.systemFontOfSize(UIFont.buttonFontSize())
            label.text = text
            label.textAlignment = .Center
            label.minimumScaleFactor = 0.2
            label.adjustsFontSizeToFitWidth = true
            buttonCustomView = label
        } else {
            let imageView = UIImageView(frame: frame)
            imageView.backgroundColor = UIColor.clearColor()
            imageView.image = icon
            imageView.contentMode = self.contentMode ?? .ScaleAspectFit
            imageView.tintColor = tintColor
            buttonCustomView = imageView
        }
        
        let button = UIButton(type: UIButtonType.Custom)
        button.frame = frame
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 0
        button.addSubview(buttonCustomView)
        button.addTarget(self, action: #selector(tapAction(_:)), forControlEvents: .TouchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.fullscreenLayoutForView(viewToLayout: buttonCustomView, inView: button)
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
        
        let duration: Double = 0.4
        UIView.animateWithDuration(duration/2, animations: {
            subview.transform = CGAffineTransformMakeScale(0.6, 0.6)
            button.backgroundColor = self.rippleColor.colorWithAlphaComponent(0.15)
        }) { complete in
            
            self.onTapCallback?(animatedBarButtonItem: self)
            
            UIView.animateWithDuration(duration/2, animations: {
                button.backgroundColor = UIColor.clearColor()
                subview.transform = CGAffineTransformIdentity
            }) { complete in
            }
        }
    }
}

