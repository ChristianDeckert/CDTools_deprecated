//
//  CDLimitedLengthTextfield.swift
//  CDTools
//
//  Created by Christian Deckert on 21.12.16.
//  Copyright © 2016 Christian Deckert
//

import Foundation
import UIKit

public class CDLimitedLengthTextfield: UITextField, UITextFieldDelegate {
    
    var externalDelegate: UITextFieldDelegate?

    @IBInspectable var maxLength: Int = 144
    
    public override var delegate: UITextFieldDelegate? {
        get {
            return externalDelegate
        }
        
        set {
            super.delegate = self
            externalDelegate = newValue
        }
    }
    
    public override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        guard nil != superview else { return }
        
        self.delegate = self
    }
    
    public func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        return externalDelegate?.textFieldShouldReturn?(textField) ?? true
    }
    
    
    public func textFieldDidBeginEditing(textField: UITextField) {
        externalDelegate?.textFieldDidBeginEditing?(textField)
    }
    
    public func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        return externalDelegate?.textFieldShouldEndEditing?(textField) ?? true
    }

    public func textFieldDidEndEditing(textField: UITextField) {
        externalDelegate?.textFieldDidEndEditing?(textField)
    }

    @available(iOS 10.0, *)
    public func textFieldDidEndEditing(textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        if #available(iOS 10.0, *) {
            externalDelegate?.textFieldDidEndEditing?(textField, reason: reason)
        } else {
            
        }
    }
    
    public func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        if self.maxLength <= 0 {
            return externalDelegate?.textField?(textField, shouldChangeCharactersInRange: range, replacementString: string) ?? true
        }
        
        let currentCharacterCount = textField.text?.characters.count ?? 0
        if (range.length + range.location > currentCharacterCount){
            return false
        }
        let newLength = currentCharacterCount + string.characters.count - range.length
        return newLength <= maxLength
    }

    public func textFieldShouldClear(textField: UITextField) -> Bool {
        return externalDelegate?.textFieldShouldClear?(textField) ?? true
    }

    public func textFieldShouldReturn(textField: UITextField) -> Bool  {
        return externalDelegate?.textFieldShouldReturn?(textField) ?? true
    }

}
