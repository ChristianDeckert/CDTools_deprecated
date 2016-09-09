//
//  CDViewControllerExtension.swift
//
//
//  Created by Christian Deckert on 20.10.14.
//  Copyright (c) 2016 Christian Deckert. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    
    // MARK: - Storyboard ID
    
    /// This class method extracts the class name that is used as Storyboard Identifier.
    /// No need for strings anymore - awesome
    ///
    /// :param: none
    /// :returns: class name as String
    public class func storyBoardIdentifier() -> String {
        return String(NSStringFromClass(self.classForCoder()).componentsSeparatedByString(".")[1])
    }
    
    /// adds a child view controller
    
    public func addChildViewController(viewController: UIViewController, animated: Bool, completionBlock: ((Void)->(Void))?) {
        
        self.addChildViewController(viewController)
        viewController.view.alpha = 0.0
        
        self.view.addSubview(viewController.view)
        viewController.didMoveToParentViewController(self)
        viewController.beginAppearanceTransition(true, animated: animated)
        if animated {
            UIView.animateWithDuration(0.4, animations: { () in viewController.view.alpha = 1.0 }, completion: { (complete) in
                viewController.endAppearanceTransition()
                if let completionBlock = completionBlock {
                    completionBlock()
                }
            })
        } else {
            viewController.view.alpha = 1.0
            viewController.endAppearanceTransition()
            if let completionBlock = completionBlock {
                completionBlock()
            }
        }
    }
    
    public func addChildViewController(viewController: UIViewController, parentView: UIView?, duration: Double, animations: ((Void)->(Void)), completionBlock: ((Void)->(Void))?) {
        
        self.addChildViewController(viewController)
        
        if let parentView = parentView {
            parentView.addSubview(viewController.view)
        } else {
            self.view.addSubview(viewController.view)
        }
        viewController.didMoveToParentViewController(self)
        viewController.beginAppearanceTransition(true, animated: true)
        
        UIView.animateWithDuration(duration, animations: animations, completion: { (complete) in
            viewController.endAppearanceTransition()
            if let completionBlock = completionBlock {
                completionBlock()
            }
        })
    }
    
    /// remove a child view controller
    public func removeChildViewController(viewController: UIViewController, animated: Bool) {
        let animations = { [unowned viewController] () in
            viewController.view.alpha = 0.0
        }
        
        self.removeChildViewController(viewController, animated: animated, delay: 0.0, animations: animations, completionBlock: nil)
    }
    
    /// remove a child view controller
    public func removeChildViewController(viewController: UIViewController, animated: Bool, delay: Double, animations: ((Void)->(Void)), completionBlock: ((Void) -> (Void))?) {
        
        if animated {
            viewController.view.alpha = 1.0
        }
        
        if animated {
            UIView.animateKeyframesWithDuration(0.4, delay: delay, options: UIViewKeyframeAnimationOptions.AllowUserInteraction, animations: animations, completion: { (complete) in
                    viewController.willMoveToParentViewController(nil)
                    viewController.beginAppearanceTransition(false, animated: animated)
                    viewController.removeFromParentViewController()
                    viewController.didMoveToParentViewController(nil)
                    viewController.view.removeFromSuperview()
                    viewController.endAppearanceTransition()
                    if let completionBlock = completionBlock {
                        completionBlock()
                    }
            })
        } else {
            viewController.willMoveToParentViewController(nil)
            viewController.beginAppearanceTransition(false, animated: animated)
            viewController.removeFromParentViewController()
            viewController.didMoveToParentViewController(nil)
            viewController.view.removeFromSuperview()
            viewController.endAppearanceTransition()
            if let completionBlock = completionBlock {
                completionBlock()
            }
        }
    }
}