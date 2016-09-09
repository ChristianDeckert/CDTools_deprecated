//
//  CDTableViewCell.swift
//  
//
//  Created by Christian Deckert on 21.10.16.
//  Copyright (c) 2014 Christian Deckert GmbH. All rights reserved.
//

import UIKit
import Foundation




public class CDTableViewCell: UITableViewCell {
    
    public var indexPath: NSIndexPath = NSIndexPath()
    public weak var weakContentView: UIView?
    public weak var paddingView: UIView?
    public var padding: CGFloat = 32.0    
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        self.commonInit()
    }
    
    public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.commonInit()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }

    /// To be overitten in sub classes
    public func commonInit() {

    }

    public class func cellReuseIdentifier() -> String {
        return String(NSStringFromClass(self.classForCoder()).componentsSeparatedByString(".")[1] ?? "Unexpected Error")
    }
    
    
    public func setPaddingLevel(level: Int) {
    
        if let paddingView = self.paddingView {
            
            var widthConstraint: NSLayoutConstraint? = nil
            for constraint in paddingView.constraints {
                if constraint.firstAttribute == NSLayoutAttribute.Width {
                    if let firstView = constraint.firstItem as? UIView {
                        if firstView == paddingView {
                            widthConstraint = constraint
                            break
                        }
                    }
                }
            }
            
            if let oldWidthConstraint = widthConstraint {
                let newWidthConstraint = NSLayoutConstraint(item: paddingView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.Width, multiplier: 1.0, constant: self.padding * CGFloat(level))
                paddingView.removeConstraint(oldWidthConstraint)
                paddingView.addConstraint(newWidthConstraint)
                
                UIView.animateWithDuration(0.4, animations: { () -> Void in
                    paddingView.setNeedsLayout()
                    paddingView.layoutIfNeeded()
                })
                
            }
        }
    }
}
