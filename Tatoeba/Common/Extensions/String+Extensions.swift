//
//  String+Extensions.swift
//  Tatoeba
//
//  Created by Jack Cook on 8/5/17.
//  Copyright © 2017 Tatoeba. All rights reserved.
//

import UIKit

// MARK: - String helper methods
extension String {
    
    /// Calculates the minimum width needed to fully display a string without truncation.
    ///
    /// - Parameters:
    ///   - height: The maximum height that the string is allowed to have.
    ///   - font: The font that will be used to display the string.
    /// - Returns: The width that should be given to the string.
    func width(forMaxHeight height: CGFloat, withFont font: UIFont) -> CGFloat {
        let size = CGSize(width: .greatestFiniteMagnitude, height: height)
        let attributes = [NSFontAttributeName: font]
        let boundingRect = (self as NSString).boundingRect(with: size, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: attributes, context: nil)
        return ceil(boundingRect.size.width)
    }
    
    /// Calculates the minimum height needed to fully display a string without truncation.
    ///
    /// - Parameters:
    ///   - width: The maximum width that the string is allowed to have.
    ///   - font: The font that will be used to display the string.
    /// - Returns: The height that should be given to the string.
    func height(forMaxWidth width: CGFloat, withFont font: UIFont) -> CGFloat {
        let size = CGSize(width: width, height: .greatestFiniteMagnitude)
        let attributes = [NSFontAttributeName: font]
        let boundingRect = (self as NSString).boundingRect(with: size, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: attributes, context: nil)
        return ceil(boundingRect.size.height)
    }
}
