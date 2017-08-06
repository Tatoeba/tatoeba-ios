//
//  User.swift
//  Tatoeba
//
//  Created by Jack Cook on 8/5/17.
//  Copyright © 2017 Tatoeba. All rights reserved.
//

import SwiftyJSON

struct User {
    
    let id: Int
    let username: String
    let imagePath: String
    
    init(json: JSON) {
        id = json["id"].int ?? 0
        username = json["username"].string ?? ""
        imagePath = json["imagePath"].string ?? "unknown-avatar.png"
    }
}
