//
//  SentencesRequest.swift
//  Tatoeba
//
//  Created by Jack Cook on 8/6/17.
//  Copyright © 2017 Tatoeba. All rights reserved.
//

import SwiftyJSON

/// Returns sentences using the specified parameters.
final class SentencesRequest: TatoebaRequest {
    
    typealias ResponseData = JSON
    typealias Value = [Sentence]
    
    var endpoint: String {
        return "/sentences?q=\(query)"
    }
    
    var responseType: TatoebaResponseType {
        return .json
    }
    
    let query: String
    
    init(query: String) {
        self.query = query
    }
    
    func handleRequest(_ json: JSON?, _ completion: @escaping ([Sentence]?) -> Void) {
        guard let sentencesData = json?.array else {
            completion(nil)
            return
        }
        
        var sentences = [Sentence]()
        
        for sentenceDatum in sentencesData {
            let sentence = Sentence(json: sentenceDatum)
            sentences.append(sentence)
        }
        
        completion(sentences)
    }
}
