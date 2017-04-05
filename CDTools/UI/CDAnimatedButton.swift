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
    case immediately
    case afterFirstHalf
    case afterSecondHalf
}


public typealias CDAnimatedButtonCallback = (_ animatedButton: CDAnimatedButton?) -> Void


open class CDAnimatedButton: UIButton {
    
    open var onTapCallback: CDAnimatedButtonCallback?
    open var preferredShrinkedSize: CGSize = CGSize(width: 0.95, height: 0.95)
    open var customAnimationsFirstHalf: ((Void) -> Void)?
    open var customAnimationsSecondHalf: ((Void) -> Void)?
    open var callbackFireOptions: CDAnimatedButtonCallbackFireOptions = .afterFirstHalf
    
    fileprivate var customView: UIView?
    
    open var icon: UIImage? {
        didSet {
            updateCustomView()
        }
    }
    
    open var text: String? {
        didSet {
            updateCustomView()
        }
    }
    
    open var textColor: UIColor? {
        didSet {
            updateCustomView()
        }
    }
    
    open var rippleColor: UIColor? = UIColor.black.withAlphaComponent(1.0)
    
    fileprivate func updateCustomView() {
        self.customView?.removeFromSuperview()
        if let text = self.text {
            let label = UILabel()
            label.backgroundColor = UIColor.clear
            label.textColor = self.textColor ?? self.tintColor
            label.text = text
            label.textAlignment = .center
            label.minimumScaleFactor = 0.2
            label.adjustsFontSizeToFitWidth = true
            customView = label
        } else {
            let imageView = UIImageView()
            imageView.backgroundColor = UIColor.clear
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
    
    
    open override func didMoveToSuperview() {
        super.didMoveToSuperview()
        guard nil != self.superview else {
            return
        }
        
        self.addTarget(self, action: #selector(onTap(_:)), for: .touchUpInside)
        
    }
    
    open func onTap(_ sender: AnyObject?) {
        
        self.isUserInteractionEnabled = false
        
        if self.callbackFireOptions == .immediately {
            self.onTapCallback?(self)
        }
        
        let backgroundColor = self.backgroundColor
        let duration: Double = 0.3
        UIView.animate(withDuration: duration/2, animations: {
            self.transform = CGAffineTransform(scaleX: self.preferredShrinkedSize.width, y: self.preferredShrinkedSize.height)
            self.customAnimationsFirstHalf?()
            self.backgroundColor = self.rippleColor
            
        }, completion: { complete in
            
            if self.callbackFireOptions == .afterFirstHalf {
                self.onTapCallback?(self)
            }
            
            UIView.animate(withDuration: duration/2, animations: {
                self.transform = CGAffineTransform.identity
                self.customAnimationsSecondHalf?()
                self.backgroundColor = backgroundColor
                
            }, completion: { complete in
                self.isUserInteractionEnabled = true
                if self.callbackFireOptions == .afterSecondHalf {
                    self.onTapCallback?(self)
                }
            }) 
        }) 
    }
    
    open func updateImage(newImage image: UIImage?) {
        guard let customView = self.subviews.first as? UIImageView else {
            return
        }
        UIView.transition(with: customView, duration: 0.4, options: UIViewAnimationOptions.transitionCrossDissolve, animations: {
            customView.image = image
        }, completion: nil)
        
    }
}


