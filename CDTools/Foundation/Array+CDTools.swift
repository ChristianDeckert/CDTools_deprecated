//
//  Array+CDTools.swift
//  CDTools
//
//  Created by Christian Deckert on 30.06.16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation

public extension Array {
    
    // Iterates over the whole array and finds the desired element by reference
    public func indexOf(item: Any) -> Int? {
        
        for i in 0..<count {
            let currentItem = self[i] as AnyObject
            if currentItem === item  as AnyObject{
                return i
            }
        }
        
        return nil
    }
    
}
