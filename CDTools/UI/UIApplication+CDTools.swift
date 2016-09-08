//
//  UIApplication+CDTools.swift
//  CDTools
//
//  Created by Christian Deckert on 30.06.16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation
import UIKit

public extension UIApplication {
    public class func isPad() -> Bool {
        if let appDelegate = UIApplication.sharedApplication().delegate {
            if let window = appDelegate.window! {
                if let rootVC = window.rootViewController {
                    return rootVC.traitCollection.userInterfaceIdiom == .Pad
                }
            }
        }
        return true
    }
    
    public class func isPhone() -> Bool {
        return !isPad()
    }
    
    public class func isLandscape() -> Bool {
        return UIInterfaceOrientationIsLandscape(UIApplication.sharedApplication().statusBarOrientation)
    }
    
    public class func isPortrait() -> Bool {
        return UIInterfaceOrientationIsPortrait(UIApplication.sharedApplication().statusBarOrientation)
    }
    
    
    
    class func appVersion() -> String {
        return NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleShortVersionString") as! String
    }
    
    class func appBuild() -> String {
        return NSBundle.mainBundle().objectForInfoDictionaryKey(kCFBundleVersionKey as String) as! String
    }
    
    
}