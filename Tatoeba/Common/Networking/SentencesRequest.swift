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
        return ["q": query, "offset": offset]
    }
    
    var responseType: TatoebaResponseType {
        return .json
    }
    
    let query: String
    let offset: Int
    
    init(query: String, offset: Int = 0) {
        self.query = query
        self.offset = offset
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
