//
//  BaseViewController.swift
//  QualiFood
//
//  Created by Christian Deckert on 16.06.16.
//  Copyright © 2016 Christian Deckert. All rights reserved.
//

import Foundation
import UIKit

public extension UIViewController {
    public class func storyboardIdentifier() -> String {
        return String(NSStringFromClass(self.classForCoder()).componentsSeparatedByString(".")[1] ?? "Unexpected Error")
    }
    
    static func newInstance(preferredStoryboard storyBoardName: String? = nil) -> UIViewController? {
        
        let storyboard: UIStoryboard
        if let storyBoardName = storyBoardName {
            storyboard = UIStoryboard(name: storyBoardName, bundle: nil)
        } else {
            storyboard = UIStoryboard.mainStoryboard()
        }
        return storyboard.instantiateViewControllerWithIdentifier(self.storyboardIdentifier())
    }
}

public class CDBaseViewController: UIViewController {

    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        commonInit()
    }
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    public func commonInit() {
        
    }
    
    public func xr_addChildViewController(childController: UIViewController, frame: CGRect? = nil) -> Bool {
        for viewController in self.childViewControllers {
            if viewController == childController {
                return false
            }
        }
        let rect = frame ?? self.view.bounds
        childController.view.frame = rect
        childController.willMoveToParentViewController(self)
        self.addChildViewController(childController)
        self.view.addSubview(childController.view)
        
        
        childController.didMoveToParentViewController(self)

        return true
    }

    
    public override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }


}
