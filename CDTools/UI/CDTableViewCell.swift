//
//  CDTableViewCell.swift
//  
//
//  Created by Christian Deckert on 21.10.16.
//  Copyright (c) 2014 Christian Deckert GmbH. All rights reserved.
//

import UIKit
import Foundation

open class CDTableViewCell: UITableViewCell {
    
    open var indexPath: IndexPath = IndexPath()
    open weak var weakContentView: UIView?
    open weak var paddingView: UIView?
    open var padding: CGFloat = 32.0    
    
    open override func awakeFromNib() {
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
    open func commonInit() {

    }

    open class func cellReuseIdentifier() -> String {
        return String(NSStringFromClass(self.classForCoder()).components(separatedBy: ".")[1])
    }
    
    
    open func setPaddingLevel(_ level: Int) {
    
        if let paddingView = self.paddingView {
            
            var widthConstraint: NSLayoutConstraint? = nil
            for constraint in paddingView.constraints {
                if constraint.firstAttribute == NSLayoutAttribute.width {
                    if let firstView = constraint.firstItem as? UIView {
                        if firstView == paddingView {
                            widthConstraint = constraint
                            break
                        }
                    }
                }
            }
            
            if let oldWidthConstraint = widthConstraint {
                let newWidthConstraint = NSLayoutConstraint(item: paddingView, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.width, multiplier: 1.0, constant: self.padding * CGFloat(level))
                paddingView.removeConstraint(oldWidthConstraint)
                paddingView.addConstraint(newWidthConstraint)
                
                UIView.animate(withDuration: 0.4, animations: { () -> Void in
                    paddingView.setNeedsLayout()
                    paddingView.layoutIfNeeded()
                })
                
            }
        }
    }
}
