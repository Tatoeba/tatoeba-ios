//
//  ImageRequest.swift
//  Tatoeba
//
//  Created by Jack Cook on 8/6/17.
//  Copyright © 2017 Tatoeba. All rights reserved.
//

import Alamofire
import UIKit

/// Returns an image from Tatoeba.
class ImageRequest: TatoebaRequest {
    
    typealias ResponseData = UIImage
    typealias Value = UIImage
    
    let endpoint: String
    
    var parameters: Parameters {
        return [String: String]()
    }
    
    var responseType: TatoebaResponseType {
        return .image
    }
    
    init(endpoint: String) {
        self.endpoint = endpoint
    }
    
    func handleRequest(_ image: UIImage?, _ completion: @escaping (UIImage?) -> Void) {
        completion(image)
    }
}
