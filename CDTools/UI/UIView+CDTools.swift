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
    func fadeIn(completion: ((Void) -> (Void))? = nil) {
        let options = UIViewAnimationOptions.CurveEaseInOut
        
        UIView.animateWithDuration(0.4, delay: 0.0, options: options, animations: { () -> Void in
            self.alpha = 1.0
        }) { (Bool) -> Void in
            if nil != completion {
                completion!()
            }
        }
    }
    
    public func fadeOut(completion: ((Void) -> (Void))? = nil) {
        self.fadeWithDuration(0.4, alpha: 0.0, delay: 0.0, completion: completion)
    }
    
    public func fadeWithDuration(duration: Double, alpha: Double, delay: Double, completion: ((Void) -> (Void))?) {
        let options = UIViewAnimationOptions.CurveLinear
        
        UIView.animateWithDuration(duration, delay: delay, options: options, animations: { () -> Void in
            self.alpha = CGFloat(alpha)
        }) { (Bool) -> Void in
            if nil != completion {
                completion!()
            }
        }
    }
    
    public func rotate(degress: Double, completion: ((Void) -> (Void))?) {
        
        let radians =  (degress * M_PI/180.0)
        let rotation = CGAffineTransformMakeRotation(CGFloat(radians));
        
        UIView.animateWithDuration(0.5, delay: 0.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            self.transform = rotation
        }) { (Bool) -> Void in
            if nil != completion {
                completion!()
            }
        }
    }
}
