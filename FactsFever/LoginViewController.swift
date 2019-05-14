//
//  LoginViewController.swift
//  FactsFever
//
//  Created by Gauri Bhagwat on 10/10/18.
//  Copyright © 2018 Development. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import ProgressHUD
import GoogleSignIn


class LoginViewController: UIViewController, GIDSignInUIDelegate, GIDSignInDelegate{

    @IBOutlet weak var anonoLoginOutlet: UIButton!
    @IBOutlet weak var facebookButtonViewOutlet: UIView!
    @IBOutlet weak var annoButtonOutletView: UIView!
    var userArray : [Users] = [Users]()
//    var currentUser = Auth.auth().currentUser
    var handler: AuthStateDidChangeListenerHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        tableView.delegate = self as! UITableViewDelegate
        GIDSignIn.sharedInstance().delegate = self
//        GIDSignIn.sharedInstance().uiDelegate = self
//        GIDSignInDelegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
//        GIDSignIn.sharedInstance()?.signIn()

         setupLoginButton()
        self.navigationItem.hidesBackButton = true
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.01084895124, green: 0.06884861029, blue: 0.1449754088, alpha: 1)
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 1, green: 0.8508075984, blue: 0.02254329405, alpha: 1)]
        } else {
            // Fallback on earlier versions
        }
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 1, green: 0.8508075984, blue: 0.02254329405, alpha: 1)]
        self.view.addSubview(facebookButtonViewOutlet)
        setupfbButton()
    }
    


    
    lazy var GoogleSinginButton: GIDSignInButton = {
        let button = GIDSignInButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    func setupfbButton(){

        
        facebookButtonViewOutlet.addSubview(GoogleSinginButton)
        GoogleSinginButton.leftAnchor.constraint(equalTo: facebookButtonViewOutlet.leftAnchor).isActive = true
        GoogleSinginButton.rightAnchor.constraint(equalTo: facebookButtonViewOutlet.rightAnchor).isActive = true
        GoogleSinginButton.topAnchor.constraint(equalTo: facebookButtonViewOutlet.topAnchor).isActive = true
        GoogleSinginButton.bottomAnchor.constraint(equalTo: facebookButtonViewOutlet.bottomAnchor).isActive = true
            }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        
        handler = Auth.auth().addStateDidChangeListener({ (auth, user) in
            self.checkLoggedInUser()
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        guard let handler = handler else {return}
        Auth.auth().removeStateDidChangeListener(handler)
        
    }
    
    func checkLoggedInUser(){
        DispatchQueue.main.async {
            if Auth.auth().currentUser == nil {
                
            } else {
                let uid = Auth.auth().currentUser?.uid
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UserDidLoginNotification"), object: nil, userInfo: ["userId": uid])
                let VC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "factsView") as! UITabBarController
                self.navigationController?.pushViewController(VC, animated: false)
//
                return
            }
        }
        
     
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        ProgressHUD.show()
        if let error = error {
            ProgressHUD.showError("Error Signin in")
        }
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
        Auth.auth().signInAndRetrieveData(with: credential) { (authResult, error) in
            ProgressHUD.show()
            if error != nil {
                ProgressHUD.showError("Google Singin Error Try again !")
            }
            let userId = authResult?.user.uid
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UserDidLoginNotification"), object: nil, userInfo: ["userId": userId])
            self.registerUserIntoDatabaseWithUidAndPushId(uid: userId!, pushId: "")
            ProgressHUD.showSuccess("User Signed In sucessfully")
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
            self.registerUserIntoDatabaseWithUidAndPushId(uid: uid!, pushId: "")
             NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UserDidLoginNotification"), object: nil, userInfo: ["userId": uid])
            return
        }
    }
    
    private func registerUserIntoDatabaseWithUidAndPushId(uid: String, pushId: String){
        let userDb = Database.database().reference().child("Users").child(uid)
        let userDictionary = ["UserId": uid,"pushId": pushId] as [String: AnyObject]
        
        userDb.updateChildValues(userDictionary) { (err, userDB) in
            if err != nil {
                print(err as Any)
                return
            }
            let users = Users(dictionary: userDictionary)
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
    
}
