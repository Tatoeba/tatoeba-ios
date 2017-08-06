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
            guard let contribution = contribution, let imageURL = URL(string: "http://localhost:8080/img/profiles_128/\(contribution.user.imagePath)") else {
                return
            }
            
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: imageURL) { (data, response, error) in
                guard let data = data, let image = UIImage(data: data) else {
                    return
                }
                
                DispatchQueue.main.async {
                    self.profileImageView.image = image
                }
            }
            
            task.resume()
            
            titleLabel.text = "\(contribution.user.username) added a sentence"
            
            let formatter = DateFormatter()
            
            if Calendar.current.component(.year, from: contribution.timestamp) == Calendar.current.component(.year, from: Date()) {
                formatter.dateFormat = "EEEE, MMM d, 'at' h:mm a"
            } else {
                formatter.dateFormat = "MMM d, yyyy 'at' h:mm a"
            }
            
            dateLabel.text = formatter.string(from: contribution.timestamp)
            
            contentLabel.text = contribution.text
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        profileImageView.layer.cornerRadius = 8
        profileImageView.layer.masksToBounds = true
    }
}
