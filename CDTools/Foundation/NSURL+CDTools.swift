//
//  NSURL+CDTools.swift
//  CDTools
//
//  Created by Christian Deckert on 30.06.16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation

public extension URL {
    public var queryParametersDictionary: [String:String]? {
        if let query = self.query {
            var dict = [String:String]()
            for parameter in query.components(separatedBy: "&") {
                let components = parameter.components(separatedBy: "=")
                if components.count == 2 {
                    if let key = (components[0] as NSString).removingPercentEncoding,
                        let value = (components[1] as NSString).removingPercentEncoding {
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
