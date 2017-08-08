//
//  ContributionCell.swift
//  Tatoeba
//
//  Created by Jack Cook on 8/5/17.
//  Copyright © 2017 Tatoeba. All rights reserved.
//

import UIKit

class ContributionCell: UITableViewCell {
    
    // MARK: - Constants
    
    static let identifier = "ContributionCell"
    static let horizontalSpacing: CGFloat = 92
    static let verticalSpacing: CGFloat = 77
    
    // MARK: - Properties
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var flagImageView: UIImageView!
    
    var contribution: Contribution? = nil {
        didSet {
            guard let contribution = contribution else {
                return
            }
            
            if contribution.user.imagePath == "unknown-avatar.png" {
                profileImageView.image = #imageLiteral(resourceName: "User")
                profileImageView.tintColor = UIColor(white: 0.2, alpha: 1)
            } else {
                let request = ProfileImageRequest(user: contribution.user)
                
                ImageManager.default.perform(request: request) { [weak self] image in
                    guard let strongSelf = self else {
                        return
                    }
                    
                    strongSelf.profileImageView.image = image
                }
            }
            
            let title: String
            
            if contribution.action == "insert" {
                title = TatoebaLocalizer.localize("Contribution_Added_Sentence", parameters: ["name": contribution.user.username])
            } else if contribution.action == "update" {
                title = TatoebaLocalizer.localize("Contribution_Edited_Sentence", parameters: ["name": contribution.user.username])
            } else {
                title = contribution.user.username
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
            
            dateLabel.text = TatoebaLocalizer.localize("Contribution_Date", parameters: ["date": dateString, "time": timeString])
            contentLabel.text = contribution.text
            
            let flagRequest = FlagImageRequest(language: contribution.sentenceLanguage)
            
            ImageManager.default.perform(request: flagRequest) { [weak self] image in
                guard let strongSelf = self else {
                    return
                }
                
                strongSelf.flagImageView.image = image
            }
        }
    }
    
    // MARK: - View Life Cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        profileImageView.layer.cornerRadius = profileImageView.frame.size.width / 2
        profileImageView.layer.masksToBounds = true
    }
}
