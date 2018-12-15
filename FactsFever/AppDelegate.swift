//
//  AppDelegate.swift
//  FactsFever
//
//  Created by Gauri Bhagwat on 09/10/18.
//  Copyright © 2018 Development. All rights reserved.
//

import UIKit
import Firebase
import FBSDKCoreKit
import OneSignal
import PushKit
import GoogleSignIn
import ProgressHUD

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, PKPushRegistryDelegate{
//    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
//
//    }
//
    func pushRegistry(_ registry: PKPushRegistry, didUpdate pushCredentials: PKPushCredentials, for type: PKPushType) {

    }
    

    var window: UIWindow?
    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
//        GIDSignIn.sharedInstance()?.clientID = "381776864970-lcii1cqlamngbhc34a1n4rli2sivb1f3.apps.googleusercontent.com"
        GIDSignIn.sharedInstance()?.clientID = FirebaseApp.app()?.options.clientID
//        GIDSignIn.sharedInstance()?.delegate = self
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)


        func userDidLogin(userId: String){
            self.startOneSignal()
        }
    
        NotificationCenter.default.addObserver(forName: Notification.Name("UserDidLoginNotification"), object: nil, queue: nil) { (note) in
            let userId = note.userInfo!["userId"] as? String
            UserDefaults.standard.set(userId, forKey: "userId")
            UserDefaults.standard.synchronize()
            userDidLogin(userId: userId!)
        }
    
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().requestAuthorization(options: [.badge, .alert, .sound], completionHandler: { (granted, error) in
            })
            
               application.registerForRemoteNotifications()
            
            
        } else {
            let types: UIUserNotificationType = [.alert, .badge, .sound]
            let settings = UIUserNotificationSettings(types: types, categories: nil)
            application.registerUserNotificationSettings(settings)
            
        }
        
        let oneSignalInitSettings = [kOSSettingsKeyAutoPrompt: false]
        OneSignal.initWithLaunchOptions(launchOptions,
                                        appId: "c9b03431-8ca8-470c-ac7f-2b9c387e6d15",
                                        handleNotificationAction: nil,
                                        settings: oneSignalInitSettings)
        OneSignal.inFocusDisplayType = OSNotificationDisplayType.notification;

        
        OneSignal.promptForPushNotifications(userResponse: { accepted in
            print("User accepted notifications: \(accepted)")
        })
        
//        UIApplication.shared.applicationIconBadgeNumber = 0
        return true
    }
    // FaceBook login
//    func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
//
//        let handled: Bool = FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplication.OpenURLOptionsKey.annotation])
//        // Add any custom logic here.
//        return handled
//    }
    
    // Google Sign In Login.
    func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any])
        -> Bool {
            return GIDSignIn.sharedInstance().handle(url,
                                                     sourceApplication:options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
                                                     annotation: [:])
    }
    

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
      
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
     
        
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        
        FBSDKAppEvents.activateApp()
    }

    func applicationWillTerminate(_ application: UIApplication) {
       
    }
    


    // MARK: OneSignal
    
    func startOneSignal(){
        let status: OSPermissionSubscriptionState = OneSignal.getPermissionSubscriptionState()
        let userID = status.subscriptionStatus.userId
        let pushToken = status.subscriptionStatus.pushToken

        if pushToken != nil {
            if let playerID = userID {
                UserDefaults.standard.set(playerID, forKey: "pushID")
            } else {
                UserDefaults.standard.removeObject(forKey: "pushID")
            }
            UserDefaults.standard.synchronize()
        }
         //Update OneSignal ID
        updateOneSignalId()
    }

    func updateOneSignalId(){
        if Auth.auth().currentUser != nil {
            if let pushId = UserDefaults.standard.string(forKey: "pushID") {
                setOneSignalId(pushId: pushId)
            } else {
                removeOneSignalId()
            }
//
        }

    }

    func setOneSignalId(pushId: String){
        updateCurrentUserOneSignalId(newId: pushId)
//        print(".................................... \(pushId)")
    }

    func removeOneSignalId(){
        updateCurrentUserOneSignalId(newId: "")
    }

    func updateCurrentUserOneSignalId(newId: String){
        let uid = Auth.auth().currentUser?.uid
        let userDB = Database.database().reference().child("Users").child(uid!)
        userDB.updateChildValues(["pushId": newId])
        
        
    }
    
    func GoToApp(){
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UserDidLoginNotification"), object: nil, userInfo: ["userId": Auth.auth().currentUser?.uid])
    }
    
}

