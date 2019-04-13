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
