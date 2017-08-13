//
//  Library.swift
//  Tatoeba
//
//  Created by Jack Cook on 8/12/17.
//  Copyright © 2017 Tatoeba. All rights reserved.
//

import Foundation

struct Library {
    
    let name: String
    let license: String
    
    init(data: [String: String]) {
        guard let name = data["Name"], let license = data["License"] else {
            fatalError("Error loading libraries from plist file")
        }
        
        self.name = name
        self.license = license.replacingOccurrences(of: "\\n", with: "\n")
    }
    
    static func loadAllLibraries() -> [Library] {
        if let url = Bundle.main.url(forResource: "Libraries", withExtension: "plist"), let contents = NSArray(contentsOf: url) as? [[String: String]] {
            var libraries = [Library]()
            
            for data in contents {
                let library = Library(data: data)
                libraries.append(library)
            }
            
            return libraries.sorted(by: { $0.name < $1.name })
        }
        
        return [Library]()
    }
}
