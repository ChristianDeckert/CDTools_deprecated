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
    
    public func replace(_ oldString: String, withNew replacmentString: String) -> String {
        return self.replacingOccurrences(of: oldString, with: replacmentString, options: NSString.CompareOptions.literal, range: nil)
    }
    
    public func replaceCaseInsensitive(_ oldString: String, withNew replacmentString: String) -> String {
        return self.replacingOccurrences(of: oldString, with: replacmentString, options: .caseInsensitive, range: nil)
    }
    
    public func stringByAppendingPathComponent(_ component: String) -> String {
        return self.nsString.appendingPathComponent(component)
    }
    
    public var lastPathComponent: String {
        get {
            return self.nsString.lastPathComponent
        }
    }
    
    public var stringByDeletingLastPathComponent: String {
        get {
            return self.nsString.deletingLastPathComponent
        }
    }
    public var stringByDeletingPathExtension: String {
        get {
            return self.nsString.deletingPathExtension
        }
    }
    
    public func stringByAppendingPathExtension(_ pathExtension: String) -> String? {
        return self.nsString.appendingPathExtension(pathExtension)
        
    }
    
    public static func sizeOfAttributedString(_ str: NSAttributedString, maxWidth: CGFloat) -> CGSize {
        let size = str.boundingRect(with: CGSize(width: maxWidth, height: 1000), options:(NSStringDrawingOptions.usesLineFragmentOrigin), context:nil).size
        return size
    }

}
