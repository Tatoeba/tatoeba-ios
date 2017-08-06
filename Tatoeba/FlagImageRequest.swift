//
//  FlagImageRequest.swift
//  Tatoeba
//
//  Created by Jack Cook on 8/6/17.
//  Copyright © 2017 Tatoeba. All rights reserved.
//

typealias Language = String

/// Returns a flag image from Tatoeba.
final class FlagImageRequest: ImageRequest {
    
    /// Creates a request that should retrieve a flag image by language.
    ///
    /// - Parameter language: The language of the flag being retrieved.
    init(language: Language) {
        super.init(endpoint: "/img/flags/\(language).png")
    }
}
