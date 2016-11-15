//
//  AnimatedButton.swift
//  Wishlist
//
//  Created by Christian Deckert on 15.11.16.
//  Copyright © 2016 Christian Deckert.
//

import Foundation
import UIKit

class CDAnimatedButton: UIButton {
    
    var onTapCallback: ((animatedButton: CDAnimatedButton?) -> Void)?
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        guard nil != self.superview else {
            return
        }
        
        func onTap(sender: AnyObject?) {
            
            self.userInteractionEnabled = false
            
            let duration: Double = 0.3
            
            UIView.animateWithDuration(duration/2, animations: {
                self.transform = CGAffineTransformMakeScale(0.95, 0.95)
                
            }) { complete in
                
                self.onTapCallback?(animatedButton: self)
                
                UIView.animateWithDuration(duration/2, animations: {
                    self.transform = CGAffineTransformIdentity
                }) { complete in
                    self.userInteractionEnabled = true
                }
            }
        }
    }
    
    func onTap(sender: AnyObject?) {
        
        self.userInteractionEnabled = false
        
        let duration: Double = 0.3
        
        UIView.animateWithDuration(duration/2, animations: {
            self.transform = CGAffineTransformMakeScale(0.95, 0.95)
            
        }) { complete in
            
            self.onTapCallback?(animatedButton: self)
            
            UIView.animateWithDuration(duration/2, animations: {
                self.transform = CGAffineTransformIdentity
            }) { complete in
                self.userInteractionEnabled = true
            }
        }
    }
    
}


