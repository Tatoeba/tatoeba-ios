//
//  TatoebaRequest.swift
//  Tatoeba
//
//  Created by Jack Cook on 8/5/17.
//  Copyright © 2017 Tatoeba. All rights reserved.
//

import Alamofire
import SwiftyJSON

class TatoebaRequest {
    
    private let baseURL = "http://localhost:5000"
    
    private let endpoint: String
    
    init(endpoint: String) {
        self.endpoint = endpoint
    }
    
    func start(completion: ((JSON?) -> Void)?) {
        Alamofire.request("\(baseURL)\(endpoint)").responseJSON { response in
            guard let value = response.result.value else {
                completion?(nil)
                return
            }
            
            let json = JSON(value)
            completion?(json)
        }
    }
}
