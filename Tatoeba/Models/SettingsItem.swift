//
//  SettingsItem.swift
//  Tatoeba
//
//  Created by Jack Cook on 8/7/17.
//  Copyright © 2017 Tatoeba. All rights reserved.
//

import UIKit

enum SettingsCellItemType {
    case external, push, `switch`
    
    var image: UIImage? {
        switch self {
        case .external:
            return #imageLiteral(resourceName: "Launch")
        case .push:
            return #imageLiteral(resourceName: "Next")
        default:
            return nil
        }
    }
}

enum SettingsItem {
    case cell(SettingsCellModel)
    case header(String)
    case footer(String)
}

struct SettingsCellModel: Equatable {
    
    let color: UIColor
    let icon: UIImage
    let text: String
    let type: SettingsCellItemType
    
    var identifier: String {
        switch type {
        case .external, .push:
            return "SettingsCell"
        case .switch:
            return "SettingsSwitchCell"
        }
    }
    
    static let sendAnonymousUsageData = SettingsCellModel(color: .usageTeal, icon: #imageLiteral(resourceName: "Graph"), text: TatoebaLocalizer.localize("Settings_Usage_Data"), type: .switch)
    
    static let supportTatoeba = SettingsCellModel(color: .supportRed, icon: #imageLiteral(resourceName: "Heart"), text: TatoebaLocalizer.localize("Settings_Support_Tatoeba"), type: .external)
    
    static let termsOfUse = SettingsCellModel(color: .termsGray, icon: #imageLiteral(resourceName: "Text"), text: TatoebaLocalizer.localize("Settings_Terms"), type: .external)
    
    static func ==(lhs: SettingsCellModel, rhs: SettingsCellModel) -> Bool {
        return lhs.color == rhs.color && lhs.icon == rhs.icon && lhs.text == rhs.text && lhs.type == rhs.type
    }
}