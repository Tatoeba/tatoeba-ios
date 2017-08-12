//
//  SettingsItem.swift
//  Tatoeba
//
//  Created by Jack Cook on 8/7/17.
//  Copyright © 2017 Tatoeba. All rights reserved.
//

import UIKit

enum SettingsCellItemType: Equatable {
    case external, push, `switch`(TatoebaUserDefaultsKey), text(String)
    
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
    
    static func ==(lhs: SettingsCellItemType, rhs: SettingsCellItemType) -> Bool {
        switch (lhs, rhs) {
        case (.external, .external):
            return true
        case (.push, .push):
            return true
        case (.switch(let key1), .switch(let key2)):
            return key1 == key2
        case (.text(let str1), .text(let str2)):
            return str1 == str2
        default:
            return false
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
        case .text(_):
            return "SettingsTextCell"
        }
    }
    
    static let sendAnonymousUsageData = SettingsCellModel(color: .usageTeal, icon: #imageLiteral(resourceName: "Graph"), text: TatoebaLocalizer.localize("Settings_Usage_Data"), type: .switch(.sendAnonymousUsageData))
    
    static let supportTatoeba = SettingsCellModel(color: .supportRed, icon: #imageLiteral(resourceName: "Heart"), text: TatoebaLocalizer.localize("Settings_Support_Tatoeba"), type: .external)
    
    static let termsOfUse = SettingsCellModel(color: .termsGray, icon: #imageLiteral(resourceName: "Text"), text: TatoebaLocalizer.localize("Settings_Terms"), type: .external)
    
    static let thirdPartyNotices = SettingsCellModel(color: .openSourceBlue, icon: #imageLiteral(resourceName: "Modules"), text: TatoebaLocalizer.localize("Settings_Open_Source"), type: .push)
    
    static let version = SettingsCellModel(color: .white, icon: #imageLiteral(resourceName: "Tatoeba"), text: TatoebaLocalizer.localize("Settings_Version"), type: .text("1.0"))
    
    static func ==(lhs: SettingsCellModel, rhs: SettingsCellModel) -> Bool {
        return lhs.color == rhs.color && lhs.icon == rhs.icon && lhs.text == rhs.text && lhs.type == rhs.type
    }
}
