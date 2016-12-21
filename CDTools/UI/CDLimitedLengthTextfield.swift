//
//  CDLimitedLengthTextfield.swift
//  Wishlist
//
//  Created by Christian Deckert on 21.12.16.
//  Copyright © 2016 Christian Deckert.
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
    
    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return externalDelegate?.textFieldShouldReturn?(textField) ?? true
    }
    
    
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        externalDelegate?.textFieldDidBeginEditing?(textField)
    }
    
    public func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return externalDelegate?.textFieldShouldEndEditing?(textField) ?? true
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        externalDelegate?.textFieldDidEndEditing?(textField)
    }

    public func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
            externalDelegate?.textFieldDidEndEditing?(textField, reason: reason)
    }
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
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
    
    public func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return externalDelegate?.textFieldShouldClear?(textField) ?? true
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool  {
        return externalDelegate?.textFieldShouldReturn?(textField) ?? true
    }
    
}
