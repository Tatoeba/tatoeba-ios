//
//  User.swift
//  Tatoeba
//
//  Created by Jack Cook on 8/5/17.
//  Copyright © 2017 Tatoeba. All rights reserved.
//

import SwiftyJSON

/// A user on Tatoeba.
struct User {
    
    /// The unique user identifier.
    let id: Int
    
    /// The user's username.
    let username: String
    
    /// The path of their profile image file on Tatoeba.
    let imagePath: String
    
    /// Creates a user from JSON data.
    ///
    /// - Parameter json: JSON data
    init(json: JSON) {
        id = json["id"].int ?? 0
        username = json["username"].string ?? ""
        imagePath = json["imagePath"].string ?? "unknown-avatar.png"
    }
}
