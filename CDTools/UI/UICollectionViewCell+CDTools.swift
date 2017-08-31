//
//  UICollectionViewCell+CDTools.swift
//  CDTools
//
//  Created by Christian Deckert on 25.11.16.
//  Copyright © 2017 Christian Deckert
//
import Foundation
import UIKit

public extension UICollectionViewCell {
    
    open class var cellReuseIdentifier: String {
        let id = String(NSStringFromClass(self.classForCoder()).components(separatedBy: ".")[1])
        return id!
    }
    
}


open class CDCollectionViewCell: UICollectionViewCell {
    open var viewModel: CDViewModelBase? {
        didSet {
            viewModelUpdated()
        }
    }
    
    fileprivate var _indexPath: IndexPath = IndexPath()
    open var indexPath: IndexPath {
        set {
            _indexPath = IndexPath(item: newValue.item, section: newValue.section)
        }
        
        get {
            return _indexPath
        }
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.indexPath = IndexPath(item: 0, section: 0)
        commonInit()
    }
    
    open func commonInit() {
        
    }
    
    open func viewModelUpdated() {
        self.transform = CGAffineTransform.identity
    }
    
}
