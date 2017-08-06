//
//  TatoebaRequest.swift
//  Tatoeba
//
//  Created by Jack Cook on 8/5/17.
//  Copyright © 2017 Tatoeba. All rights reserved.
//

import Alamofire
import SwiftyJSON
import UIKit

enum TatoebaResponseType {
    case image, json
}

protocol TatoebaRequest {
    associatedtype ResponseData
    associatedtype Value
    var endpoint: String { get }
    var responseType: TatoebaResponseType { get }
    func handleRequest(_ data: ResponseData?, _ completion: @escaping (Value?) -> Void)
}

extension TatoebaRequest {
    
    private var baseURL: String {
        return "http://localhost:5000"
    }
    
    func start(completion: @escaping (Value?) -> Void) {
        switch self.responseType {
        case .image:
            // Due to local configuration, the port has to be changed for image requests.
            // This won't need to happen in the future.
            
            Alamofire.request("http://localhost:8080\(endpoint)").responseData { response in
                guard let data = response.result.value else {
                    return
                }
                
                let image = UIImage(data: data)
                
                DispatchQueue.main.async {
                    self.handleRequest(image as? ResponseData, completion)
                }
            }
        case .json:
            Alamofire.request("\(baseURL)\(endpoint)").responseJSON { response in
                guard let data = response.result.value else {
                    return
                }
                
                let json = JSON(data)
                
                DispatchQueue.main.async {
                    self.handleRequest(json as? ResponseData, completion)
                }
            }
        }
    }
}
