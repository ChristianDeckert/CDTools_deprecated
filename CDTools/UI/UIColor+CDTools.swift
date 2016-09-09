//
//  UIColor+CDTools.swift
//
//
//  Created by Christian Deckert on 20.10.14.
//  Copyright (c) 2016 Christian Deckert. All rights reserved.
//

import Foundation
import UIKit

public extension UIColor {
    
    public class func colorFromString(colorString: String) -> UIColor? {
        let components = colorString.componentsSeparatedByString(";")
        
        var color: UIColor?
        if components.count == 3 {
            let red: NSString = components[0]
            let green: NSString = components[1]
            let blue: NSString = components[2]
            let r = CGFloat(red.floatValue / 255.0)
            let g = CGFloat(green.floatValue / 255.0)
            let b = CGFloat(blue.floatValue / 255.0)
            color = UIColor(red: r, green: g, blue: b, alpha: 1.0)
        }
        
        return color
    }
    
    /// Returns RGB seperated by ";"
    public func colorString() -> String {
        
        let numberOfComponents = CGColorGetNumberOfComponents(self.CGColor)
        var colorString = ""
        
        if (numberOfComponents == 2) {
            let components = CGColorGetComponents(self.CGColor)
            let compR = components[0]
            _ = components[1]
            
            colorString = NSString(format: "%li;%li;%li", Int(compR * 255.0), Int(compR * 255.0), Int(compR * 255.0)) as String
        }
        if (numberOfComponents > 3) {
            let components = CGColorGetComponents(self.CGColor)
            let compR = components[0]
            let compG = components[1]
            let compB = components[2]
//            let compA = components[3]
            
            colorString = NSString(format: "%li;%li;%li", Int(compR * 255.0), Int(compG * 255.0), Int(compB * 255.0)) as String
        }
        return colorString
    }
    
    public class func colorFromHex (hex: String) -> UIColor {
        var cString:String = hex.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).uppercaseString
        
        if (cString.hasPrefix("#")) {
            cString = (cString as NSString).substringFromIndex(1)
        }
        
        if (cString.nsString.length != 6) {
            return UIColor.grayColor()
        }
        
        let rString = (cString as NSString).substringToIndex(2)
        let gString = ((cString as NSString).substringFromIndex(2) as NSString).substringToIndex(2)
        let bString = ((cString as NSString).substringFromIndex(4) as NSString).substringToIndex(2)
        
        var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0;
        NSScanner(string: rString).scanHexInt(&r)
        NSScanner(string: gString).scanHexInt(&g)
        NSScanner(string: bString).scanHexInt(&b)
        
        return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: CGFloat(1))
    }
    
    public func hexString() -> String {
        
        var hexString = "#000000"
        
        let numberOfComponents = CGColorGetNumberOfComponents(self.CGColor)
        let components =  CGColorGetComponents(self.CGColor)
        if numberOfComponents >= 3 {
            let r = components[0]
            let g = components[1]
            let b = components[2]
            
            hexString = NSString(format: "#%02X%02X%02X", Int16(r * 255), Int16(g * 255), Int16(b * 255)) as String
        }
        return hexString as String
    }
    
    class func randomColor() -> UIColor {
        let red = CGFloat(Double(arc4random() % 256) / 256.0)
        let green = CGFloat(Double(arc4random() % 256) / 256.0)
        let blue = CGFloat(Double(arc4random() % 256) / 256.0)
        return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    }
    
    func isLight() -> Bool
    {
        let components = CGColorGetComponents(self.CGColor)
        let brightness = ((components[0] * CGFloat(299.0)) + (components[1] * CGFloat(587.0)) + (components[2] * CGFloat(114.0))) / CGFloat(1000.0)
        
        if brightness < 0.5
        {
            return false
        }
        else
        {
            return true
        }
    }
    
    func isVeryLight() -> Bool
    {
        let components = CGColorGetComponents(self.CGColor)
        let brightness = ((components[0] * CGFloat(299)) + (components[1] * CGFloat(587)) + (components[2] * CGFloat(114))) / CGFloat(1000)
        
        if brightness < 0.85
        {
            return false
        }
        else
        {
            return true
        }
    }
}