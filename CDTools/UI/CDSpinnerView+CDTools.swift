//
//  CDSpinnerView+XRCore.swift
//  XRCore
//
//  Created by Peter Jarosz on 20.09.16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation
import UIKit

public extension UITextField {
    
    public func presentSpinner(withItems items: [CDSpinnerViewItem], callbackBlock block: @escaping (CDSpinnerViewItem) -> Void, applyTextfieldAppearance: Bool = false, completion: ((Void) -> Void)? = nil) -> CDSpinnerView? {
        guard let viewController = UIApplication.shared.keyWindow?.rootViewController else {
            return nil
        }
        
        
        guard let superView = self.superview else {
            return nil
        }
        
        if applyTextfieldAppearance {
            CDSpinnerViewAppearance.backgroundStyle = .color(color: self.backgroundColor ?? UIColor.white)
            if let font = self.font {
                CDSpinnerViewAppearance.font = font
            }
            CDSpinnerViewAppearance.textColor = self.textColor ?? UIColor.black
            CDSpinnerViewAppearance.cornerRadius = self.layer.cornerRadius <= 0 ? 5.0 : self.layer.cornerRadius
            CDSpinnerViewAppearance.cellHeight = self.bounds.height
        }
        
        if let text = self.text {
            for (index, item) in items.enumerated() {
                if item.humanReadableString() == text {
                    CDSpinnerViewAppearance.selectedItemIndex = index
                    break
                }
            }
        }
        
        let rect = viewController.view.convert(self.frame, from: superView)
        return CDSpinnerView.present(inViewController: viewController, withItems: items, callbackBlock: block, sourceRect: rect, willPresentClosure: nil, completion: completion)
    }
    
}

extension CDSpinnerView {
    
    public static func present(withItems items: [CDSpinnerViewItem], callbackBlock block: @escaping (CDSpinnerViewItem) -> Void, completion: ((Void) -> Void)? = nil) -> CDSpinnerView? {
        guard let viewController = UIApplication.shared.keyWindow?.rootViewController else {
            return nil
        }
        
        return present(inViewController: viewController, withItems: items, callbackBlock: block, willPresentClosure: nil, completion: completion)
    }
    
    public static func present(fromRect sourceRect: CGRect, withItems items: [CDSpinnerViewItem], callbackBlock block: @escaping (CDSpinnerViewItem) -> Void, completion: ((Void) -> Void)? = nil) -> CDSpinnerView? {
        
        return CDSpinnerView.present(fromRect: sourceRect, withItems: items, willPresentClosure: { spinnerView in
            
            }, callbackBlock: block, completion: completion)
    }
    
    public static func present(fromRect sourceRect: CGRect, withItems items: [CDSpinnerViewItem], willPresentClosure: @escaping ((CDSpinnerView) -> Void), callbackBlock block: @escaping (CDSpinnerViewItem) -> Void, completion: ((Void) -> Void)? = nil) -> CDSpinnerView? {
        guard let viewController = UIApplication.shared.keyWindow?.rootViewController else {
            return nil
        }
        
        return present(inViewController: viewController, withItems: items, callbackBlock: block, sourceRect: sourceRect, willPresentClosure: willPresentClosure, completion: completion)
    }
    
}
