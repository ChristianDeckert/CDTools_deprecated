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
    
    var onTapCallback: ((animatedBarButtonItem: CDAnimatedBarButtonItem?) -> Void)?
    var icon: UIImage? {
        didSet {
            self.image = nil
            self.title = nil
            
            let frame = CGRectMake(0, 0, 32, 32)
            let imageView = UIImageView(frame: frame)
            imageView.backgroundColor = UIColor.clearColor()
            imageView.image = icon
            imageView.contentMode = .ScaleAspectFit
            imageView.tintColor = tintColor
            
            let button = UIButton(type: UIButtonType.Custom)
            button.frame = frame
            button.layer.cornerRadius = 5
            button.layer.borderWidth = 0
            button.addSubview(imageView)
            button.addTarget(self, action: #selector(tapAction(_:)), forControlEvents: .TouchUpInside)
            button.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.fullscreenLayoutForView(viewToLayout: imageView, inView: button)
            button.setNeedsUpdateConstraints()
            button.setNeedsLayout()
            button.setNeedsDisplay()
            button.updateConstraintsIfNeeded()
            button.layoutIfNeeded()
            self.customView = button
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override init() {
        super.init()
        commonInit()
    }
    
    func commonInit() {
    }
    
    func addTargetForAction(target: AnyObject, action: Selector) {
        self.target = target
        self.action = action
    }
    
    func tapAction(sender: AnyObject?) {
        
        guard let button = self.customView as? UIButton else {
            onTapCallback?(animatedBarButtonItem: self)
            return
        }
        
        guard let imageView = button.subviews.first as? UIImageView else {
            onTapCallback?(animatedBarButtonItem: self)
            return
        }
        
        let duration: Double = 0.4
        UIView.animateWithDuration(duration/2, animations: {
            imageView.transform = CGAffineTransformMakeScale(0.6, 0.6)
            button.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.15)
        }) { complete in
            
            self.onTapCallback?(animatedBarButtonItem: self)
            
            UIView.animateWithDuration(duration/2, animations: {
                button.backgroundColor = UIColor.clearColor()
                imageView.transform = CGAffineTransformIdentity
            }) { complete in
            }
        }
    }
}

