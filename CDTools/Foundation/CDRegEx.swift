//
//  XRRegEx.swift
//  CDTools
//
//  Created by Christian Deckert on 30.06.16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation

public enum XRRegExPatterns: String {
    case URLPattern = "(https?:\\/\\/(?:www\\.|(?!www))[^\\s\\.]+\\.[^\\s]{2,}|www\\.[^\\s]+\\.[^\\s]{2,})"
    case EmailPattern = "(^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\\.[a-zA-Z0-9-.]+$)"
}

public class XRRegEx: NSObject {
    
    let internalExpression: NSRegularExpression?
    let pattern: String
    
    public init(pattern: String) {
        self.pattern = pattern
        self.internalExpression = try? NSRegularExpression(pattern: pattern, options: NSRegularExpressionOptions.CaseInsensitive)
        super.init()
    }
    
    public init(pattern: XRRegExPatterns) {
        self.pattern = pattern.rawValue
        self.internalExpression = try? NSRegularExpression(pattern: self.pattern, options: NSRegularExpressionOptions.CaseInsensitive)
        super.init()
    }
    
    public func test(input: String) -> Bool {
        
        if let exp = self.internalExpression {
            let matches = exp.matchesInString(input, options: NSMatchingOptions(), range:NSMakeRange(0, input.nsString.length))
            return matches.count > 0
        }
        
        return false
    }
    
    public func replaceOccurances(inString string: String) -> String {
        var newString: String = string
        if let url = string.rangeOfString(self.pattern, options: [.RegularExpressionSearch, .CaseInsensitiveSearch]) {
            newString.removeRange(url)
        }
        
        "" =~ .URLPattern
        return newString
    }
}


infix operator =~ {}

public func =~ (input: String, pattern: String) -> Bool {
    return XRRegEx(pattern: pattern).test(input)
}

public func =~ (input: String, pattern: XRRegExPatterns) -> Bool {
    return XRRegEx(pattern: pattern.rawValue).test(input)
}