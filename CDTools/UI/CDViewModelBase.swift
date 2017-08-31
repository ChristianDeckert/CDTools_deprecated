//
//  CDViewModelBase.swift
//  CDTools
//
//  Created by Deckert on 01.05.17.
//  Copyright © 2017 Christian Deckert. All rights reserved.
//

import UIKit

public class CDViewModelBase: NSObject {

    public required override init() {
        super.init()
    }
    
    public func duplicate() -> Self {
        let copy = type(of: self).init()
        
        for child in Mirror(reflecting: self).children
        {
            guard let name = child.label else {
                continue;
            }
            
            if let value = child.value as? NSObject {
                copy.setValue(((value is NSNull) ? nil : value), forKey: name)
            } else if let value = child.value as? AnyObject {
                copy.setValue((value is NSNull) ? nil : value, forKey: name)
            }
        }
        
        return copy
    }

    
}
