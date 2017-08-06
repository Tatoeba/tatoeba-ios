//
//  ProfileImageRequest.swift
//  Tatoeba
//
//  Created by Jack Cook on 8/6/17.
//  Copyright © 2017 Tatoeba. All rights reserved.
//

final class ProfileImageRequest: ImageRequest {
    
    init(path: String) {
        super.init(endpoint: "/img/profiles_128/\(path)")
    }
    
    convenience init(user: User) {
        self.init(path: user.imagePath)
    }
}
