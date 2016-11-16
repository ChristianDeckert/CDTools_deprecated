//
//  AnimatedButton.swift
//  Wishlist
//
//  Created by Christian Deckert on 15.11.16.
//  Copyright © 2016 Christian Deckert.
//

import Foundation
import UIKit

enum AnimatedButtonCallbackFireOptions: Int {
    case AfterFirstHalf
    case AfterSecondHalf
}

class AnimatedButton: UIButton {
    
    var onTapCallback: ((animatedButton: AnimatedButton?) -> Void)?
    var preferredShrinkedSize: CGSize = CGSize(width: 0.95, height: 0.95)
    var customAnimationsFirstHalf: (Void -> Void)?
    var customAnimationsSecondHalf: (Void -> Void)?
    var callbackFireOptions: AnimatedButtonCallbackFireOptions = .AfterFirstHalf
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        guard nil != self.superview else {
            return
        }
        
        self.addTarget(self, action: #selector(onTap(_:)), forControlEvents: .TouchUpInside)
    }
    
    func onTap(sender: AnyObject?) {
        
        self.userInteractionEnabled = false
        
        let duration: Double = 0.3
        
        UIView.animateWithDuration(duration/2, animations: {
            self.transform = CGAffineTransformMakeScale(self.preferredShrinkedSize.width, self.preferredShrinkedSize.height)
            self.customAnimationsFirstHalf?()
            
        }) { complete in
            
            if self.callbackFireOptions == .AfterFirstHalf {
                self.onTapCallback?(animatedButton: self)
            }
            
            UIView.animateWithDuration(duration/2, animations: {
                self.transform = CGAffineTransformIdentity
                self.customAnimationsSecondHalf?()
                
            }) { complete in
                self.userInteractionEnabled = true
                if self.callbackFireOptions == .AfterSecondHalf {
                    self.onTapCallback?(animatedButton: self)
                }
            }
        }
    }
    
}




