//
//  SettingCell.swift
//  Tatoeba
//
//  Created by Jack Cook on 8/6/17.
//  Copyright © 2017 Tatoeba. All rights reserved.
//

import UIKit

enum SettingsItemActionType {
    case external, push
    
    var image: UIImage {
        switch self {
        case .external:
            return #imageLiteral(resourceName: "Launch")
        case .push:
            return #imageLiteral(resourceName: "Next")
        }
    }
}

struct SettingsItem {
    let color: UIColor
    let icon: UIImage
    let text: String
    let action: SettingsItemActionType
}

class SettingCell: UITableViewCell {
    
    // MARK: - Constants
    
    static let height: CGFloat = 44
    static let identifier = "SettingCell"
    
    // MARK: - Properties
    
    @IBOutlet weak var iconBackground: UIView!
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var actionImage: UIImageView!
    
    var item: SettingsItem? = nil {
        didSet {
            guard let item = item else {
                return
            }
            
            iconBackground.backgroundColor = item.color
            iconImage.image = item.icon
            nameLabel.text = item.text
            actionImage.image = item.action.image
        }
    }
    
    // MARK: - View Life Cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        iconBackground.layer.cornerRadius = 4
        iconBackground.layer.masksToBounds = true
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        
        iconBackground.backgroundColor = item?.color
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        iconBackground.backgroundColor = item?.color
    }
}
