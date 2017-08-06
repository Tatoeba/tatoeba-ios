//
//  ContributionCell.swift
//  Tatoeba
//
//  Created by Jack Cook on 8/5/17.
//  Copyright © 2017 Tatoeba. All rights reserved.
//

import UIKit

class ContributionCell: UITableViewCell {
    
    static let identifier = "ContributionCell"
    static let horizontalSpacing: CGFloat = 32
    static let verticalSpacing: CGFloat = 96
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    var contribution: Contribution? = nil {
        didSet {
            guard let contribution = contribution else {
                return
            }
            
            ProfileImageRequest(user: contribution.user).start { image in
                self.profileImageView.image = image
            }
            
            let title: String
            
            if contribution.action == "insert" {
                title = "\(contribution.user.username) added a sentence"
            } else if contribution.action == "update" {
                title = "\(contribution.user.username) edited a sentence"
            } else {
                title = "\(contribution.user.username)"
            }
            
            let titleAttributedText = NSMutableAttributedString(string: title)
            titleAttributedText.addAttribute(NSFontAttributeName, value: UIFont.systemFont(ofSize: 18), range: NSRange(location: 0, length: title.characters.count))
            titleAttributedText.addAttribute(NSFontAttributeName, value: UIFont.boldSystemFont(ofSize: 18), range: NSRange(location: 0, length: contribution.user.username.characters.count))
            titleLabel.attributedText = titleAttributedText
            
            let dateTemplate: String
            let timeTemplate: String
            
            if contribution.timestamp.year == Date().year {
                // Weekday, month, day
                dateTemplate = "EEEE MMMM d"
                
                // Hour, minute, am/pm (if applicable)
                timeTemplate = "h mm j"
            } else {
                // Month, day, year
                dateTemplate = "MMMM d yyyy"
                
                // Hour, minute, am/pm (if applicable)
                timeTemplate = "h mm j"
            }
            
            let dateString = contribution.timestamp.string(from: dateTemplate)
            let timeString = contribution.timestamp.string(from: timeTemplate)
            
            dateLabel.text = "\(dateString) at \(timeString)"
            contentLabel.text = contribution.text
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        profileImageView.layer.cornerRadius = 8
        profileImageView.layer.masksToBounds = true
    }
}
