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

/// Defines the type of response that the request is expecting.
///
/// - image: Image
/// - json: JSON data
enum TatoebaResponseType {
    case image, json
}

/// Protocol that all requests must inherit from.
protocol TatoebaRequest {
    
    /// The type that the response data is expected to conform to.
    associatedtype ResponseData
    
    /// The type that the request will return after it finishes.
    associatedtype Value
    
    /// The endpoint of the request.
    var endpoint: String { get }
    
    /// The URL parameters of the request.
    var parameters: Parameters { get }
    
    /// The type of response that the request is expecting.
    var responseType: TatoebaResponseType { get }
    
    /// Takes the response data and parses it to return the expected request value.
    ///
    /// - Parameters:
    ///   - data: The response data (e.g. UIImage, JSON)
    ///   - completion: The completion block that was passed in the start method
    func handleRequest(_ data: ResponseData?, _ completion: @escaping (Value?) -> Void)
}

extension TatoebaRequest {
    
    /// The base URL of all requests.
    private var baseURL: String {
        return "http://172.20.10.10:5000"
    }
    
    /// Begins to execute the request.
    ///
    /// - Parameter completion: Block that fires when the request finishes with the expected returned data.
    func start(completion: @escaping (Value?) -> Void) {
        switch responseType {
        case .image:
            // Due to local configuration, the port has to be changed for image requests.
            // This won't need to happen in the future.
            
            Alamofire.request("http://172.20.10.10:8080\(endpoint)", parameters: parameters).responseData { response in
                guard let data = response.result.value else {
                    return
                }
                
                let image = UIImage(data: data)
                
                DispatchQueue.main.async {
                    self.handleRequest(image as? ResponseData, completion)
                }
            }
        case .json:
            Alamofire.request("\(baseURL)\(endpoint)", parameters: parameters).responseJSON { response in
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
