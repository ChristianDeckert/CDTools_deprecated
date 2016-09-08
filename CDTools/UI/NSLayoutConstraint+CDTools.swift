//
//  NSLayoutConstraint+CDTools.swift
//  CDTools
//
//  Created by Christian Deckert on 30.06.16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit
import Foundation


/* Note: don'f forget to set parentViews translatesAutoResizingMaskToConstraints to false */
public extension NSLayoutConstraint {
    
    
    /// Embedd a view
    public class func fullscreenLayoutForView(viewToLayout view: UIView, inView parentView: UIView, insets: UIEdgeInsets = UIEdgeInsetsZero) {

        let leadingConstraint = NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: parentView, attribute: NSLayoutAttribute.Leading, multiplier: 1.0, constant: -1.0 * insets.left)
        
        let trailingConstraint = NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: parentView, attribute: NSLayoutAttribute.Trailing, multiplier: 1.0, constant: -1.0 * insets.right)
        
        let topConstraint = NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: parentView, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: -1.0 * insets.top)
        
        let bottomConstraint = NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: parentView, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: -1.0 * insets.bottom)
        
        let layoutContraints = [leadingConstraint, trailingConstraint, topConstraint, bottomConstraint]
        parentView.addConstraints(layoutContraints)
        
        view.frame = parentView.bounds

        parentView.setNeedsLayout()
        parentView.layoutIfNeeded()
    }
    
    public class func topEdgeLayoutForView(viewToLayout view: UIView, inView parentView: UIView, height: CGFloat) {
        
        let leadingConstraint = NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: parentView, attribute: NSLayoutAttribute.Leading, multiplier: 1.0, constant: 0)
        
        let trailingConstraint = NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: parentView, attribute: NSLayoutAttribute.Trailing, multiplier: 1.0, constant: 0)
        
        let topConstraint = NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: parentView, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: 0)
        
        view.addConstraint(NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: height))
        
        let layoutContraints = [leadingConstraint, trailingConstraint, topConstraint]
        parentView.addConstraints(layoutContraints)
        
        parentView.setNeedsLayout()
        parentView.layoutIfNeeded()
    }
    
    public class func rightEdgeLayoutForView(viewToLayout view: UIView, inView parentView: UIView, width: CGFloat) {
        NSLayoutConstraint.rightEdgeLayoutForView(viewToLayout: view, inView: parentView, marginTop: 0.0, marginBottom: 0.0, marginRight: 0.0, width: width)
    }
    
    public class func rightEdgeLayoutForView(viewToLayout view: UIView, inView parentView: UIView, marginTop: CGFloat, marginBottom: CGFloat, marginRight: CGFloat, width: CGFloat) {
        
        let bottomConstraint = NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: parentView, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: marginBottom)
        
        let trailingConstraint = NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: parentView, attribute: NSLayoutAttribute.Trailing, multiplier: 1.0, constant: marginRight)
        
        let topConstraint = NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: parentView, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: marginTop)
        
        view.addConstraint(NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: width))
        
        let layoutContraints = [bottomConstraint, trailingConstraint, topConstraint]
        parentView.addConstraints(layoutContraints)
        
        parentView.setNeedsLayout()
        parentView.layoutIfNeeded()
        
        
    }
    
    public class func leftEdgeLayoutForView(viewToLayout view: UIView, inView parentView: UIView, width: CGFloat) {
        NSLayoutConstraint.leftEdgeLayoutForView(viewToLayout: view, inView: parentView, marginTop: 0.0, marginBottom: 0.0, marginLeft: 0.0, width: width)
    }
    
    public class func leftEdgeLayoutForView(viewToLayout view: UIView, inView parentView: UIView, marginTop: CGFloat, marginBottom: CGFloat, marginLeft: CGFloat, width: CGFloat) {
        
        let leadingConstraint = NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: parentView, attribute: NSLayoutAttribute.Leading, multiplier: 1.0, constant: marginLeft)
        
        let bottomConstraint = NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: parentView, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: marginBottom)
        
        let topConstraint = NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: parentView, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: marginTop)
        
        view.addConstraint(NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: width))
        
        let layoutContraints = [bottomConstraint, leadingConstraint, topConstraint]
        parentView.addConstraints(layoutContraints)
        
        parentView.setNeedsLayout()
        parentView.layoutIfNeeded()
    }
    
    
    /// Remove all constraints for a specific view
    public class func removeAllConstraints(forView view: UIView, inView parentView: UIView) -> Bool {
        
        var constraintsToRemove = Array<NSLayoutConstraint>()
        
        for constraint in parentView.constraints {
            let layoutConstraint = constraint
            if let firstItem = layoutConstraint.firstItem as? NSObject {
                if firstItem == view {
                    constraintsToRemove.append(layoutConstraint)
                }
            } else if let secondItem = layoutConstraint.secondItem as? NSObject {
                if secondItem == view {
                    constraintsToRemove.append(layoutConstraint)
                }
            }
            
        }
        
        if constraintsToRemove.count > 0 {
            parentView.removeConstraints(constraintsToRemove)
            return true
        }
        
        return false
    }
    
}

