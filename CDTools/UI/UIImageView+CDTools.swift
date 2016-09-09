//
//  UIView+CDTools.swift
//   
//
//  Created by Christian Deckert on 27.10.14.
//  Copyright (c) 2016 Christian Deckert. All rights reserved.
//

import Foundation
import UIKit

public extension UIImageView {
    
    public func setImage(image: UIImage?, duration: Double, delay: Double, completion: ((Void)->(Void))?) {

        UIView.animateWithDuration(duration * 0.5, delay: delay, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
            self.alpha = 0.0
            }) { (Bool) -> Void in
                self.image = image
                UIView.animateWithDuration(duration * 0.5, delay: 0.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
                    self.alpha = 1.0
                    }) { (Bool) -> Void in
                        if nil != completion {
                            completion!()
                        }
                }
        }
    }
}
