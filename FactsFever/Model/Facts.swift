//
//  Facts.swift
//  FactsFever
//
//  Created by Shree Bhagwat on 26/10/18.
//  Copyright © 2018 Development. All rights reserved.
//

import Foundation
import Firebase

class Facts{
    var factsLink: String!
    var factsLikes: Int!
    var factsKey: String!
    
    init(dictionary: [String: AnyObject]) {
        factsLink = dictionary["factsLink"] as? String
        factsLikes = dictionary["factsLike"] as? Int
        factsKey = dictionary["factsKey"] as? String
    }
}
