//
//  ContributionsRequest.swift
//  Tatoeba
//
//  Created by Jack Cook on 8/6/17.
//  Copyright © 2017 Tatoeba. All rights reserved.
//

import SwiftyJSON

class ContributionsRequest: TatoebaRequest {
    
    typealias Value = [Contribution]
    
    var endpoint: String {
        return "/contributions"
    }
    
    func handleRequest(_ json: JSON?, _ completion: @escaping ([Contribution]?) -> Void) {
        guard let contributionData = json?.array else {
            return
        }
        
        var contributions = [Contribution]()
        
        for contributionDatum in contributionData {
            let contribution = Contribution(json: contributionDatum)
            contributions.append(contribution)
        }
        
        completion(contributions)
    }
}
