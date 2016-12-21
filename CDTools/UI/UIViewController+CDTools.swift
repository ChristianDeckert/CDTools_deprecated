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
        return String(NSStringFromClass(self.classForCoder()).components(separatedBy: ".")[1])
    }
    
    /// adds a child view controller
    
    public func addChildViewController(_ viewController: UIViewController, animated: Bool, completionBlock: ((Void)->(Void))?) {
        
        self.addChildViewController(viewController)
        viewController.view.alpha = 0.0
        
        self.view.addSubview(viewController.view)
        viewController.didMove(toParentViewController: self)
        viewController.beginAppearanceTransition(true, animated: animated)
        if animated {
            UIView.animate(withDuration: 0.4, animations: { () in viewController.view.alpha = 1.0 }, completion: { (complete) in
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
    
    public func addChildViewController(_ viewController: UIViewController, parentView: UIView?, duration: Double, animations: @escaping ((Void)->(Void)), completionBlock: ((Void)->(Void))?) {
        
        self.addChildViewController(viewController)
        
        if let parentView = parentView {
            parentView.addSubview(viewController.view)
        } else {
            self.view.addSubview(viewController.view)
        }
        viewController.didMove(toParentViewController: self)
        viewController.beginAppearanceTransition(true, animated: true)
        
        UIView.animate(withDuration: duration, animations: animations, completion: { (complete) in
            viewController.endAppearanceTransition()
            if let completionBlock = completionBlock {
                completionBlock()
            }
        })
    }
    
    /// remove a child view controller
    public func removeChildViewController(_ viewController: UIViewController, animated: Bool) {
        let animations = { [unowned viewController] () in
            viewController.view.alpha = 0.0
        }
        
        self.removeChildViewController(viewController, animated: animated, delay: 0.0, animations: animations, completionBlock: nil)
    }
    
    /// remove a child view controller
    public func removeChildViewController(_ viewController: UIViewController, animated: Bool, delay: Double, animations: @escaping ((Void)->(Void)), completionBlock: ((Void) -> (Void))?) {
        
        if animated {
            viewController.view.alpha = 1.0
        }
        
        if animated {
            UIView.animateKeyframes(withDuration: 0.4, delay: delay, options: UIViewKeyframeAnimationOptions.allowUserInteraction, animations: animations, completion: { (complete) in
                    viewController.willMove(toParentViewController: nil)
                    viewController.beginAppearanceTransition(false, animated: animated)
                    viewController.removeFromParentViewController()
                    viewController.didMove(toParentViewController: nil)
                    viewController.view.removeFromSuperview()
                    viewController.endAppearanceTransition()
                    if let completionBlock = completionBlock {
                        completionBlock()
                    }
            })
        } else {
            viewController.willMove(toParentViewController: nil)
            viewController.beginAppearanceTransition(false, animated: animated)
            viewController.removeFromParentViewController()
            viewController.didMove(toParentViewController: nil)
            viewController.view.removeFromSuperview()
            viewController.endAppearanceTransition()
            if let completionBlock = completionBlock {
                completionBlock()
            }
        }
    }
}
