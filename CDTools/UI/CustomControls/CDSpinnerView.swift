//
//  CDSpinnerView.swift
//  AdlerMannheimFanApp
//
//  Created by Christian Deckert on 30.08.16.
//  Copyright © 2016 Christian Deckert Software GmbH. All rights reserved.
//

import UIKit
import Foundation

public class CDSpinnerViewCell: CDTableViewCell {
    
    @IBOutlet weak var label: UILabel!
    
}

public class CDSpinnerView: UIView, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var visualEffectView: UIVisualEffectView!
    
    public var font: UIFont?
    public var textColor = UIColor.blackColor()
    
    public var items = [String]()
    var callback: (String -> Void)?
    var cellHeight: CGFloat = 44.0
    var isDismissing: Bool = false
    
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
        reloadData(false)
    }
    
    public override func hitTest(point: CGPoint, withEvent event: UIEvent?) -> UIView? {
        
        var hittedView: UIView? = nil
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
        return cellHeight
    }
    
    public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        UIView.animateWithDuration(0.3, animations: {
            
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
        UIView.animateWithDuration(0.3, animations: {
            self.transform = CGAffineTransformMakeScale(0.01, 0.01)
            }, completion: { (complete) in
                completion?()
                self.removeFromSuperview()
        })
        
    }
    
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(CDSpinnerViewCell.cellReuseIdentifier()) as! CDSpinnerViewCell
        cell.label.text = items[indexPath.row]
        
        if let font = self.font {
            cell.label.font = font
        }
        cell.label.textColor = textColor
        cell.indexPath = indexPath
        return cell
    }
    
    public func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        let clearView = UIView(frame: CGRectZero)
        clearView.backgroundColor = UIColor.clearColor()
        cell.selectedBackgroundView = clearView
    }
    
    public static func present(withItems items: [String], callbackBlock block: String -> Void, completion: (Void -> Void)? = nil) -> CDSpinnerView? {
        
        guard let viewController = UIApplication.sharedApplication().keyWindow?.rootViewController else {
            return nil
        }
        let bundle = NSBundle(forClass: CDSpinnerView.classForCoder())
        if let spinnerView: CDSpinnerView = bundle.loadNibNamed("CDSpinnerView", owner: nil, options: nil).first as? CDSpinnerView {
            spinnerView.callback = block
            spinnerView.items = items
            spinnerView.alpha = 0
            viewController.view.addSubview(spinnerView)
            
            let h = min(UIScreen.mainScreen().bounds.height * 0.8, CGFloat(items.count) * spinnerView.cellHeight)
            let w = UIScreen.mainScreen().bounds.width * 0.8
            let x = UIScreen.mainScreen().bounds.width * 0.1
            spinnerView.frame = CGRectMake(x, (UIScreen.mainScreen().bounds.height - h) / 2, w, h)
            
            spinnerView.transform = CGAffineTransformMakeScale(0.01, 0.01)
            UIView.animateWithDuration(0.3, animations: {
                spinnerView.alpha = 1
                spinnerView.transform = CGAffineTransformIdentity
                }, completion: { (complete) in
                    completion?()
            })
            
            return spinnerView
        }
        
        return nil
    }
}
