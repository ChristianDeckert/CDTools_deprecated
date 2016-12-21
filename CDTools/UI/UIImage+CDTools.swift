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
        
        let rgba = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: 4)
        let colorSpace: CGColorSpace = CGColorSpaceCreateDeviceRGB()
        let info = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        if let context: CGContext = CGContext(data: rgba, width: 1, height: 1, bitsPerComponent: 8, bytesPerRow: 4, space: colorSpace, bitmapInfo: info.rawValue) {
        
            context.draw(self.cgImage!, in: CGRect(x: 0, y: 0, width: 1, height: 1))
            
            if rgba[3] > 0 {
                
                let alpha: CGFloat = CGFloat(rgba[3]) / 255.0
                let multiplier: CGFloat = alpha / 255.0
                
                return UIColor(red: CGFloat(rgba[0]) * multiplier, green: CGFloat(rgba[1]) * multiplier, blue: CGFloat(rgba[2]) * multiplier, alpha: alpha)
                
            } else {
                
                return UIColor(red: CGFloat(rgba[0]) / 255.0, green: CGFloat(rgba[1]) / 255.0, blue: CGFloat(rgba[2]) / 255.0, alpha: CGFloat(rgba[3]) / 255.0)
            }
        }
        
        return nil
    }
    
    public func darken(withColor color: UIColor = UIColor.black) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale);
        guard let cgImage = self.cgImage else {
            return self
        }
        
        guard let context = UIGraphicsGetCurrentContext() else {
            return self
        }
        
        let area = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
        context.scaleBy(x: 1, y: -1)
        context.translateBy(x: 0, y: -area.size.height);
        
        context.saveGState();
        context.clip(to: area, mask: cgImage);
        
        color.set()
        
        context.fill(area);
        context.restoreGState();
        context.setBlendMode(CGBlendMode.multiply);
        
        context.draw(cgImage, in: area);
        
        let darkenedImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return darkenedImage
        
    }
    
    
    public func brighten(byScale brightness: CGFloat = 0.5) -> UIImage? {
        guard let inputCgImage = self.cgImage else {
            return self
        }
        
        let inputImage = CoreImage(cgImage: inputCgImage)
        
        guard let filter = CIFilter(name: "CIColorControls") else {
            return self
        }
        
        let context = CIContext.init(options: nil)
        
        filter.setValue(inputImage, forKey: kCIInputImageKey)
        filter.setValue(brightness, forKey: kCIInputBrightnessKey)
        
        guard let outputImage = filter.outputImage else {
            return self
        }
        
        guard let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else {
            return self
        }
        
        let brighterImage = UIImage(cgImage: cgImage)
        return brighterImage
        
    }
    
}
