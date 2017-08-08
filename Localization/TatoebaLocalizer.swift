//
//  TatoebaLocalizer.swift
//  Tatoeba
//
//  Created by Jack Cook on 8/7/17.
//  Copyright © 2017 Tatoeba. All rights reserved.
//

import Foundation

class TatoebaLocalizer {
    
    static func localize(_ symbol: String, parameters: [String: String] = [String: String]()) -> String {
        var string = NSLocalizedString(symbol, comment: "")
        
        for (key, value) in parameters {
            string = string.replacingOccurrences(of: "{\(key)}", with: value)
        }
        
        return string
    }
}
