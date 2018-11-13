//
//  LaunchViewController.swift
//  FactsFever
//
//  Created by Shree Bhagwat on 13/11/18.
//  Copyright © 2018 Development. All rights reserved.
//

import UIKit
import Firebase
import FBSDKCoreKit
import FBSDKLoginKit
import FirebaseAuth
import ProgressHUD

class LaunchViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
         var user = UserDefaults.standard.object(forKey: "user")
        if (FBSDKAccessToken.current() != nil || user != nil)
        {
            print("not nil")
            // User is already logged in, do work such as go to next view controller.
            let VC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "factsView") as! UITabBarController
            present(VC, animated: true, completion: nil)
            
        }
        else
        {
            let VC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "loginView") as! UIViewController
            present(VC, animated: true, completion: nil)
            print("nil")
            
        }
    }
        // Do any additional setup after loading the view.
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
