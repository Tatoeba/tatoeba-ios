//
//  SentenceCell.swift
//  Tatoeba
//
//  Created by Jack Cook on 8/6/17.
//  Copyright © 2017 Tatoeba. All rights reserved.
//

import UIKit

class SentenceCell: UITableViewCell {
    
    // MARK: - Constants
    
    static let identifier = "SentenceCell"
    static let horizontalSpacing: CGFloat = 74
    static let verticalSpacing: CGFloat = 24
    
    // MARK: - Variables
    
    @IBOutlet weak var flagImageView: UIImageView!
    @IBOutlet weak var contentLabel: UILabel!
    
    var sentence: Sentence? = nil {
        didSet {
            guard let sentence = sentence else {
                return
            }
            
            let request = FlagImageRequest(language: sentence.language)
            
            ImageManager.default.perform(request: request) { image in
                self.flagImageView.image = image
            }
            
            contentLabel.text = sentence.text
        }
    }
}
