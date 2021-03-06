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
    @IBOutlet weak var actionImageRightConstraint: NSLayoutConstraint?
    @IBOutlet weak var `switch`: UISwitch?
    @IBOutlet weak var detailLabel: UILabel?
    
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
            
            switch model.color {
            case UIColor.white:
                iconBackground.layer.borderColor = UIColor.separatorGray.cgColor
                iconBackground.layer.borderWidth = 1
            default:
                break
            }
            
            accessibilityTraits = UIAccessibilityTraitButton
            
            switch model.type {
            case .external:
                break
            case .push:
                actionImageRightConstraint?.constant = 14
            case .switch(let setting):
                let setting = TatoebaUserDefaults.bool(forKey: setting)
                
                accessibilityValue = TatoebaLocalizer.localize(setting ? "Generic_On" : "Generic_Off")
                selectionStyle = .none
                
                self.switch?.isAccessibilityElement = false
                self.switch?.isOn = setting
            case .text(let text):
                accessibilityTraits = UIAccessibilityTraitStaticText
                detailLabel?.text = text
            }
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
    
    // MARK: - Public Methods
    
    func toggleSwitch() {
        guard let switchView = self.switch else {
            return
        }
        
        switchView.setOn(!switchView.isOn, animated: true)
        updateSetting()
    }
    
    // MARK: - Private Methods
    
    private func updateSetting() {
        guard let switchView = self.switch, let type = model?.type else {
            return
        }
        
        switch type {
        case .switch(let setting):
            accessibilityValue = TatoebaLocalizer.localize(switchView.isOn ? "Generic_On" : "Generic_Off")
            
            TatoebaUserDefaults.set(switchView.isOn, forKey: setting)
        default:
            break
        }
    }
    
    // MARK: - IBActions
    
    @IBAction func switchToggled(_ sender: Any) {
        updateSetting()
    }
}
