//
//  CDKeyboardAwareTextfield.swift
//  CDTools
//
//  Created by Christian Deckert on 30.08.16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit
import Foundation

public class CDKeyboardAwareTextfield: UITextField {

    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    public override func willMoveToSuperview(newSuperview: UIView?) {
        super.willMoveToSuperview(newSuperview)
        
        if nil == newSuperview {
            
        } else {
            NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(CDKeyboardAwareTextfield.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
            NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(CDKeyboardAwareTextfield.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
        }
    }
    

    public func keyboardWillShow(notification: NSNotification) {
        
        guard self.isFirstResponder() else {
            return
        }
        
        guard let rootViewController: UIViewController = UIApplication.sharedApplication().keyWindow?.rootViewController else {
            return
        }
        
        guard let keyboardRect = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.CGRectValue() else {
            return
        }
        
        let v = self.superview ?? self
        
        let rect = rootViewController.view.convertRect(v.frame, fromView: self)
        let maxY = rect.origin.y + self.bounds.height
        
        let diff =  keyboardRect.origin.y - maxY
        
        UIView.animateWithDuration(0.3) { 
            if diff < 0 {
                rootViewController.view.transform = CGAffineTransformMakeTranslation(0.0, diff - 10.0)
            } else {
                rootViewController.view.transform = CGAffineTransformIdentity
            }
        }
        
        
    }
    
    public func keyboardWillHide(notification: NSNotification) {
        guard let rootViewController: UIViewController = UIApplication.sharedApplication().keyWindow?.rootViewController else {
            return
        }
        UIView.animateWithDuration(0.3) {
            rootViewController.view.transform = CGAffineTransformIdentity
        }
    }


}
