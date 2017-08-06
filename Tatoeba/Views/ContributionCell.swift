//
//  ContributionCell.swift
//  Tatoeba
//
//  Created by Jack Cook on 8/5/17.
//  Copyright © 2017 Tatoeba. All rights reserved.
//

import UIKit

class ContributionCell: UITableViewCell {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    var contribution: Contribution? = nil {
        didSet {
            guard let contribution = contribution else {
                return
            }
            
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: contribution.profileImageURL) { (data, response, error) in
                guard let data = data, let image = UIImage(data: data) else {
                    return
                }
                
                DispatchQueue.main.async {
                    self.profileImageView.image = image
                }
            }
            
            task.resume()
            
            titleLabel.text = contribution.title
            dateLabel.text = contribution.date.description
            contentLabel.text = contribution.content
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        profileImageView.layer.cornerRadius = 8
        profileImageView.layer.masksToBounds = true
    }
}
