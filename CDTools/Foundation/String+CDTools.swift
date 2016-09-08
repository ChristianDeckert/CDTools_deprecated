//
//  String+CDTools.swift
//  CDTools
//
//  Created by Christian Deckert on 30.06.16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation
import UIKit

public extension String {
    
    public var nsString: NSString {
        get {
            return self as NSString
        }
    }
    
    public func replace(oldString: String, withNew replacmentString: String) -> String {
        return self.stringByReplacingOccurrencesOfString(oldString, withString: replacmentString, options: NSStringCompareOptions.LiteralSearch, range: nil)
    }
    
    public func replaceCaseInsensitive(oldString: String, withNew replacmentString: String) -> String {
        return self.stringByReplacingOccurrencesOfString(oldString, withString: replacmentString, options: .CaseInsensitiveSearch, range: nil)
    }
    
    public func stringByAppendingPathComponent(component: String) -> String {
        return self.nsString.stringByAppendingPathComponent(component)
    }
    
    public var lastPathComponent: String {
        get {
            return self.nsString.lastPathComponent
        }
    }
    
    public var stringByDeletingLastPathComponent: String {
        get {
            return self.nsString.stringByDeletingLastPathComponent
        }
    }
    public var stringByDeletingPathExtension: String {
        get {
            return self.nsString.stringByDeletingPathExtension
        }
    }
    
    public func stringByAppendingPathExtension(pathExtension: String) -> String? {
        return self.nsString.stringByAppendingPathExtension(pathExtension)
        
    }
    
    public static func sizeOfAttributedString(str: NSAttributedString, maxWidth: CGFloat) -> CGSize {
        let size = str.boundingRectWithSize(CGSizeMake(maxWidth, 1000), options:(NSStringDrawingOptions.UsesLineFragmentOrigin), context:nil).size
        return size
    }

}