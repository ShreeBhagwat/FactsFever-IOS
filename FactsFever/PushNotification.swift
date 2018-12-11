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
        print("users to push id ............................\(userPushIds) user push after get members ")
        let currentUser = Auth.auth().currentUser
        OneSignal.postNotification(["contents" : ["en" : " Amazing New Facts uploaded in \(category)"],
                                    "ios_badgeType" : "Increase",
                                    "ios_badgeCount" : "1",
                                    "include_player_ids" : userPushIds])
        print("Push Notificacton sent......................\(userPushIds) users push after notification")
    }
    print("out side loooooooop")
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
    
//    for memberIds in members {
//        let uid = Auth.auth().currentUser?.uid
//        let userDB = Database.database().reference().child("Users")
//        userDB.observe(.childAdded) { (snapshot) in
//            if let dictionary = snapshot.value as? [String: AnyObject] {
//                let user = Users.init(dictionary: dictionary)
//                pushIds.append(user.pushId)
//                print(".............................get push ids\(pushIds)")
//                count += 1
//
//                if members.count == count {
//                    completion(pushIds)
//                }
//            }
//        }
//    }
    let userDB = Database.database().reference().child("Users")
    userDB.observe(.childAdded) { (snapshot) in
        if let dictionary = snapshot.value as? [String: AnyObject] {
            let user = Users.init(dictionary: dictionary)
            if user.pushId != "" {
             pushIds.append(user.pushId)
                 completion(pushIds)
            }
            
           
           
        }
    }
}

