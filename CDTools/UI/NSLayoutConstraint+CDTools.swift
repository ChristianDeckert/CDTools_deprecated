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
    
    public class func embed(view: UIView, in parentView: UIView, insets: UIEdgeInsets = .zero) {
        fullscreenLayout(forView: view, in: parentView, insets: insets)
    }
    
    public class func fullscreenLayout(forView view: UIView, in parentView: UIView, insets: UIEdgeInsets = UIEdgeInsets.zero) {
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let leadingConstraint = NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: parentView, attribute: NSLayoutAttribute.leading, multiplier: 1.0, constant: -1.0 * insets.left)
        
        let trailingConstraint = NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: parentView, attribute: NSLayoutAttribute.trailing, multiplier: 1.0, constant: -1.0 * insets.right)
        
        let topConstraint = NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: parentView, attribute: NSLayoutAttribute.top, multiplier: 1.0, constant: -1.0 * insets.top)
        
        let bottomConstraint = NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: parentView, attribute: NSLayoutAttribute.bottom, multiplier: 1.0, constant: -1.0 * insets.bottom)
        
        let layoutContraints = [leadingConstraint, trailingConstraint, topConstraint, bottomConstraint]
        parentView.addConstraints(layoutContraints)
        
    }
    
    public class func topEdgeLayout(forView view: UIView, in parentView: UIView, height: CGFloat) {
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let leadingConstraint = NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: parentView, attribute: NSLayoutAttribute.leading, multiplier: 1.0, constant: 0)
        
        let trailingConstraint = NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: parentView, attribute: NSLayoutAttribute.trailing, multiplier: 1.0, constant: 0)
        
        let topConstraint = NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: parentView, attribute: NSLayoutAttribute.top, multiplier: 1.0, constant: 0)
        
        view.addConstraint(NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1.0, constant: height))
        
        let layoutContraints = [leadingConstraint, trailingConstraint, topConstraint]
        parentView.addConstraints(layoutContraints)
    }
    
    public class func rightEdgeLayout(forView view: UIView, in parentView: UIView, width: CGFloat) {
        NSLayoutConstraint.rightEdgeLayout(forView: view, in: parentView, marginTop: 0.0, marginBottom: 0.0, marginRight: 0.0, width: width)
    }
    
    public class func rightEdgeLayout(forView view: UIView, in parentView: UIView, marginTop: CGFloat, marginBottom: CGFloat, marginRight: CGFloat, width: CGFloat) {
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let bottomConstraint = NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: parentView, attribute: NSLayoutAttribute.bottom, multiplier: 1.0, constant: marginBottom)
        
        let trailingConstraint = NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: parentView, attribute: NSLayoutAttribute.trailing, multiplier: 1.0, constant: marginRight)
        
        let topConstraint = NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: parentView, attribute: NSLayoutAttribute.top, multiplier: 1.0, constant: marginTop)
        
        view.addConstraint(NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1.0, constant: width))
        
        let layoutContraints = [bottomConstraint, trailingConstraint, topConstraint]
        parentView.addConstraints(layoutContraints)
    }
    
    public class func leftEdgeLayout(forView view: UIView, in parentView: UIView, width: CGFloat) {
        NSLayoutConstraint.leftEdgeLayout(forView: view, in: parentView, marginTop: 0.0, marginBottom: 0.0, marginLeft: 0.0, width: width)
    }
    
    public class func leftEdgeLayout(forView view: UIView, in parentView: UIView, marginTop: CGFloat, marginBottom: CGFloat, marginLeft: CGFloat, width: CGFloat) {
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let leadingConstraint = NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: parentView, attribute: NSLayoutAttribute.leading, multiplier: 1.0, constant: marginLeft)
        
        let bottomConstraint = NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: parentView, attribute: NSLayoutAttribute.bottom, multiplier: 1.0, constant: marginBottom)
        
        let topConstraint = NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: parentView, attribute: NSLayoutAttribute.top, multiplier: 1.0, constant: marginTop)
        
        view.addConstraint(NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1.0, constant: width))
        
        let layoutContraints = [bottomConstraint, leadingConstraint, topConstraint]
        parentView.addConstraints(layoutContraints)
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

