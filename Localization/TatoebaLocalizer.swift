//
//  TatoebaLocalizer.swift
//  Tatoeba
//
//  Created by Jack Cook on 8/7/17.
//  Copyright © 2017 Tatoeba. All rights reserved.
//

import Foundation

class TatoebaLocalizer {
    
    static func localize(_ symbol: String) -> String {
        return NSLocalizedString(symbol, comment: "")
    }
}
