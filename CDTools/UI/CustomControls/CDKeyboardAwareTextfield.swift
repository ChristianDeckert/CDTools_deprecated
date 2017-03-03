//
//  CDKeyboardAwareTextfield.swift
//  CDTools
//
//  Created by Christian Deckert on 30.08.16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit
import Foundation

public let CDKeyboardAwareTextFieldLostFocusNotification = "KeyboardAwareTextFieldLostFocusNotification"

public class CDKeyboardAwareTextfield: UITextField {
    
    public var onLostFocus: ((keyboardAwareTextField: CDKeyboardAwareTextfield) -> Void)? = nil
    
    deinit {
        onLostFocus = nil
    }
    
    public override func willMoveToSuperview(newSuperview: UIView?) {
        super.willMoveToSuperview(newSuperview)
        
        if nil == newSuperview {
            NSNotificationCenter.defaultCenter().removeObserver(self)
        } else {
            NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(CDKeyboardAwareTextfield.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
            NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(CDKeyboardAwareTextfield.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
        }
    }
    
    
    /* todo: verify if special treatment is needed when textfield is embedded in a table view (cell)
     */
    public func keyboardWillShow(notification: NSNotification) {
        
        guard self.isFirstResponder() else {
            return
        }
        
        guard let topViewController: UIViewController = UIViewController.topViewController else {
            return
        }
        
        guard let keyboardRect = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.CGRectValue() else {
            return
        }
        
        let v = self.superview ?? self
        
        let rect = topViewController.view.convertRect(v.frame, fromView: self)
        let maxY = rect.origin.y + self.bounds.height
        
        let diff =  keyboardRect.origin.y - maxY
        
        UIView.animateWithDuration(0.3) {
            if diff < 0 {
                topViewController.view.transform = CGAffineTransformMakeTranslation(0.0, diff - 10.0)
            } else {
                topViewController.view.transform = CGAffineTransformIdentity
            }
        }
        
        
    }
    
    public func keyboardWillHide(notification: NSNotification) {
        
        guard let topViewController: UIViewController = UIViewController.topViewController else {
            return
        }
        
        UIView.animateWithDuration(0.3) {
            topViewController.view.transform = CGAffineTransformIdentity
        }
    }
    
    override public func hitTest(point: CGPoint, withEvent event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, withEvent: event)
        let isFirstResponder = self.isFirstResponder()
        if isFirstResponder && view == nil {
            endEditing(true)
            onLostFocus?(keyboardAwareTextField: self)
            NSNotificationCenter.defaultCenter().postNotificationName(CDKeyboardAwareTextFieldLostFocusNotification, object: nil, userInfo: ["sender": self])
        }
        return view
        
    }
    
    
}
