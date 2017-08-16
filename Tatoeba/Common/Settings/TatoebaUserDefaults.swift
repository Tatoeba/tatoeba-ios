//
//  TatoebaUserDefaults.swift
//  Tatoeba
//
//  Created by Jack Cook on 8/11/17.
//  Copyright © 2017 Tatoeba. All rights reserved.
//

import Foundation

class TatoebaUserDefaults: UserDefaults {
    
    static func setDefaultValues() {
        // App settings
        set(true, forKey: .defaultsConfigured)
        set(1, forKey: .appLaunches)
        
        // User settings
        set(true, forKey: .sendAnonymousUsageData)
    }
    
    static func bool(forKey defaultName: TatoebaUserDefaultsKey) -> Bool {
        return standard.bool(forKey: defaultName.rawValue)
    }
    
    static func integer(forKey defaultName: TatoebaUserDefaultsKey) -> Int {
        return standard.integer(forKey: defaultName.rawValue)
    }
    
    static func string(forKey defaultName: TatoebaUserDefaultsKey) -> String? {
        return standard.string(forKey: defaultName.rawValue)
    }
    
    static func removeObject(forKey defaultName: TatoebaUserDefaultsKey) {
        standard.removeObject(forKey: defaultName.rawValue)
    }
    
    static func set(_ value: Bool, forKey defaultName: TatoebaUserDefaultsKey) {
        standard.set(value, forKey: defaultName.rawValue)
    }
    
    static func set(_ value: Int, forKey defaultName: TatoebaUserDefaultsKey) {
        standard.set(value, forKey: defaultName.rawValue)
    }
    
    static func set(_ value: String, forKey defaultName: TatoebaUserDefaultsKey) {
        standard.set(value, forKey: defaultName.rawValue)
    }
}
