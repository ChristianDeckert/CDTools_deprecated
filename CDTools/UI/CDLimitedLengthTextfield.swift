//
//  CDLimitedLengthTextfield.swift
//  CDTools
//
//  Created by Christian Deckert on 21.12.16.
//  Copyright © 2016 Christian Deckert
//

import Foundation
import UIKit

open class CDLimitedLengthTextfield: UITextField, UITextFieldDelegate {
    
    var externalDelegate: UITextFieldDelegate?

    @IBInspectable var maxLength: Int = 144
    
    open override var delegate: UITextFieldDelegate? {
        get {
            return externalDelegate
        }
        
        set {
            super.delegate = self
            externalDelegate = newValue
        }
    }
    
    open override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        guard nil != superview else { return }
        
        self.delegate = self
    }
    
    open func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return externalDelegate?.textFieldShouldReturn?(textField) ?? true
    }
    
    
    open func textFieldDidBeginEditing(_ textField: UITextField) {
        externalDelegate?.textFieldDidBeginEditing?(textField)
    }
    
    open func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return externalDelegate?.textFieldShouldEndEditing?(textField) ?? true
    }

    open func textFieldDidEndEditing(_ textField: UITextField) {
        externalDelegate?.textFieldDidEndEditing?(textField)
    }

    @available(iOS 10.0, *)
    open func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        externalDelegate?.textFieldDidEndEditing?(textField, reason: reason)
    }
    
    open func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if self.maxLength <= 0 {
            return externalDelegate?.textField?(textField, shouldChangeCharactersIn: range, replacementString: string) ?? true
        }
        
        let currentCharacterCount = textField.text?.characters.count ?? 0
        if (range.length + range.location > currentCharacterCount){
            return false
        }
        let newLength = currentCharacterCount + string.characters.count - range.length
        return newLength <= maxLength
    }

    open func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return externalDelegate?.textFieldShouldClear?(textField) ?? true
    }

    open func textFieldShouldReturn(_ textField: UITextField) -> Bool  {
        return externalDelegate?.textFieldShouldReturn?(textField) ?? true
    }

}
