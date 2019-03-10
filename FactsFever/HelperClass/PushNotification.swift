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

//func sendPushNotification(membersToPush: [String], category: String, pushId:[String]){
//    let updatedMembers = removeCurrentUserFromMemberArray(members: membersToPush)
//
//    getMembersToPush(members: membersToPush, pushId: pushId) { (userPushIds) in
//        print("Members to push\(userPushIds)")
//        let currentUser = Auth.auth().currentUser
//        OneSignal.postNotification(["contents" : ["en" : " Amazing New Facts uploaded in \(category)"],
//                                    "ios_badgeCount" : 1,
//                                    "ios_badgeType" : "Increase",
//                                    "include_player_ids" : userPushIds])
//
//
//    }
//
//}
//
//func removeCurrentUserFromMemberArray(members: [String]) -> [String] {
//
//    var updatedMembers : [String] = []
//    for memberId in members {
//
//        if memberId != Auth.auth().currentUser?.uid {
//            updatedMembers.append(memberId)
//        }else{
//
//        }
//    }
//
//    return updatedMembers
//}
//
//func getMembersToPush(members: [String],pushId:[String], completion: @escaping (_ usersArray: [String]) -> Void){
//    var pushIds : [String] = []
//    var count = 0
//
//
//    let userDB = Database.database().reference().child("Users")
//    userDB.observe(.childAdded) { (snapshot) in
//        if let dictionary = snapshot.value as? [String: AnyObject] {
//            let user = Users.init(dictionary: dictionary)
//
//            if user.pushId != ""{
//                pushIds.append(user.pushId)
//                print("If statement pushIds array \(pushIds)")
//                completion(pushId)
//                }
//
//            }
//
//        }
//
//    }

func sendPushNotification1(pushId:[String], category: String){
    var pushIds : [String] = []
    for push in pushId {
        if push != ""{
            if pushIds.contains(push){
                
            }else{
               pushIds.append(push)
            }

        }
       
    }
    print("<><><><><><><\(pushIds)")
    OneSignal.postNotification(["contents" : ["en" : " Amazing New Facts uploaded in \(category) "],
                                "ios_badgeCount" : 1,
                                "ios_badgeType" : "Increase",
                                "include_player_ids" : pushIds])
}
