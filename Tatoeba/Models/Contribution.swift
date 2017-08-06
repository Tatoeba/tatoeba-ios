//
//  Contribution.swift
//  Tatoeba
//
//  Created by Jack Cook on 8/5/17.
//  Copyright © 2017 Tatoeba. All rights reserved.
//

import SwiftyJSON

/// An action that takes place on Tatoeba.
struct Contribution {
    
    /// The unique contribution identifier.
    let id: Int
    
    /// The user who made this contribution.
    let user: User
    
    /// The unique identifier of the sentence that this contribution is linked to.
    let sentenceId: Int
    
    /// The language of the sentence linked to this contribution.
    let sentenceLanguage: String
    
    /// The new sentence text.
    let text: String
    
    /// The action that this contribution describes.
    let action: String
    
    /// The type of contribution that this is.
    let type: String
    
    /// The time at thich this contribution took place.
    let timestamp: Date
    
    /// Creates a contribution from JSON data.
    ///
    /// - Parameter json: JSON data
    init(json: JSON) {
        id = json["id"].int ?? 0
        sentenceId = json["sentence_id"].int ?? 0
        sentenceLanguage = json["sentence_lang"].string ?? ""
        text = json["text"].string ?? ""
        action = json["action"].string ?? ""
        type = json["type"].string ?? ""
        
        if let timestampString = json["timestamp"].string {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            timestamp = formatter.date(from: timestampString) ?? Date()
        } else {
            timestamp = Date()
        }
        
        user = User(json: json["user"])
    }
}
