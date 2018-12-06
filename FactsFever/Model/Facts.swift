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
    var factsLikes: [String]!
    var factsId: String!
    var timeStamp: NSNumber!
    var captionText: String!
    var imageWidht: NSNumber!
    var imageHeight: NSNumber!
    var categories: String!
    
    init(dictionary: [String: AnyObject]) {
        factsLink = dictionary["factsLink"] as? String
        factsLikes = dictionary["likes"] as? [String]
        factsId = dictionary["factsId"] as? String
        timeStamp = dictionary["timeStamo"] as? NSNumber
        captionText = dictionary["captionText"] as? String
        imageWidht = dictionary["imageWidth"] as? NSNumber
        imageHeight = dictionary["imageHeight"] as? NSNumber
        categories = dictionary["categories"] as? String
    }
    
    func addSubtractLike(addLike: Bool){
        let currentUser = Auth.auth().currentUser?.uid
        if addLike{
            factsLikes.append(currentUser!)
        } else {
            factsLikes.removeAll{$0 == currentUser}
        }
        let factsRef = Database.database().reference().child("Facts").child(factsId).child("likes")

        factsRef.setValue(factsLikes)
        
    }
}
