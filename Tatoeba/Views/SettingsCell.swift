//
//  SettingsCell.swift
//  Tatoeba
//
//  Created by Jack Cook on 8/6/17.
//  Copyright © 2017 Tatoeba. All rights reserved.
//

import UIKit

/// Describes a cell's position relative to its section. Used to set up separators.
///
/// - alone: This is the only cell in its section.
/// - top: This cell is at the top of its section.
/// - middle: This cell is in the middle of its section.
/// - bottom: This cell is at the bottom of its section.
enum SettingsCellPosition {
    case alone
    case top
    case middle
    case bottom
}

class SettingsCell: UITableViewCell {
    
    // MARK: - Constants
    
    static let leftSeparatorInset: CGFloat = 60
    
    // MARK: - Properties
    
    @IBOutlet weak var iconBackground: UIView!
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var actionImage: UIImageView?
    @IBOutlet weak var `switch`: UISwitch?
    
    @IBOutlet weak var topSeparator: UIView!
    @IBOutlet weak var bottomSeparator: UIView!
    @IBOutlet weak var bottomSeparatorLeftConstraint: NSLayoutConstraint!
    
    var model: SettingsCellModel? = nil {
        didSet {
            guard let model = model else {
                return
            }
            
            iconBackground.backgroundColor = model.color
            iconImage.image = model.icon
            nameLabel.text = model.text
            actionImage?.image = model.type.image
        }
    }
    
    var position: SettingsCellPosition = .alone {
        didSet {
            switch position {
            case .alone:
                break
            case .top:
                bottomSeparatorLeftConstraint.constant = SettingsCell.leftSeparatorInset
            case .middle:
                topSeparator.isHidden = true
                bottomSeparatorLeftConstraint.constant = SettingsCell.leftSeparatorInset
            case .bottom:
                topSeparator.isHidden = true
            }
        }
    }
    
    // MARK: - View Life Cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        iconBackground.layer.cornerRadius = 4
        iconBackground.layer.masksToBounds = true
        
        topSeparator.backgroundColor = .separatorGray
        bottomSeparator.backgroundColor = .separatorGray
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        
        iconBackground.backgroundColor = model?.color
        topSeparator.backgroundColor = .separatorGray
        bottomSeparator.backgroundColor = .separatorGray
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        iconBackground.backgroundColor = model?.color
        topSeparator.backgroundColor = .separatorGray
        bottomSeparator.backgroundColor = .separatorGray
    }
}
