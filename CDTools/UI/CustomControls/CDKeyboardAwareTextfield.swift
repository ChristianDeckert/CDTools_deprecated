//
//  CDKeyboardAwareTextfield.swift
//  CDTools
//
//  Created by Christian Deckert on 30.08.16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit
import Foundation

open class CDKeyboardAwareTextfield: UITextField {

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    open override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        
        if nil == newSuperview {
            
        } else {
            NotificationCenter.default.addObserver(self, selector: #selector(CDKeyboardAwareTextfield.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(CDKeyboardAwareTextfield.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        }
    }
    

    open func keyboardWillShow(_ notification: Notification) {
        
        guard self.isFirstResponder else {
            return
        }
        
        guard let rootViewController: UIViewController = UIApplication.shared.keyWindow?.rootViewController else {
            return
        }
        
        guard let keyboardRect = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        
        let v = self.superview ?? self
        
        let rect = rootViewController.view.convert(v.frame, from: self)
        let maxY = rect.origin.y + self.bounds.height
        
        let diff =  keyboardRect.origin.y - maxY
        
        UIView.animate(withDuration: 0.3, animations: { 
            if diff < 0 {
                rootViewController.view.transform = CGAffineTransform(translationX: 0.0, y: diff - 10.0)
            } else {
                rootViewController.view.transform = CGAffineTransform.identity
            }
        }) 
        
        
    }
    
    open func keyboardWillHide(_ notification: Notification) {
        guard let rootViewController: UIViewController = UIApplication.shared.keyWindow?.rootViewController else {
            return
        }
        UIView.animate(withDuration: 0.3, animations: {
            rootViewController.view.transform = CGAffineTransform.identity
        }) 
    }


}
