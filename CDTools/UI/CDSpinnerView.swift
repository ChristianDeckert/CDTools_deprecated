//
//  CDSpinnerView.swift
//  AdlerMannheimFanApp
//
//  Created by Christian Deckert on 30.08.16.
//  Copyright © 2016 x-root Software GmbH. All rights reserved.
//

import UIKit
import Foundation


@objc public protocol CDSpinnerViewItem: NSObjectProtocol {
    
    func humanReadableString() -> String
    optional func image() -> UIImage?
    
}

public class CDSpinnerViewCell: CDTableViewCell {
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    
}

public enum CDSpinnerViewBackgroundStyle {
    case Translucent
    case Color(color: UIColor)
}

public class CDSpinnerViewAppearance {
    
    public static func defaultAppearance() {
        CDSpinnerViewAppearance.animationDuration = 0.3
        CDSpinnerViewAppearance.backgroundStyle = .Translucent
        CDSpinnerViewAppearance.cornerRadius = 0
        CDSpinnerViewAppearance.font = nil
        CDSpinnerViewAppearance.textColor = UIColor.blackColor()
        CDSpinnerViewAppearance.cellHeight = 44.0
        CDSpinnerViewAppearance.selectedItemIndex = nil
        CDSpinnerViewAppearance.dropShadow = false
        CDSpinnerViewAppearance.shadowRadius = 4
        CDSpinnerViewAppearance.shadowOpacity = 0.5
        CDSpinnerViewAppearance.shadowOffset = CGSizeZero
        CDSpinnerViewAppearance.imageContentMode = .Center
        CDSpinnerViewAppearance.tintColor = nil
    }
    
    public static var animationDuration: Double = 0.3
    public static var backgroundStyle: CDSpinnerViewBackgroundStyle = .Translucent
    public static var cornerRadius: CGFloat = 0
    public static var font: UIFont?
    public static var textColor = UIColor.blackColor()
    public static var cellHeight: CGFloat = 44.0
    public static var selectedItemIndex: Int?
    public static var dropShadow: Bool = false
    public static var shadowRadius: CGFloat = 4
    public static var shadowOpacity: Float = 0.5
    public static var shadowOffset: CGSize = CGSizeZero
    public static var imageContentMode: UIViewContentMode = .Center
    public static var tintColor: UIColor?
}

public class CDSpinnerView: UIView, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var visualEffectView: UIVisualEffectView!
    
    public var items = [CDSpinnerViewItem]()
    public var callback: (CDSpinnerViewItem -> Void)?
    public var dismissCallback: ((spinnerView: CDSpinnerView) -> Void)?
    
    var isDismissing: Bool = false
    
    var sourceRect: CGRect?
    
    @available(iOS, deprecated=3.2.0, obsoleted=3.2.1,  message="Please use CDSpinnerViewAppearance") public var font: UIFont?
    @available(iOS, deprecated=3.2.0, obsoleted=3.2.1,  message="Please use CDSpinnerViewAppearance") public var textColor = UIColor.blackColor()
    @available(iOS, deprecated=3.2.0, obsoleted=3.2.1,  message="Please use CDSpinnerViewAppearance") var cellHeight: CGFloat = 44.0
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        //todo bundle
        let bundle = NSBundle(forClass: CDSpinnerViewCell.classForCoder())
        tableView.registerNib(UINib(nibName: "CDSpinnerViewCell", bundle: bundle), forCellReuseIdentifier: CDSpinnerViewCell.cellReuseIdentifier())
        tableView.separatorStyle = .None
        tableView.separatorColor = UIColor.clearColor()
        tableView.separatorInset = UIEdgeInsetsZero
        autoresizingMask = UIViewAutoresizing.FlexibleWidth.union(.FlexibleHeight)
    }
    
    public override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        if self.superview == nil {
            CDSpinnerViewAppearance.defaultAppearance()
        } else {
            updateAppearance()
        }
    }
    
    public func updateAppearance() {
        
        if let tintColor = CDSpinnerViewAppearance.tintColor {
            self.tintColor = tintColor
        }
        
        switch CDSpinnerViewAppearance.backgroundStyle {
        case .Color(let color):
            self.backgroundColor = color
            self.visualEffectView.hidden = true
            
        default:
            self.visualEffectView.hidden = false
            self.backgroundColor = UIColor.clearColor()
        }
        
        self.layer.cornerRadius = CDSpinnerViewAppearance.cornerRadius
        self.layer.borderColor = UIColor.clearColor().CGColor
        self.clipsToBounds = true
        
        if CDSpinnerViewAppearance.dropShadow {
            self.layer.shadowColor = UIColor.blackColor().CGColor
            self.layer.shadowRadius = CDSpinnerViewAppearance.shadowRadius
            self.layer.shadowOpacity = CDSpinnerViewAppearance.shadowOpacity
            self.layer.shadowOffset = CDSpinnerViewAppearance.shadowOffset
            self.clipsToBounds = false
        } else {
            self.layer.shadowColor = nil
            self.layer.shadowRadius = 0
            self.layer.shadowOpacity = 0
            self.clipsToBounds = true
        }
        reloadData(false)
        
    }
    
    public override func hitTest(point: CGPoint, withEvent event: UIEvent?) -> UIView? {
        
        var hittedView: UIView? = super.hitTest(point, withEvent: event)
        
        guard nil == hittedView else {
            return hittedView
        }
        
        for (_, view) in subviews.reverse().enumerate() {
            if let hit = view.hitTest(point, withEvent: event) {
                hittedView = hit
                break;
            }
        }
        
        if nil == hittedView {
            // tapped outside
            dismiss()
            return self
        }
        
        return super.hitTest(point, withEvent: event)
    }
    
    public func reloadData(animated: Bool = true) {
        
        if animated {
            
            tableView.beginUpdates()
            tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: UITableViewRowAnimation.Fade)
            tableView.endUpdates()
        } else {
            tableView.reloadData()
        }
    }
    
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    
    public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return CDSpinnerViewAppearance.cellHeight
    }
    
    public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        UIView.animateWithDuration(CDSpinnerViewAppearance.animationDuration, animations: {
            
            for cell in tableView.visibleCells {
                guard let spinnerCell = cell as? CDSpinnerViewCell else {
                    continue
                }
                
                if spinnerCell.indexPath.row != indexPath.row {
                    spinnerCell.alpha = 0.0
                }
            }
            
        }) { (complete) in
            self.dismiss {
                self.callback?(self.items[indexPath.row])
            }
        }
    }
    
    public func dismiss(completion: (Void->Void)? = nil) {
        if isDismissing {
            return
        }
        isDismissing = true
        
        if let sourceRect = self.sourceRect {
            UIView.animateWithDuration(CDSpinnerViewAppearance.animationDuration, animations: {
                self.frame = sourceRect
                self.alpha = 0
                }, completion: { (complete) in
                    completion?()
                    self.removeFromSuperview()
            })
        } else {
            UIView.animateWithDuration(CDSpinnerViewAppearance.animationDuration, animations: {
                self.transform = CGAffineTransformMakeScale(0.01, 0.01)
                }, completion: { (complete) in
                    completion?()
                    self.removeFromSuperview()
            })
        }
        
        self.dismissCallback?(spinnerView: self)
    }
    
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(CDSpinnerViewCell.cellReuseIdentifier()) as! CDSpinnerViewCell
        
        let item = items[indexPath.row]
        cell.label.text = item.humanReadableString()
        
        if let image = item.image?() {
            cell.label.hidden = true
            cell.iconImageView.image = image
        } else {
            cell.label.hidden = false
            cell.iconImageView.image = nil
        }
        cell.iconImageView.contentMode = CDSpinnerViewAppearance.imageContentMode
        if let font = CDSpinnerViewAppearance.font {
            cell.label.font = font
        }
        cell.label.textColor = CDSpinnerViewAppearance.textColor
        cell.indexPath = indexPath
        return cell
    }
    
    public func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        let clearView = UIView(frame: CGRectZero)
        clearView.backgroundColor = UIColor.clearColor()
        cell.selectedBackgroundView = clearView
    }
    
    /// Present without source rect
    public static func present(inViewController viewController: UIViewController, withItems items: [CDSpinnerViewItem], callbackBlock block: CDSpinnerViewItem -> Void, willPresentClosure: (CDSpinnerView -> Void)? = nil, completion: (Void -> Void)? = nil) -> CDSpinnerView? {
        return CDSpinnerView.present(inViewController: viewController, withItems: items, callbackBlock: block, sourceRect: nil, willPresentClosure: willPresentClosure, completion: completion)
    }
    
    public static func present(inViewController viewController: UIViewController, withItems items: [CDSpinnerViewItem], callbackBlock block: CDSpinnerViewItem -> Void, sourceRect: CGRect?, willPresentClosure: (CDSpinnerView -> Void)? = nil, completion: (Void -> Void)? = nil) -> CDSpinnerView? {
        let bundle = NSBundle(forClass: CDSpinnerView.classForCoder())
        if let spinnerView: CDSpinnerView = bundle.loadNibNamed("CDSpinnerView", owner: nil, options: nil)!.first as? CDSpinnerView {
            spinnerView.sourceRect = sourceRect
            spinnerView.callback = block
            spinnerView.items = items
            spinnerView.alpha = 0
            viewController.view.addSubview(spinnerView)
            
            willPresentClosure?(spinnerView)
            
            if let sourceRect = sourceRect {
                let h: CGFloat = UIScreen.mainScreen().bounds.height
                let initalRect = CGRectMake(sourceRect.origin.x, sourceRect.origin.y, sourceRect.width, 0)
                spinnerView.frame = initalRect
                
                let finalHeight: CGFloat = min(h - sourceRect.origin.y, CGFloat(items.count) * CDSpinnerViewAppearance.cellHeight)
                let finalRect = CGRectMake(sourceRect.origin.x, sourceRect.origin.y, sourceRect.width, finalHeight)
                UIView.animateWithDuration(CDSpinnerViewAppearance.animationDuration, animations: {
                    spinnerView.alpha = 1
                    spinnerView.frame = finalRect
                    }, completion: { (complete) in
                        completion?()
                })
                
            } else {
                let h = min(UIScreen.mainScreen().bounds.height * 0.8, CGFloat(items.count) * CDSpinnerViewAppearance.cellHeight)
                let w = UIScreen.mainScreen().bounds.width * 0.8
                let x = UIScreen.mainScreen().bounds.width * 0.1
                spinnerView.frame = CGRectMake(x, (UIScreen.mainScreen().bounds.height - h) / 2, w, h)
                
                spinnerView.transform = CGAffineTransformMakeScale(0.01, 0.01)
                UIView.animateWithDuration(CDSpinnerViewAppearance.animationDuration, animations: {
                    spinnerView.alpha = 1
                    spinnerView.transform = CGAffineTransformIdentity
                    
                    }, completion: { (complete) in
                        completion?()
                })
            }
            
            let time = dispatch_time(DISPATCH_TIME_NOW, Int64(0.075 * Double(NSEC_PER_SEC)))
            dispatch_after(time, dispatch_get_main_queue(), {
                spinnerView.selectIfNeeded(false)
            })
            
            return spinnerView
        }
        
        return nil
    }
    
    func selectIfNeeded(animated: Bool = true) {
        if let selectedItemIndex = CDSpinnerViewAppearance.selectedItemIndex where selectedItemIndex < items.count {
            tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: selectedItemIndex, inSection: 0), atScrollPosition: .Top, animated: animated)
        }
    }
    
}