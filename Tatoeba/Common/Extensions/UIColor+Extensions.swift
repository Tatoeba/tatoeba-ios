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
    
    /// Gray color used for cell separators in settings.
    static var separatorGray: UIColor {
        return UIColor(red: 227/255, green: 227/255, blue: 227/255, alpha: 1)
    }
    
    /// Red color used for the "Support Tatoeba" setting.
    static var supportRed: UIColor {
        return UIColor(red: 244/255, green: 67/255, blue: 54/255, alpha: 1)
    }
    
    /// Gray color used for the "Terms of Use" setting.
    static var termsGray: UIColor {
        return UIColor(red: 117/255, green: 117/255, blue: 117/255, alpha: 1)
    }
    
    /// Teal color used for the "Send anonymous usage data" setting.
    static var usageTeal: UIColor {
        return UIColor(red: 0, green: 150/255, blue: 136/255, alpha: 1)
    }
    
    /// Yellow color used for the "Rate Tatoeba" setting.
    static var rateYellow: UIColor {
        return UIColor(red: 241/255, green: 196/255, blue: 15/255, alpha: 1)
    }
    
    /// Green color used for the "Send feedback" setting.
    static var feedbackGreen: UIColor {
        return UIColor(red: 67/255, green: 160/255, blue: 71/255, alpha: 1)
    }
    
    /// Blue color used for the "Licenses" setting.
    static var openSourceBlue: UIColor {
        return UIColor(red: 3/255, green: 155/255, blue: 229/255, alpha: 1)
    }
}
