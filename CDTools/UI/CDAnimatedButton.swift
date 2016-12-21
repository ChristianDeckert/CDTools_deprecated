//
//  AnimatedButton.swift
//  CDTools
//
//  Created by Christian Deckert on 15.11.16.
//  Copyright © 2016 Christian Deckert.
//

import Foundation
import UIKit

public enum CDAnimatedButtonCallbackFireOptions: Int {
    case Immediately
    case AfterFirstHalf
    case AfterSecondHalf
}


public typealias CDAnimatedButtonCallback = (animatedButton: CDAnimatedButton?) -> Void


public class CDAnimatedButton: UIButton {
    
    public var onTapCallback: CDAnimatedButtonCallback?
    public var preferredShrinkedSize: CGSize = CGSize(width: 0.95, height: 0.95)
    public var customAnimationsFirstHalf: (Void -> Void)?
    public var customAnimationsSecondHalf: (Void -> Void)?
    public var callbackFireOptions: CDAnimatedButtonCallbackFireOptions = .AfterFirstHalf
    
    private var customView: UIView?
    
    public var icon: UIImage? {
        didSet {
            updateCustomView()
        }
    }
    
    public var text: String? {
        didSet {
            updateCustomView()
        }
    }
    
    public var textColor: UIColor? {
        didSet {
            updateCustomView()
        }
    }
    
    public var rippleColor: UIColor? = UIColor.blackColor().colorWithAlphaComponent(1.0)
    
    private func updateCustomView() {
        self.customView?.removeFromSuperview()
        if let text = self.text {
            let label = UILabel()
            label.backgroundColor = UIColor.clearColor()
            label.textColor = self.textColor ?? self.tintColor
            label.text = text
            label.textAlignment = .Center
            label.minimumScaleFactor = 0.2
            label.adjustsFontSizeToFitWidth = true
            customView = label
        } else {
            let imageView = UIImageView()
            imageView.backgroundColor = UIColor.clearColor()
            let image = self.icon
            imageView.image = image
            imageView.contentMode = self.contentMode
            imageView.tintColor = tintColor
            customView = imageView
        }
        
        guard let customView = self.customView else {
            return
        }
        customView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(customView)
        NSLayoutConstraint.fullscreenLayoutForView(viewToLayout: customView, inView: self)
    }
    
    
    public override func didMoveToSuperview() {
        super.didMoveToSuperview()
        guard nil != self.superview else {
            return
        }
        
        self.addTarget(self, action: #selector(onTap(_:)), forControlEvents: .TouchUpInside)
        
    }
    
    public func onTap(sender: AnyObject?) {
        
        self.userInteractionEnabled = false
        
        if self.callbackFireOptions == .Immediately {
            self.onTapCallback?(animatedButton: self)
        }
        
        let backgroundColor = self.backgroundColor
        let duration: Double = 0.3
        UIView.animateWithDuration(duration/2, animations: {
            self.transform = CGAffineTransformMakeScale(self.preferredShrinkedSize.width, self.preferredShrinkedSize.height)
            self.customAnimationsFirstHalf?()
            self.backgroundColor = self.rippleColor
            
        }) { complete in
            
            if self.callbackFireOptions == .AfterFirstHalf {
                self.onTapCallback?(animatedButton: self)
            }
            
            UIView.animateWithDuration(duration/2, animations: {
                self.transform = CGAffineTransformIdentity
                self.customAnimationsSecondHalf?()
                self.backgroundColor = backgroundColor
                
            }) { complete in
                self.userInteractionEnabled = true
                if self.callbackFireOptions == .AfterSecondHalf {
                    self.onTapCallback?(animatedButton: self)
                }
            }
        }
    }
    
    public func updateImage(newImage image: UIImage?) {
        guard let customView = self.subviews.first as? UIImageView else {
            return
        }
        UIView.transitionWithView(customView, duration: 0.4, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: {
            customView.image = image
        }, completion: nil)
        
    }
}


