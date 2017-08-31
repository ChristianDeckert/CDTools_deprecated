//
//  UIKeyboard+CDTools.swift
//  CDTools
//
//  Created by Deckert on 31.08.17.
//  Copyright © 2017 Christian Deckert. All rights reserved.
//

import Foundation
import UIKit

public func dismissKeyboard() {
    //UIApplication.shared.sendAction(#selector(resignFirstResponder), to: nil, from: nil, for: nil)
    UIApplication.shared.keyWindow?.endEditing(true)
}

