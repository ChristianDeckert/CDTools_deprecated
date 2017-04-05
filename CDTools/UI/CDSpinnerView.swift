//
//  CDSpinnerView.swift
//  CDTools
//
//  Created by Christian Deckert on 30.08.16.
//  Copyright © 2016 Christian Deckert
//

import UIKit
import Foundation

@objc public protocol CDSpinnerViewItem: NSObjectProtocol {
    
    func humanReadableString() -> String
    @objc optional func image() -> UIImage?
    
}

open class CDSpinnerViewCell: CDTableViewCell {
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    
}

public enum CDSpinnerViewBackgroundStyle {
    case translucent
    case color(color: UIColor)
}

public enum CDSpinnerViewBoundsBehavior {
    case shrinkIfNeeded
    case adjustIfNeeded
}
open class CDSpinnerViewAppearance {
    
    open static func defaultAppearance() {
        CDSpinnerViewAppearance.animationDuration = 0.3
        CDSpinnerViewAppearance.backgroundStyle = .translucent
        CDSpinnerViewAppearance.cornerRadius = 0
        CDSpinnerViewAppearance.borderColor = UIColor.clear
        CDSpinnerViewAppearance.borderWidth = 0
        CDSpinnerViewAppearance.font = nil
        CDSpinnerViewAppearance.textColor = UIColor.black
        CDSpinnerViewAppearance.selectedItemTextColor = nil
        CDSpinnerViewAppearance.cellHeight = 44.0
        CDSpinnerViewAppearance.selectedItemIndex = nil
        CDSpinnerViewAppearance.dropShadow = false
        CDSpinnerViewAppearance.shadowRadius = 4
        CDSpinnerViewAppearance.shadowOpacity = 0.5
        CDSpinnerViewAppearance.shadowOffset = CGSize.zero
        CDSpinnerViewAppearance.imageContentMode = .center
        CDSpinnerViewAppearance.tintColor = nil
        CDSpinnerViewAppearance.boundsBehavior = .shrinkIfNeeded
        CDSpinnerViewAppearance.borderColor = nil
        CDSpinnerViewAppearance.borderWidth = 0
        CDSpinnerViewAppearance.shadowColor = UIColor.black
        CDSpinnerViewAppearance.insets = UIEdgeInsets.zero
    }
    
    open static var animationDuration: Double = 0.3
    open static var backgroundStyle: CDSpinnerViewBackgroundStyle = .translucent
    open static var cornerRadius: CGFloat = 0
    open static var font: UIFont?
    open static var textColor = UIColor.black
    open static var selectedItemTextColor: UIColor?
    open static var cellHeight: CGFloat = 44.0
    open static var selectedItemIndex: Int?
    open static var dropShadow: Bool = false
    open static var shadowRadius: CGFloat = 4
    open static var shadowOpacity: Float = 0.5
    open static var shadowOffset: CGSize = CGSize.zero
    open static var imageContentMode: UIViewContentMode = .center
    open static var tintColor: UIColor?
    open static var borderColor: UIColor? = UIColor.clear
    open static var borderWidth: CGFloat = 0.0
    open static var shadowColor: UIColor = UIColor.black
    open static var boundsBehavior: CDSpinnerViewBoundsBehavior = .shrinkIfNeeded
    open static var insets = UIEdgeInsets.zero
}

public extension CDSpinnerView {
    
    public func setImage(_ newImage: UIImage?, forCellAtIndex index: Int, animated: Bool = true) {
        
        guard index < items.count && index >= 0 else { return }
        
        guard let cell = self.tableView.cellForRow(at: IndexPath(row: index, section: 0)) as? CDSpinnerViewCell else { return }
        cell.iconImageView.tintColor = CDSpinnerViewAppearance.tintColor
        
        if animated {
            UIView.transition(with: cell.iconImageView, duration: 0.4, options: .transitionCrossDissolve, animations: {
                cell.iconImageView.image = newImage
                cell.label.text = nil
            }, completion: nil)
            
        } else {
            cell.iconImageView.image = newImage
            cell.label.text = nil
        }
    }
    
    public func setText(newText text: String?, forCellAtIndex index: Int, animated: Bool = true) {
        
        guard index < items.count && index >= 0 else { return }
        
        guard let cell = self.tableView.cellForRow(at: IndexPath(row: index, section: 0)) as? CDSpinnerViewCell else { return }
        
        if animated {
            UIView.transition(with: cell.iconImageView, duration: 0.4, options: .transitionCrossDissolve, animations: {
                cell.label.text = text
                cell.iconImageView.image = nil
            }, completion: nil)
            
        } else {
            cell.label.text = text
            cell.iconImageView.image = nil
        }
    }
}


open class CDSpinnerView: UIView, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var visualEffectView: UIVisualEffectView!
    
    open var items = [CDSpinnerViewItem]()
    open var callback: ((CDSpinnerViewItem) -> Void)?
    open var dismissCallback: ((_ spinnerView: CDSpinnerView) -> Void)?
    
    var isDismissing: Bool = false
    
    var sourceRect: CGRect?
    
    @available(iOS, deprecated: 3.2.0, obsoleted: 3.2.1,  message: "Please use CDSpinnerViewAppearance") open var font: UIFont?
    @available(iOS, deprecated: 3.2.0, obsoleted: 3.2.1,  message: "Please use CDSpinnerViewAppearance") open var textColor = UIColor.black
    @available(iOS, deprecated: 3.2.0, obsoleted: 3.2.1,  message: "Please use CDSpinnerViewAppearance") var cellHeight: CGFloat = 44.0
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        //todo bundle
        let bundle = Bundle(for: CDSpinnerViewCell.classForCoder())
        tableView.register(UINib(nibName: "CDSpinnerViewCell", bundle: bundle), forCellReuseIdentifier: CDSpinnerViewCell.cellReuseIdentifier())
        tableView.separatorStyle = .none
        tableView.separatorColor = UIColor.clear
        tableView.separatorInset = UIEdgeInsets.zero
        autoresizingMask = UIViewAutoresizing.flexibleWidth.union(.flexibleHeight)
    }
    
    open override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        if self.superview == nil {
            CDSpinnerViewAppearance.defaultAppearance()
        } else {
            updateAppearance()
        }
    }
    
    open func updateAppearance() {
        
        if let tintColor = CDSpinnerViewAppearance.tintColor {
            self.tintColor = tintColor
        }
        
        switch CDSpinnerViewAppearance.backgroundStyle {
        case .color(let color):
            self.backgroundColor = color
            self.visualEffectView.isHidden = true
            
        default:
            self.visualEffectView.isHidden = false
            self.backgroundColor = UIColor.clear
        }
        
        self.layer.cornerRadius = CDSpinnerViewAppearance.cornerRadius
        self.layer.borderColor = CDSpinnerViewAppearance.borderColor?.cgColor
        self.layer.borderWidth = CDSpinnerViewAppearance.borderWidth
        self.clipsToBounds = true
        
        if CDSpinnerViewAppearance.dropShadow {
            self.layer.shadowColor = CDSpinnerViewAppearance.shadowColor.cgColor 
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
    
    open override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        
        var hittedView: UIView? = super.hitTest(point, with: event)
        
        guard nil == hittedView else {
            return hittedView
        }
        
        for (_, view) in subviews.reversed().enumerated() {
            if let hit = view.hitTest(point, with: event) {
                hittedView = hit
                break;
            }
        }
        
        if nil == hittedView {
            // tapped outside
            dismiss()
            return self
        }
        
        return super.hitTest(point, with: event)
    }
    
    open func reloadData(_ animated: Bool = true) {
        
        if animated {
            
            tableView.beginUpdates()
            tableView.reloadSections(IndexSet(integer: 0), with: UITableViewRowAnimation.fade)
            tableView.endUpdates()
        } else {
            tableView.reloadData()
        }
    }
    
    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    
    open func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CDSpinnerViewAppearance.cellHeight
    }
    
    open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        UIView.animate(withDuration: CDSpinnerViewAppearance.animationDuration, animations: {
            
            for cell in tableView.visibleCells {
                guard let spinnerCell = cell as? CDSpinnerViewCell else {
                    continue
                }
                
                if spinnerCell.indexPath.row != indexPath.row {
                    spinnerCell.alpha = 0.0
                }
            }
            
        }, completion: { (complete) in
            self.dismiss {
                self.callback?(self.items[indexPath.row])
            }
        }) 
    }
    
    open func dismiss(_ completion: ((Void)->Void)? = nil) {
        if isDismissing {
            return
        }
        isDismissing = true
        
        if let sourceRect = self.sourceRect {
            UIView.animate(withDuration: CDSpinnerViewAppearance.animationDuration, animations: {
                self.frame = sourceRect
                self.alpha = 0
            }, completion: { (complete) in
                completion?()
                self.removeFromSuperview()
            })
        } else {
            UIView.animate(withDuration: CDSpinnerViewAppearance.animationDuration, animations: {
                self.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
            }, completion: { (complete) in
                completion?()
                self.removeFromSuperview()
            })
        }
        
        self.dismissCallback?(self)
    }
    
    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CDSpinnerViewCell.cellReuseIdentifier()) as! CDSpinnerViewCell
        
        let item = items[indexPath.row]
        cell.label.text = item.humanReadableString()
        
        if let image = item.image?() {
            cell.label.isHidden = true
            cell.iconImageView.image = image
            cell.iconImageView.tintColor = CDSpinnerViewAppearance.tintColor
        } else {
            cell.label.isHidden = false
            cell.iconImageView.image = nil
        }
        cell.iconImageView.contentMode = CDSpinnerViewAppearance.imageContentMode
        if let font = CDSpinnerViewAppearance.font {
            cell.label.font = font
        }
        if let selectedItemIndex = CDSpinnerViewAppearance.selectedItemIndex, selectedItemIndex == indexPath.row && CDSpinnerViewAppearance.selectedItemTextColor != nil {
            cell.label.textColor = CDSpinnerViewAppearance.selectedItemTextColor
        } else {
            cell.label.textColor = CDSpinnerViewAppearance.textColor
        }
        cell.indexPath = indexPath
        return cell
    }
    
    open func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let clearView = UIView(frame: CGRect.zero)
        clearView.backgroundColor = UIColor.clear
        cell.selectedBackgroundView = clearView
    }
    
    /// Present without source rect
    open static func present(inViewController viewController: UIViewController, withItems items: [CDSpinnerViewItem], callbackBlock block: @escaping (CDSpinnerViewItem) -> Void, willPresentClosure: ((CDSpinnerView) -> Void)? = nil, completion: ((Void) -> Void)? = nil) -> CDSpinnerView? {
        return CDSpinnerView.present(inViewController: viewController, withItems: items, callbackBlock: block, sourceRect: nil, willPresentClosure: willPresentClosure, completion: completion)
    }
    
    open static func present(inViewController viewController: UIViewController, withItems items: [CDSpinnerViewItem], callbackBlock block: @escaping (CDSpinnerViewItem) -> Void, sourceRect: CGRect?, willPresentClosure: ((CDSpinnerView) -> Void)? = nil, completion: ((Void) -> Void)? = nil) -> CDSpinnerView? {
        let bundle = Bundle(for: CDSpinnerView.classForCoder())
        if let spinnerView: CDSpinnerView = bundle.loadNibNamed("CDSpinnerView", owner: nil, options: nil)!.first as? CDSpinnerView {
            spinnerView.sourceRect = sourceRect
            spinnerView.callback = block
            spinnerView.items = items
            spinnerView.alpha = 0
            viewController.view.addSubview(spinnerView)
            
            willPresentClosure?(spinnerView)
            
            let insets = CDSpinnerViewAppearance.insets
            
            if let sourceRect = sourceRect {
                let h: CGFloat = UIScreen.main.bounds.height - 20.0 // UIApplication.sharedApplication().statusBarFrame.height
                let initalRect = CGRect(x: sourceRect.origin.x, y: sourceRect.origin.y, width: sourceRect.width, height: 0)
                spinnerView.frame = initalRect
                
                var finalRect: CGRect
                if CDSpinnerViewAppearance.boundsBehavior == .shrinkIfNeeded {
                    
                    let maxHeight = h - sourceRect.origin.y - insets.top - insets.bottom
                    let calcHeight = CGFloat(items.count) * CDSpinnerViewAppearance.cellHeight
                    let finalHeight: CGFloat = min(maxHeight, calcHeight)
                    finalRect = CGRect(x: sourceRect.origin.x - insets.left, y: sourceRect.origin.y + insets.top, width: sourceRect.width - insets.right, height: finalHeight)
                    
                } else {
                    let spinnerHeight: CGFloat = CGFloat(items.count) * CDSpinnerViewAppearance.cellHeight
                    finalRect = CGRect(x: sourceRect.origin.x, y: sourceRect.origin.y, width: sourceRect.width, height: spinnerHeight)
                    
                    let overlapping: CGFloat = h - (sourceRect.origin.y + spinnerHeight)
                    if overlapping < 0 {
                        finalRect.origin.y = finalRect.origin.y + overlapping
                    }
                    
                }
                UIView.animate(withDuration: CDSpinnerViewAppearance.animationDuration, animations: {
                    spinnerView.alpha = 1
                    spinnerView.frame = finalRect
                }, completion: { (complete) in
                    completion?()
                })
                
            } else {
                let h = min(UIScreen.main.bounds.height * 0.8, CGFloat(items.count) * CDSpinnerViewAppearance.cellHeight)
                let w = UIScreen.main.bounds.width * 0.8
                let x = UIScreen.main.bounds.width * 0.1
                spinnerView.frame = CGRect(x: x, y: (UIScreen.main.bounds.height - h) / 2, width: w, height: h)
                
                spinnerView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
                UIView.animate(withDuration: CDSpinnerViewAppearance.animationDuration, animations: {
                    spinnerView.alpha = 1
                    spinnerView.transform = CGAffineTransform.identity
                    
                }, completion: { (complete) in
                    completion?()
                })
            }
            
            let time = DispatchTime.now() + Double(Int64(0.075 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
            DispatchQueue.main.asyncAfter(deadline: time, execute: {
                spinnerView.selectIfNeeded(false)
            })
            
            return spinnerView
        }
        
        return nil
    }
    
    func selectIfNeeded(_ animated: Bool = true) {
        if let selectedItemIndex = CDSpinnerViewAppearance.selectedItemIndex, selectedItemIndex < items.count {
            tableView.scrollToRow(at: IndexPath(row: selectedItemIndex, section: 0), at: .top, animated: animated)
        }
    }
    
}
