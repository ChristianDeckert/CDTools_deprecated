//
//  UIView+CDTools.swift
//  CDTools
//
//  Created by Christian Deckert on 30.06.16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation
import UIKit

public extension UIView {
    
    func addDropshadow(shadowColor: UIColor = UIColor.black, opacity: Float = 0.75, radius: CGFloat = 4.0, offset: CGSize = .zero) {
        layer.shadowColor = shadowColor.cgColor
        layer.shadowRadius = radius
        layer.shadowOpacity = opacity
        layer.shadowOffset = offset
    }
    
    func fadeIn(completion: (() -> (Void))? = nil) {
        let options = UIViewAnimationOptions()
        
        UIView.animate(withDuration: 0.4, delay: 0.0, options: options, animations: { () -> Void in
            self.alpha = 1.0
        }) { (Bool) -> Void in
            if nil != completion {
                completion!()
            }
        }
    }
    
    public func fadeOut(completion: (() -> (Void))? = nil) {
        self.fade(duration: 0.4, alpha: 0.0, delay: 0.0, completion: completion)
    }
    
    public func fade(duration: Double, alpha: Double, delay: Double, completion: ((Void) -> (Void))?) {
        let options = UIViewAnimationOptions.curveLinear
        
        UIView.animate(withDuration: duration, delay: delay, options: options, animations: { () -> Void in
            self.alpha = CGFloat(alpha)
        }) { (Bool) -> Void in
            if nil != completion {
                completion!()
            }
        }
    }
    
    public func rotate(degress: Double, completion: (() -> (Void))?) {
        
        let radians =  (degress * Double.pi/180.0)
        let rotation = CGAffineTransform(rotationAngle: CGFloat(radians));
        
        UIView.animate(withDuration: 0.5, delay: 0.0, options: UIViewAnimationOptions(), animations: { () -> Void in
            self.transform = rotation
        }) { (Bool) -> Void in
            if nil != completion {
                completion!()
            }
        }
    }
    
    public func shakeAnimation(withDuration duration: Double = 0.4) {
        UIView.animateKeyframes(withDuration: duration, delay: 0, options:.allowUserInteraction, animations: { _ in
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1/3) {
                self.transform = CGAffineTransform(translationX: -10, y: 0)
            }
            UIView.addKeyframe(withRelativeStartTime: 0.3, relativeDuration: 1/3) {
                self.transform = CGAffineTransform(translationX: 10, y: 0)
            }
            UIView.addKeyframe(withRelativeStartTime: 0.6, relativeDuration: 1/3) {
                self.transform = CGAffineTransform.identity
            }
        } , completion: { complete in
        })
    }
    
    
    public func roundCorners(corners: UIRectCorner = .allCorners, radius: CGFloat = 4.0) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
        self.setNeedsLayout()
        self.layoutIfNeeded()
    }

}
