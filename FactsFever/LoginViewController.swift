//
//  LoginViewController.swift
//  FactsFever
//
//  Created by Gauri Bhagwat on 10/10/18.
//  Copyright © 2018 Development. All rights reserved.
//

import UIKit
import Firebase
import FBSDKCoreKit
import FBSDKLoginKit
import FirebaseAuth
import ProgressHUD

class LoginViewController: UIViewController, FBSDKLoginButtonDelegate {

    


    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (FBSDKAccessToken.current() != nil)
        {
            // User is already logged in, do work such as go to next view controller.
            let VC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "factsView") as! UITabBarController
            present(VC, animated: true, completion: nil)
      
        }
        else
        {
            let loginView : FBSDKLoginButton = FBSDKLoginButton()
            self.view.addSubview(loginView)
            loginView.center = self.view.center
            loginView.readPermissions = ["public_profile", "email", "user_friends"]
            loginView.delegate = self
        }
    }
    
    
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        
        if let error = error {
            print(error.localizedDescription)
            return
        }
        let credentials = FacebookAuthProvider.credential(withAccessToken: (FBSDKAccessToken.current()?.tokenString)!)
        Auth.auth().signInAndRetrieveData(with: credentials) { (authResult, error) in
            if  let error = error {
                ProgressHUD.showError("Error Login Into Firebase try Again")
                return
            }
            ProgressHUD.showSuccess("Successfully Signed In ")
            let VC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "factsView") as! UITabBarController
            self.present(VC, animated: true, completion: nil)
            
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("user logged out")
    }


}
