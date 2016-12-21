//
//  CDRegEx.swift
//  CDTools
//
//  Created by Christian Deckert on 30.06.16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation

public enum CDRegExPatterns: String {
    case URLPattern = "(https?:\\/\\/(?:www\\.|(?!www))[^\\s\\.]+\\.[^\\s]{2,}|www\\.[^\\s]+\\.[^\\s]{2,})"
    case EmailPattern = "(^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\\.[a-zA-Z0-9-.]+$)"
}

open class CDRegEx: NSObject {
    
    let internalExpression: NSRegularExpression?
    let pattern: String
    
    public init(pattern: String) {
        self.pattern = pattern
        self.internalExpression = try? NSRegularExpression(pattern: pattern, options: NSRegularExpression.Options.caseInsensitive)
        super.init()
    }
    
    public init(pattern: CDRegExPatterns) {
        self.pattern = pattern.rawValue
        self.internalExpression = try? NSRegularExpression(pattern: self.pattern, options: NSRegularExpression.Options.caseInsensitive)
        super.init()
    }
    
    open func test(_ input: String) -> Bool {
        
        if let exp = self.internalExpression {
            let matches = exp.matches(in: input, options: NSRegularExpression.MatchingOptions(), range:NSMakeRange(0, input.nsString.length))
            return matches.count > 0
        }
        
        return false
    }
    
    open func replaceOccurances(inString string: String) -> String {
        var newString: String = string
        if let url = string.range(of: self.pattern, options: [.regularExpression, .caseInsensitive]) {
            newString.removeSubrange(url)
        }
        return newString
    }
}


infix operator =~

public func =~ (input: String, pattern: String) -> Bool {
    return CDRegEx(pattern: pattern).test(input)
}

public func =~ (input: String, pattern: CDRegExPatterns) -> Bool {
    return CDRegEx(pattern: pattern.rawValue).test(input)
}
