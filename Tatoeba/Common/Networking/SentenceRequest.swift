//
//  SentenceRequest.swift
//  Tatoeba
//
//  Created by Jack Cook on 8/12/17.
//  Copyright © 2017 Tatoeba. All rights reserved.
//

import Alamofire
import SwiftyJSON

/// Returns a sentence using the specified parameters.
final class SentenceRequest: TatoebaRequest {
    
    typealias ResponseData = JSON
    typealias Value = Sentence
    
    var endpoint: String {
        return "/sentences"
    }
    
    var parameters: Parameters {
        return ["id": id]
    }
    
    var responseType: TatoebaResponseType {
        return .json
    }
    
    let id: Int
    
    init(id: Int) {
        self.id = id
    }
    
    func handleRequest(_ json: JSON?, _ completion: @escaping (Sentence?) -> Void) {
        guard let json = json else {
            completion(nil)
            return
        }
        
        completion(Sentence(json: json))
    }
}
