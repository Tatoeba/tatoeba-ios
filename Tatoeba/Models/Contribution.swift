//
//  Contribution.swift
//  Tatoeba
//
//  Created by Jack Cook on 8/5/17.
//  Copyright © 2017 Tatoeba. All rights reserved.
//

import SwiftyJSON

struct Contribution {
    
    let id: Int
    let user: User
    let sentenceId: Int
    let sentenceLanguage: String
    let text: String
    let action: String
    let type: String
    let timestamp: Date
    
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
