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

open class CDKeyboardAwareTextfield: UITextField {
    
    open var onLostFocus: ((_ keyboardAwareTextField: CDKeyboardAwareTextfield) -> Void)? = nil
    
    deinit {
        onLostFocus = nil
    }
    
    open override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        
        if nil == newSuperview {
            NotificationCenter.default.removeObserver(self)
        } else {
            NotificationCenter.default.addObserver(self, selector: #selector(CDKeyboardAwareTextfield.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(CDKeyboardAwareTextfield.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        }
    }
    
    
    /* todo: verify if special treatment is needed when textfield is embedded in a table view (cell)
     */
    open func keyboardWillShow(_ notification: Notification) {
        
        guard self.isFirstResponder else {
            return
        }
        
        guard let topViewController: UIViewController = UIViewController.topViewController else {
            return
        }
        
        guard let keyboardRect = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        
        let v = self.superview ?? self
        
        let rect = topViewController.view.convert(v.frame, from: self)
        let maxY = rect.origin.y + self.bounds.height
        
        let diff =  keyboardRect.origin.y - maxY
        
        UIView.animate(withDuration: 0.3, animations: {
            if diff < 0 {
                topViewController.view.transform = CGAffineTransform(translationX: 0.0, y: diff - 10.0)
            } else {
                topViewController.view.transform = CGAffineTransform.identity
            }
        }) 
        
        
    }
    
    open func keyboardWillHide(_ notification: Notification) {
        
        guard let topViewController: UIViewController = UIViewController.topViewController else {
            return
        }
        
        UIView.animate(withDuration: 0.3, animations: {
            topViewController.view.transform = CGAffineTransform.identity
        }) 
    }
    
    override open func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, with: event)
        let isFirstResponder = self.isFirstResponder
        if isFirstResponder && view == nil {
            endEditing(true)
            onLostFocus?(self)
            NotificationCenter.default.post(name: Notification.Name(rawValue: CDKeyboardAwareTextFieldLostFocusNotification), object: nil, userInfo: ["sender": self])
        }
        return view
        
    }
    
    
}
