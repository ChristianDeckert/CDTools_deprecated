//
//  UIImageView+CDTools.swift
//  
//
//  Created by Christian Deckert on 04.08.15.
//  Copyright (c) 2015 Christian Deckert. All rights reserved.
//

import UIKit
import Foundation

typealias CoreImage = CIImage

public extension UIImage {
    
    public func averageColor() -> UIColor? {
        
        let rgba = UnsafeMutablePointer<CUnsignedChar>.alloc(4)
        if let colorSpace: CGColorSpaceRef = CGColorSpaceCreateDeviceRGB() {
            let info = CGBitmapInfo(rawValue: CGImageAlphaInfo.PremultipliedLast.rawValue)
            if let context: CGContextRef = CGBitmapContextCreate(rgba, 1, 1, 8, 4, colorSpace, info.rawValue) {
            
                CGContextDrawImage(context, CGRectMake(0, 0, 1, 1), self.CGImage!)
                
                if rgba[3] > 0 {
                    
                    let alpha: CGFloat = CGFloat(rgba[3]) / 255.0
                    let multiplier: CGFloat = alpha / 255.0
                    
                    return UIColor(red: CGFloat(rgba[0]) * multiplier, green: CGFloat(rgba[1]) * multiplier, blue: CGFloat(rgba[2]) * multiplier, alpha: alpha)
                    
                } else {
                    
                    return UIColor(red: CGFloat(rgba[0]) / 255.0, green: CGFloat(rgba[1]) / 255.0, blue: CGFloat(rgba[2]) / 255.0, alpha: CGFloat(rgba[3]) / 255.0)
                }
            }
        }
        return nil
    }
    
    public func darken(withColor color: UIColor = UIColor.blackColor()) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale);
        guard let cgImage = self.CGImage else {
            return self
        }
        
        guard let context = UIGraphicsGetCurrentContext() else {
            return self
        }
        
        let area = CGRectMake(0, 0, self.size.width, self.size.height)
        CGContextScaleCTM(context, 1, -1)
        CGContextTranslateCTM(context, 0, -area.size.height);
        
        CGContextSaveGState(context);
        CGContextClipToMask(context, area, cgImage);
        
        color.set()
        
        CGContextFillRect(context, area);
        CGContextRestoreGState(context);
        CGContextSetBlendMode(context, CGBlendMode.Multiply);
        
        CGContextDrawImage(context, area, cgImage);
        
        let darkenedImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return darkenedImage
        
    }
    
    
    public func brighten(byScale brightness: CGFloat = 0.5) -> UIImage? {
        guard let inputCgImage = self.CGImage else {
            return self
        }
        
        let inputImage = CoreImage(CGImage: inputCgImage)
        
        guard let filter = CIFilter(name: "CIColorControls") else {
            return self
        }
        
        let context = CIContext.init(options: nil)
        
        filter.setValue(inputImage, forKey: kCIInputImageKey)
        filter.setValue(brightness, forKey: kCIInputBrightnessKey)
        
        guard let outputImage = filter.outputImage else {
            return self
        }
        
        guard let cgImage = context.createCGImage(outputImage, fromRect: outputImage.extent) else {
            return self
        }
        
        let brighterImage = UIImage(CGImage: cgImage)
        return brighterImage
        
    }
    
}
