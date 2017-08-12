//
//  Language.swift
//  Tatoeba
//
//  Created by Jack Cook on 8/11/17.
//  Copyright © 2017 Tatoeba. All rights reserved.
//

import Foundation

struct Language {
    
    let id: String
    let name: String
    
    init(data: [String: String]) {
        guard let id = data["Identifier"], let name = data["Name"] else {
            fatalError("Error loading languages from plist file")
        }
        
        self.id = id
        self.name = name
    }
    
    static func loadAllLanguages() -> [Language] {
        if let url = Bundle.main.url(forResource: "Languages", withExtension: "plist"), let contents = NSArray(contentsOf: url) as? [[String: String]] {
            var languages = [Language]()
            
            for data in contents {
                let language = Language(data: data)
                languages.append(language)
            }
            
            return languages.sorted(by: { $0.name < $1.name })
        }
        
        return [Language]()
    }
}
