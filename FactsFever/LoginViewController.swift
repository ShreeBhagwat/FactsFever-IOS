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

class LoginViewController: UIViewController, FBSDKLoginButtonDelegate{
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        //Todo
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        //TODO
    }
    
  
    @IBOutlet weak var anonoLoginOutlet: UIButton!
    @IBOutlet weak var facebookLoginButton: UIButton!

    @IBOutlet weak var facebookButtonViewOutlet: UIView!
    
    @IBOutlet weak var annoButtonOutletView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        tableView.delegate = self as! UITableViewDelegate
         setupLoginButton()
        self.navigationItem.hidesBackButton = true
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.01084895124, green: 0.06884861029, blue: 0.1449754088, alpha: 1)
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 1, green: 0.8508075984, blue: 0.02254329405, alpha: 1)]
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 1, green: 0.8508075984, blue: 0.02254329405, alpha: 1)]
        
        
        facebookLoginButton.addTarget(self, action: #selector(facebookLoginButtonPressed), for: .touchUpInside)
        print("Facebook access Token\(FBSDKAccessToken.current())")
//        print("User \(user)")
        

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        var user = UserDefaults.standard.object(forKey: "user")
        if (FBSDKAccessToken.current() != nil || user != nil)
        {
            print("not nil")
            // User is already logged in, do work such as go to next view controller.
            let VC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "mainView") as! UIViewController
            present(VC, animated: true, completion: nil)
            
        }
        else
        {
            print("nil")
            
        }
    }
    
    
    @objc func facebookLoginButtonPressed(){
        FBSDKLoginManager().logIn(withReadPermissions: ["public_profile", "email"], from: self) { (result, error) in
            if error != nil {
                ProgressHUD.showError("Failed to login from Facebook, Try again after some time.\(error)")
                return
            } else if (result?.isCancelled)! {
                
            }else {
                print(result?.token.tokenString)
                self.showEmailAddress()
            }
        }
    }
    
    
    func showEmailAddress(){
       let accessToken = FBSDKAccessToken.current()
        guard let accessTokenString = accessToken?.tokenString else {return}
        let credentials = FacebookAuthProvider.credential(withAccessToken: accessTokenString)
        Auth.auth().signIn(with: credentials) { (user, error) in
            if error != nil {
                ProgressHUD.showError("Error In FaceBook Credentials, Please Try Again")
                return
            }
            ProgressHUD.showSuccess("User Logged In successfully. \(user)")
            let VC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "factsView") as! UITabBarController
            self.present(VC, animated: true, completion: nil)
        }
        
        FBSDKGraphRequest(graphPath: "/me", parameters: ["fields":"id, name, email"])?.start(completionHandler: { (connection, result, err) in
            if err != nil {
                ProgressHUD.showError("Error Getting Facebook Credentials, Try again later \(err)")
                return
            }
            print(result)
        })
    }
    

    


    @IBAction func anonoLoginButtonPressed(_ sender: Any) {
        ProgressHUD.show()
        Auth.auth().signInAnonymously { (user, error) in
            if error != nil {
                print(error)
                ProgressHUD.dismiss()
                ProgressHUD.showError("Error Login Try Again")
                return
            }
            let user = user?.user
            let uid = user?.uid
            print("UserLogged in Anaonymously with uid " )
            let storeToDefaults = UserDefaults.standard.set(uid, forKey: "user")
            ProgressHUD.dismiss()
            let VC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "factsView") as! UITabBarController
            self.present(VC, animated: true, completion: nil)
        }
    }
    
    func setupLoginButton(){
        facebookButtonViewOutlet.layer.cornerRadius = 5
//        facebookButtonViewOutlet.layer.borderWidth = 1
//        facebookButtonViewOutlet.layer.borderColor = UIColor.gray.cgColor
        facebookButtonViewOutlet.layer.masksToBounds = false
        facebookButtonViewOutlet.layer.shadowRadius = 5
        facebookButtonViewOutlet.layer.shadowColor = UIColor.gray.cgColor
        facebookButtonViewOutlet.layer.shadowOffset = CGSize(width: 2, height: 2)
        facebookButtonViewOutlet.layer.shadowOpacity = 0.8
        
       
        annoButtonOutletView.layer.cornerRadius = 5
//        annoButtonOutletView.layer.borderWidth = 1
//        annoButtonOutletView.layer.borderColor = UIColor.gray.cgColor
        annoButtonOutletView.layer.masksToBounds = false
        annoButtonOutletView.layer.shadowRadius = 2
        annoButtonOutletView.layer.shadowColor = UIColor.gray.cgColor
        annoButtonOutletView.layer.shadowOffset = CGSize(width: 2, height: 2)
        annoButtonOutletView.layer.shadowOpacity = 0.8
    }
    

    
    
}
