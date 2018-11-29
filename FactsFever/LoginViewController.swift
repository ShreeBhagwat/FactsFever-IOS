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
    
    @IBOutlet weak var anonoLoginOutlet: UIButton!
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
        self.view.addSubview(facebookButtonViewOutlet)
        setupfbButton()
    }
    

    lazy var loginView: FBSDKLoginButton = {
        let loginView = FBSDKLoginButton()
        loginView.translatesAutoresizingMaskIntoConstraints = false
        loginView.readPermissions = ["public_profile", "email"]
        loginView.delegate = self
        return loginView
    }()
    
    func setupfbButton(){
        facebookButtonViewOutlet.addSubview(loginView)
        loginView.leftAnchor.constraint(equalTo: facebookButtonViewOutlet.leftAnchor).isActive = true
        loginView.rightAnchor.constraint(equalTo: facebookButtonViewOutlet.rightAnchor).isActive = true
        loginView.topAnchor.constraint(equalTo: facebookButtonViewOutlet.topAnchor).isActive = true
        loginView.bottomAnchor.constraint(equalTo: facebookButtonViewOutlet.bottomAnchor).isActive = true
            }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
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
            print("nil")
            
        }
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        //Todo
        if let error = error {
                    print(error.localizedDescription)
                    return
        } else if result.isCancelled {
            ProgressHUD.showError("Cancled By User, Try Again")
            return
        } else {
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
        facebookButtonViewOutlet.layer.masksToBounds = false
        facebookButtonViewOutlet.layer.shadowRadius = 5
        facebookButtonViewOutlet.layer.shadowColor = UIColor.gray.cgColor
        facebookButtonViewOutlet.layer.shadowOffset = CGSize(width: 2, height: 2)
        facebookButtonViewOutlet.layer.shadowOpacity = 0.8
        
       
        annoButtonOutletView.layer.cornerRadius = 5

        annoButtonOutletView.layer.masksToBounds = false
        annoButtonOutletView.layer.shadowRadius = 2
        annoButtonOutletView.layer.shadowColor = UIColor.gray.cgColor
        annoButtonOutletView.layer.shadowOffset = CGSize(width: 2, height: 2)
        annoButtonOutletView.layer.shadowOpacity = 0.8
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        //User Did Logged out
        
    }
    
    
}
