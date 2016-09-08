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
    public func indexOf(item: AnyObject?) -> Int? {
        if let itemTmp: AnyObject = item {
            for i in 0..<count {
                if let itemTmp3: AnyObject = self[i] as? AnyObject {
                    if itemTmp3 === itemTmp {
                        return i
                    }
                }
            }
        }
        
        return nil
    }
    
}