//
//  Users.swift
//  FactsFever
//
//  Created by Shree Bhagwat on 10/12/18.
//  Copyright © 2018 Development. All rights reserved.
//

import Foundation
import Firebase

class Users {
    var UserId:String!
    var pushId:String!
    
    
    init(dictionary: [String: AnyObject]) {
        UserId = dictionary["UserId"] as? String
        pushId = dictionary["pushId"] as? String
    }
    
}
