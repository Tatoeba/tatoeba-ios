//
//  LoadingCell.swift
//  Tatoeba
//
//  Created by Jack Cook on 8/10/17.
//  Copyright © 2017 Tatoeba. All rights reserved.
//

import UIKit

class LoadingCell: UITableViewCell {
    
    // MARK: - Constants
    
    static let height: CGFloat = 52
    static let identifier = "LoadingCell"
    
    // MARK: - Variables
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - View Life Cycle
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        activityIndicator.startAnimating()
    }
}
