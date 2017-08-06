//
//  String+Extensions.swift
//  Tatoeba
//
//  Created by Jack Cook on 8/5/17.
//  Copyright © 2017 Tatoeba. All rights reserved.
//

import UIKit

extension String {
    
    func width(forMaxHeight height: CGFloat, withFont font: UIFont) -> CGFloat {
        let size = CGSize(width: .greatestFiniteMagnitude, height: height)
        let attributes = [NSFontAttributeName: font]
        let boundingRect = (self as NSString).boundingRect(with: size, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: attributes, context: nil)
        return ceil(boundingRect.size.width)
    }
    
    func height(forMaxWidth width: CGFloat, withFont font: UIFont) -> CGFloat {
        let size = CGSize(width: width, height: .greatestFiniteMagnitude)
        let attributes = [NSFontAttributeName: font]
        let boundingRect = (self as NSString).boundingRect(with: size, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: attributes, context: nil)
        return ceil(boundingRect.size.height)
    }
}
