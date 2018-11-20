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
//
//    let loginView : FBSDKLoginButton = FBSDKLoginButton()
//    self.view.addSubview(loginView)
//    loginView.center = self.view.center
//    loginView.readPermissions = ["public_profile", "email", "user_friends"]
//    loginView.delegate = self
//}
//}
//
//
//
//func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
//
//    if let error = error {
//        print(error.localizedDescription)
//        return
//    }
//    let credentials = FacebookAuthProvider.credential(withAccessToken: (FBSDKAccessToken.current()?.tokenString)!)
//    Auth.auth().signInAndRetrieveData(with: credentials) { (authResult, error) in
//        if  let error = error {
//            ProgressHUD.showError("Error Login Into Firebase try Again")
//            return
//        }
//        ProgressHUD.showSuccess("Successfully Signed In ")
//        let VC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "factsView") as! UITabBarController
//        self.present(VC, animated: true, completion: nil)
//
//    }
//}
//
//func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
//    print("user logged out")
//}


//    var facts: Facts!
//    var currentUser = Auth.auth().currentUser?.uid
//    var overlayView: UIView!
//    var alertView: UIView!
//    var animator: UIDynamicAnimator!
//    var attachmentBehavior : UIAttachmentBehavior!
//    var snapBehavior : UISnapBehavior!
//
//    override func awakeFromNib() {
//        super.awakeFromNib()
//
//        likeButtonOutlet.setImage(UIImage(named: "noLike"), for: .normal)
//        likeButtonOutlet.setImage(UIImage(named: "like"), for: .selected)
//        self.roundCorners(view: imageView, corners: [.topLeft, .topRight], radius: 20)
//
//    }
//    func roundCorners(view :UIView, corners: UIRectCorner, radius: CGFloat){
//        let path = UIBezierPath(roundedRect: view.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
//        let mask = CAShapeLayer()
//        mask.path = path.cgPath
//        view.layer.mask = mask
//    }
//
//
//
//    func configureCell(fact: Facts){
//        self.facts = fact
//        self.allViewOutlet.layer.cornerRadius = 20
//        self.allViewOutlet.layer.shadowColor = UIColor.gray.cgColor
//        self.allViewOutlet.layer.shadowOffset = CGSize(width: 2, height: 2)
//        self.allViewOutlet.layer.shadowOpacity = 1
//        self.allViewOutlet.layer.shadowRadius = 5
//        //        self.imageView.layer.cornerRadius = 20
//        self.imageView.clipsToBounds = true
//        self.imageView.layer.shouldRasterize = true
//        self.imageView.backgroundColor = UIColor.clear
//        self.imageView.layer.masksToBounds = false
//        self.imageView.sd_setImage(with: URL(string: fact.factsLink))
//        //////////////////
//        self.likeLableOutlet.text = String(fact.factsLikes.count)
//        /////////////////
//        self.optionView.layer.cornerRadius = 20
//        //        self.optionView.layer.borderColor = UIColor.black.cgColor
//        //        self.optionView.layer.borderWidth = 1
//        ////////////////
//        self.captionTextViewOutlet.isScrollEnabled = false
//        self.captionTextViewOutlet.sizeToFit()
//        self.captionTextViewOutlet.backgroundColor = UIColor.white
//        self.captionTextViewOutlet.textColor = UIColor.gray
//        //        self.captionTextViewOutlet
//        //        self.captionTextViewOutlet.textColor = UIColor(contrastingBlackOrWhiteColorOn: captionTextViewOutlet.backgroundColor, isFlat: true)
//        self.captionTextViewOutlet.text = fact.captionText
//
//
//        let factsRef = Database.database().reference().child("Facts").child(facts.factsId).child("likes")
//        factsRef.observeSingleEvent(of: .value) { (snapshot) in
//            if fact.factsLikes.contains(self.currentUser!){
//                self.likeButtonOutlet.isSelected = true
//            } else {
//                self.likeButtonOutlet.isSelected = false
//            }
//
//
//        }
//
//    }
//
//
//    @IBAction func likeButtonPressed(_ sender: Any) {
//
//
//        let factsRef = Database.database().reference().child("Facts").child(facts.factsId).child("likes")
//        likeButtonOutlet.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
//
//        UIView.animate(withDuration: 3.0,
//                       delay: 0,
//                       usingSpringWithDamping: CGFloat(0.30),
//                       initialSpringVelocity: CGFloat(5.0),
//                       options: UIView.AnimationOptions.allowUserInteraction,
//                       animations: {
//                        self.likeButtonOutlet.transform = CGAffineTransform.identity
//        },
//                       completion: { Void in()  }
//        )
//
//
//        factsRef.observeSingleEvent(of: .value) { (snapshot) in
//            if self.likeButtonOutlet.isSelected == true {
//                self.likeButtonOutlet.isSelected = false
//                self.facts.addSubtractLike(addLike: false)
//            } else {
//                self.likeButtonOutlet.isSelected = true
//                self.facts.addSubtractLike(addLike: true)
//
//            }
//        }
//    }
//
//
//

}
