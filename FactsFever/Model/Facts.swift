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
    var factsId: String!
    
    init(dictionary: [String: AnyObject]) {
        factsLink = dictionary["factsLink"] as? String
        factsLikes = dictionary["likes"] as? Int
        factsId = dictionary["factsId"] as? String
    }
    
    func addSubtractLike(addLike: Bool){
        if addLike{
            factsLikes = factsLikes + 1
        } else {
            factsLikes =  factsLikes - 1
        }
        let factsRef = Database.database().reference().child("Facts").child(factsId).child("likes")

        factsRef.setValue(factsLikes)
        
    }
}
