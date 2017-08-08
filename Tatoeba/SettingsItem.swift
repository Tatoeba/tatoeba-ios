//
//  SettingsItem.swift
//  Tatoeba
//
//  Created by Jack Cook on 8/7/17.
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

enum SettingsItem {
    case cell(SettingsCellModel)
    case header(String)
    case footer(String)
}

struct SettingsCellModel {
    
    let color: UIColor
    let icon: UIImage
    let text: String
    let action: SettingsItemActionType
    
    static let sendAnonymousUsageData = SettingsCellModel(color: .usageTeal, icon: #imageLiteral(resourceName: "Graph"), text: "Send usage data", action: .external)
    
    static let supportTatoeba = SettingsCellModel(color: .supportRed, icon: #imageLiteral(resourceName: "Heart"), text: TatoebaLocalizer.localize("Settings_Support_Tatoeba"), action: .external)
    
    static let termsOfUse = SettingsCellModel(color: .termsGray, icon: #imageLiteral(resourceName: "Text"), text: "Terms of Use", action: .external)
}
