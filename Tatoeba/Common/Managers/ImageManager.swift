//
//  ImageManager.swift
//  Tatoeba
//
//  Created by Jack Cook on 8/6/17.
//  Copyright © 2017 Tatoeba. All rights reserved.
//

import UIKit

class ImageManager {
    
    /// The default image manager, which is how this class should be accessed.
    static let `default` = ImageManager()
    
    /// Maps endpoints to their images, acts as an image cache.
    private var imageTable: [String: UIImage]
    
    private init() {
        imageTable = [String: UIImage]()
    }
    
    /// Performs an image request, adding functionality such as the image cache.
    ///
    /// - Parameters:
    ///   - request: The request to be performed.
    ///   - cache: Whether or not the retrieved image should be cached. True by default.
    ///   - completion: The completion block containing the image being requested.
    func perform(request: ImageRequest, cache: Bool = true, completion: @escaping (UIImage?) -> Void) {
        // If this image has already been cached, return it immediately
        if let image = imageTable[request.endpoint] {
            completion(image)
            return
        }
        
        request.start { image in
            guard let image = image else {
                completion(nil)
                return
            }
            
            if cache {
                self.imageTable[request.endpoint] = image
            }
            
            completion(image)
        }
    }
}
