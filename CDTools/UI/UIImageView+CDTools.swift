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
    
    public func setImage(_ image: UIImage?, duration: Double, delay: Double, completion: ((Void)->(Void))?) {

        UIView.animate(withDuration: duration * 0.5, delay: delay, options: UIViewAnimationOptions.curveEaseIn, animations: { () -> Void in
            self.alpha = 0.0
            }) { (Bool) -> Void in
                self.image = image
                UIView.animate(withDuration: duration * 0.5, delay: 0.0, options: UIViewAnimationOptions(), animations: { () -> Void in
                    self.alpha = 1.0
                    }) { (Bool) -> Void in
                        if nil != completion {
                            completion!()
                        }
                }
        }
    }
}
