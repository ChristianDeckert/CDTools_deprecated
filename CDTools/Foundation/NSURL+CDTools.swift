//
//  NSURL+CDTools.swift
//  CDTools
//
//  Created by Christian Deckert on 30.06.16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation

public extension NSURL {
    public var queryParametersDictionary: [String:String]? {
        if let query = self.query {
            var dict = [String:String]()
            for parameter in query.componentsSeparatedByString("&") {
                let components = parameter.componentsSeparatedByString("=")
                if components.count == 2 {
                    if let key = components[0].stringByRemovingPercentEncoding,
                        let value = components[1].stringByRemovingPercentEncoding {
                        dict[key] = value
                    }
                }
            }
            return dict
        }
        else {
            return nil
        }
    }
}