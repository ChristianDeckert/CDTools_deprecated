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
        if let appDelegate = UIApplication.shared.delegate {
            if let window = appDelegate.window! {
                if let rootVC = window.rootViewController {
                    return rootVC.traitCollection.userInterfaceIdiom == .pad
                }
            }
        }
        return true
    }
    
    public class func isPhone() -> Bool {
        return !isPad()
    }
    
    public class func isLandscape() -> Bool {
        return UIInterfaceOrientationIsLandscape(UIApplication.shared.statusBarOrientation)
    }
    
    public class func isPortrait() -> Bool {
        return UIInterfaceOrientationIsPortrait(UIApplication.shared.statusBarOrientation)
    }
    
    
    
    class func appVersion() -> String {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
    }
    
    class func appBuild() -> String {
        return Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as! String
    }
    
    
}
