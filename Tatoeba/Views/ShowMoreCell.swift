//
//  ShowMoreCell.swift
//  Tatoeba
//
//  Created by Jack Cook on 8/6/17.
//  Copyright © 2017 Tatoeba. All rights reserved.
//

import UIKit

class ShowMoreCell: UITableViewCell {
    
    // MARK: - Constants
    
    static let height: CGFloat = 44
    static let identifier = "ShowMoreCell"
    
    // MARK: - Variables
    
    @IBOutlet weak var titleLabel: UILabel!
    
    // MARK: - View Life Cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        titleLabel.text = TatoebaLocalizer.localize("Search_Show_More")
    }
}
