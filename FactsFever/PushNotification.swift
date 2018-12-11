//
//  PushNotification.swift
//  FactsFever
//
//  Created by Shree Bhagwat on 10/12/18.
//  Copyright © 2018 Development. All rights reserved.
//

import Foundation
import OneSignal
import Firebase
import UserNotifications


func sendPushNotification(membersToPush: [String], category: String){
     print("Push Notificacton sent")
    let updatedMembers = removeCurrentUserFromMemberArray(members: membersToPush)
    getMembersToPush(members: membersToPush) { (userPushIds) in
        
        let currentUser = Auth.auth().currentUser
        OneSignal.postNotification(["contents" : ["en" : " Amazing New Facts uploaded in \(category)"],
                                    "ios_badgeType" : "Increase",
                                    "ios_badgeCount" : 1,
                                    "include_player_ids" : userPushIds])
       
    }
   
}

func removeCurrentUserFromMemberArray(members: [String]) -> [String] {
    
    var updatedMembers : [String] = []
    for memberId in members {
        if memberId != Auth.auth().currentUser?.uid {
            updatedMembers.append(memberId)
        }
    }
    
    return updatedMembers
}

func getMembersToPush(members: [String], completion: @escaping (_ usersArray: [String]) -> Void){
    var pushIds : [String] = []
    var count = 0
    
    let userDB = Database.database().reference().child("Users")
    userDB.observe(.childAdded) { (snapshot) in
        if let dictionary = snapshot.value as? [String: AnyObject] {
            let user = Users.init(dictionary: dictionary)
            if user.pushId != "" {
             pushIds.append(user.pushId)
                 count += 1
                if members.count == count {
                    completion(pushIds)
                }
                completion(pushIds)
            }
            
           
           
        }
    }
}

