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
        return String(NSStringFromClass(self.classForCoder()).components(separatedBy: ".")[1])
    }
    
    static func newInstance(preferredStoryboard storyBoardName: String? = nil) -> UIViewController? {
        
        let storyboard: UIStoryboard
        if let storyBoardName = storyBoardName {
            storyboard = UIStoryboard(name: storyBoardName, bundle: nil)
        } else {
            storyboard = UIStoryboard.mainStoryboard()
        }
        return storyboard.instantiateViewController(withIdentifier: self.storyboardIdentifier())
    }
}

open class CDBaseViewController: UIViewController {

    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        commonInit()
    }
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    open func commonInit() {
        
    }
    
    open func cd_addChildViewController(_ childController: UIViewController, frame: CGRect? = nil) -> Bool {
        for viewController in self.childViewControllers {
            if viewController == childController {
                return false
            }
        }
        let rect = frame ?? self.view.bounds
        childController.view.frame = rect
        childController.willMove(toParentViewController: self)
        self.addChildViewController(childController)
        self.view.addSubview(childController.view)
        
        
        childController.didMove(toParentViewController: self)

        return true
    }

    
    open override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }


}
