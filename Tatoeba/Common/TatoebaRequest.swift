//
//  TatoebaRequest.swift
//  Tatoeba
//
//  Created by Jack Cook on 8/5/17.
//  Copyright © 2017 Tatoeba. All rights reserved.
//

import Alamofire
import SwiftyJSON

protocol TatoebaRequest {
    associatedtype Value
    var endpoint: String { get }
    func handleRequest(_ json: JSON?, _ completion: @escaping (Value?) -> Void)
}

extension TatoebaRequest {
    
    private var baseURL: String {
        return "http://localhost:5000"
    }
    
    func start(completion: @escaping (Value?) -> Void) {
        Alamofire.request("\(baseURL)\(endpoint)").responseJSON { response in
            guard let value = response.result.value else {
                return
            }
            
            let json = JSON(value)
            self.handleRequest(json, completion)
        }
    }
}
