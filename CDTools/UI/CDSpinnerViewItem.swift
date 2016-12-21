//
//  CDSpinnerViewItem.swift
//  CDTools
//
//  Created by Christian Deckert on 20.12.16.
//  Copyright © 2016 Christian Deckert. All rights reserved.
//

import Foundation
import UIKit

@objc public protocol CDSpinnerViewItem: NSObjectProtocol {
    
    func humanReadableString() -> String
    @objc optional func image() -> UIImage?
    
}
