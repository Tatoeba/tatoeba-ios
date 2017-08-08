//
//  UIColor+Extensions.swift
//  Tatoeba
//
//  Created by Jack Cook on 8/6/17.
//  Copyright © 2017 Tatoeba. All rights reserved.
//

import UIKit

// MARK: - Color constants
extension UIColor {
    
    /// Red color used for the "Support Tatoeba" setting.
    static var supportRed: UIColor {
        return UIColor(red: 244/255, green: 67/255, blue: 54/255, alpha: 1)
    }
    
    /// Gray color used for the "Terms of Use" setting.
    static var termsGray: UIColor {
        return UIColor(red: 117/255, green: 117/255, blue: 117/255, alpha: 1)
    }
    
    /// Blue color used for the "Send anonymous usage data" setting.
    static var usageTeal: UIColor {
        return UIColor(red: 0, green: 150/255, blue: 136/255, alpha: 1)
    }
}
