//
//  UIStoryboard+Extensions.swift
//  Tatoeba
//
//  Created by Jack Cook on 8/12/17.
//  Copyright © 2017 Tatoeba. All rights reserved.
//

import UIKit

enum TatoebaStoryboardIdentifier: String {
    case sentenceController = "SentenceViewController"
}

extension UIStoryboard {
    
    static var main: UIStoryboard {
        return UIStoryboard(name: "Main", bundle: Bundle.main)
    }
    
    func instantiateViewController(withIdentifier identifier: TatoebaStoryboardIdentifier) -> UIViewController {
        return instantiateViewController(withIdentifier: identifier.rawValue)
    }
}
