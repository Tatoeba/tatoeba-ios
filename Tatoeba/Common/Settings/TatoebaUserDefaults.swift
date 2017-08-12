//
//  TatoebaUserDefaults.swift
//  Tatoeba
//
//  Created by Jack Cook on 8/11/17.
//  Copyright © 2017 Tatoeba. All rights reserved.
//

import Foundation

class TatoebaUserDefaults: UserDefaults {
    
    static public func setDefaultValues() {
        set(true, forKey: .defaultsConfigured)
    }
    
    static func removeObject(forKey defaultName: TatoebaUserDefaultsKey) {
        standard.removeObject(forKey: defaultName.rawValue)
    }
    
    static func set(_ value: Bool, forKey defaultName: TatoebaUserDefaultsKey) {
        standard.set(value, forKey: defaultName.rawValue)
    }
    
    static func set(_ value: String, forKey defaultName: TatoebaUserDefaultsKey) {
        standard.set(value, forKey: defaultName.rawValue)
    }
}
