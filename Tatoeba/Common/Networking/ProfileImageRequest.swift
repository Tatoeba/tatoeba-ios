//
//  ProfileImageRequest.swift
//  Tatoeba
//
//  Created by Jack Cook on 8/6/17.
//  Copyright © 2017 Tatoeba. All rights reserved.
//

/// Returns a profile image from Tatoeba.
final class ProfileImageRequest: ImageRequest {
    
    /// Creates a request that should retrieve a profile image by filename.
    ///
    /// - Parameter path: The name of the file on the Tatoeba server.
    init(path: String) {
        super.init(endpoint: "/img/profiles_128/\(path)")
    }
    
    /// Creates a request that should retrieve a profile image by user.
    ///
    /// - Parameter user: The user that the profile image being requested belongs to.
    convenience init(user: User) {
        self.init(path: user.imagePath)
    }
}
