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
  
    
    
    

//    var user = UserDefaults.standard.object(forKey: "user")
    @IBOutlet weak var anonoLoginOutlet: UIButton!
   
    @IBOutlet weak var facebookLoginButton: UIButton!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
//        tableView.delegate = self as! UITableViewDelegate
        self.navigationItem.hidesBackButton = true
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.01084895124, green: 0.06884861029, blue: 0.1449754088, alpha: 1)
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 1, green: 0.8508075984, blue: 0.02254329405, alpha: 1)]
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 1, green: 0.8508075984, blue: 0.02254329405, alpha: 1)]
        
        var user = UserDefaults.standard.object(forKey: "user")
        facebookLoginButton.addTarget(self, action: #selector(facebookLoginButtonPressed), for: .touchUpInside)
        
        
        
        if (FBSDKAccessToken.current() != nil || user != nil)
        {
            // User is already logged in, do work such as go to next view controller.
            let VC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "factsView") as! UITabBarController
            present(VC, animated: true, completion: nil)
      
        }
        else
        {
//            facebookLoginButton.readPermissions = ["public_profile", "email", "user_friends"]
//            facebookLoginButton.delegate = self
        }
    }
    
    
    @objc func facebookLoginButtonPressed(){
        print("Faceboook Button Pressed")
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
    
    //Mark: TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        return cell
    }
    

    
    
}
