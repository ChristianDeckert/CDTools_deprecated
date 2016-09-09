//
//  UIStoryboard+CDTools.swift
//  CDTools
//
//  Created by Christian Deckert on 30.06.16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation
import UIKit

public extension UIStoryboard {
    public static func mainStoryboard(bundle: NSBundle? = nil) -> UIStoryboard {
        return UIStoryboard(name: "Main", bundle: bundle)
    }
    
    public static func padStoryboard(bundle: NSBundle? = nil) -> UIStoryboard {
        return UIStoryboard(name: "iPad", bundle: bundle)
    }
    
    public static func phoneStoryboard(bundle: NSBundle? = nil) -> UIStoryboard {
        return UIStoryboard(name: "iPhone", bundle: bundle)
    }
}
