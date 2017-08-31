//
//  UICollectionView+CDTools.swift
//  SOS
//
//  Created by Christian Deckert on 25.11.16.
//  Copyright © 2017 Christian Deckert
//

import Foundation
import UIKit
import CDTools

public extension UINib {
    
    public static func nibForCDCollectionViewCell(_ cell: CDCollectionViewCell.Type, bundle: Bundle? = nil) -> UINib {
        return UINib(nibName: cell.cellReuseIdentifier, bundle: bundle)
    }
    
}

public extension UICollectionView {
    
    public func register(cdCollectionViewCell cell: CDCollectionViewCell.Type, bundle: Bundle? = nil) {
        self.register(UINib.nibForCDCollectionViewCell(cell, bundle: bundle ?? Bundle(for: cell.classForCoder())), forCellWithReuseIdentifier: cell.cellReuseIdentifier)
    }
    
    public func registerCDCollectionSupplementaryView(_ viewType: UICollectionReusableView.Type, forSupplementaryViewOfKind kind: String, bundle: Bundle? = nil) {
        self.register(viewType, forSupplementaryViewOfKind: kind, withReuseIdentifier: viewType.reuseIdentifier())
    }
    
}


public extension UICollectionReusableView {
    
    public class func reuseIdentifier() -> String {
        return String(NSStringFromClass(self.classForCoder()).components(separatedBy: ".")[1])
    }
    
}
