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
   
    
    @IBOutlet weak var bottomBoundryView: UIView!
    @IBOutlet weak var welcomeTextView: UITextView!
    @IBOutlet weak var squareView: UIView!
    @IBOutlet weak var facebookLoginButton: UIButton!
    var attachmentBehavior : UIAttachmentBehavior!
    var dynamicAnimator : UIDynamicAnimator!
    var gravityBehavior : UIGravityBehavior!
    var collisionBehavior : UICollisionBehavior!
    var bouncingBehavior  : UIDynamicItemBehavior!
    

    override func viewDidLoad() {
        super.viewDidLoad()
//        tableView.delegate = self as! UITableViewDelegate
        welcomeTextView.backgroundColor = #colorLiteral(red: 0.01084895124, green: 0.06884861029, blue: 0.1449754088, alpha: 1)
        self.navigationItem.hidesBackButton = true
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.01084895124, green: 0.06884861029, blue: 0.1449754088, alpha: 1)
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 1, green: 0.8508075984, blue: 0.02254329405, alpha: 1)]
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 1, green: 0.8508075984, blue: 0.02254329405, alpha: 1)]
        
        var user = UserDefaults.standard.object(forKey: "user")
        facebookLoginButton.addTarget(self, action: #selector(facebookLoginButtonPressed), for: .touchUpInside)
        self.view.backgroundColor = #colorLiteral(red: 0.01084895124, green: 0.06884861029, blue: 0.1449754088, alpha: 1)
        
        dynamicAnimator = UIDynamicAnimator(referenceView: self.view)
        gravityBehavior = UIGravityBehavior(items: [squareView])
        gravityBehavior.gravityDirection = CGVector(dx: 0, dy: 1)
        
        let point = CGPoint(x: (self.view.frame.width)/2, y: 0)
        attachmentBehavior = UIAttachmentBehavior(item: squareView, attachedToAnchor: point)
        attachmentBehavior.length = 300
        attachmentBehavior.damping = 0.5
        
        dynamicAnimator.addBehavior(gravityBehavior)
        dynamicAnimator.addBehavior(attachmentBehavior)

        if (FBSDKAccessToken.current() != nil || user != nil)
        {
            // User is already logged in, do work such as go to next view controller.
            let VC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "factsView") as! UITabBarController
            present(VC, animated: true, completion: nil)
      
        }
        else
        {

        }
    }
    
    
    @objc func facebookLoginButtonPressed(){
        FBSDKLoginManager().logIn(withReadPermissions: ["public_profile", "email"], from: self) { (result, error) in
            if error != nil {
                ProgressHUD.showError("Failed to login from Facebook, Try again after some time.\(error)")
                return
            }
            print(result?.token.tokenString)
            self.showEmailAddress()
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
