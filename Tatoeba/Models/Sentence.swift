//
//  Sentence.swift
//  Tatoeba
//
//  Created by Jack Cook on 8/6/17.
//  Copyright © 2017 Tatoeba. All rights reserved.
//

import SwiftyJSON

/// A sentence on Tatoeba.
struct Sentence {
    
    /// The unique sentence identifier.
    let id: Int
    
    /// The actual sentence text.
    let text: String
    
    /// The sentence's language, if identified.
    let language: Language
    
    /// The unique identifier of the user who submitted this sentence.
    let userId: Int
    
    /// Sentences which are the translation of this one.
    let translations: [Sentence]?
    
    /// Creates a sentence from JSON data.
    ///
    /// - Parameter json: JSON data
    init(json: JSON) {
        id = json["id"].int ?? 0
        text = json["text"].string ?? ""
        language = json["lang"].string ?? ""
        userId = json["user_id"].int ?? 0
        
        if let translationsData = json["translations"].array {
            var translations = [Sentence]()
            
            for translation in translationsData {
                let sentence = Sentence(json: translation)
                translations.append(sentence)
            }
            
            self.translations = translations
        } else {
            self.translations = nil
        }
    }
    
    /// Creates a sentence from a contribution, if applicable.
    /// Will return nil if the contribution is not describing a sentence.
    ///
    /// - Parameter contribution: Contribution
    init?(contribution: Contribution) {
        guard contribution.type == "sentence" else {
            return nil
        }
        
        id = contribution.sentenceId
        text = contribution.text
        language = contribution.sentenceLanguage
        userId = contribution.user.id
        translations = nil
    }
}
