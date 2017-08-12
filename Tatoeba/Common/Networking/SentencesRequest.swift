//
//  SentencesRequest.swift
//  Tatoeba
//
//  Created by Jack Cook on 8/6/17.
//  Copyright © 2017 Tatoeba. All rights reserved.
//

import Alamofire
import SwiftyJSON

/// Returns sentences using the specified parameters.
final class SentencesRequest: TatoebaRequest {
    
    typealias ResponseData = JSON
    typealias Value = [Sentence]
    
    var endpoint: String {
        return "/sentences"
    }
    
    var parameters: Parameters {
        var params: Parameters = ["q": query, "offset": offset]
        
        if let fromLanguage = fromLanguage {
            params["from"] = fromLanguage
        }
        
        return params
    }
    
    var responseType: TatoebaResponseType {
        return .json
    }
    
    let query: String
    let offset: Int
    let fromLanguage: String?
    
    init(query: String, offset: Int = 0, fromLanguage: String? = nil) {
        self.query = query
        self.offset = offset
        self.fromLanguage = fromLanguage
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
