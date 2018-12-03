//
//  SetttingsTableViewController.swift
//  FactsFever
//
//  Created by Gauri Bhagwat on 10/10/18.
//  Copyright © 2018 Development. All rights reserved.
//

import UIKit
import Firebase
import ProgressHUD
import FBSDKCoreKit
import FBSDKLoginKit


class SetttingsTableViewController: UITableViewController {
    let appline = "https://itunes.apple.com/us/app/pingme/id1438849522?ls=1&mt=8"
    let firebaseAuth = Auth.auth()
    let currentUser = Auth.auth().currentUser
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
       tableView.backgroundColor = UIColor.black
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
   
            return 7
        
        
       
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    @IBAction func shareThisAppButtonPressed(_ sender: Any) {
        let text = "Daily dose of amazing and mind boggling facts. Download this app to to increase your general knowledge \(appline)"
        let objectsToShare: [Any] = [text]
        let activityViewController = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        activityViewController.setValue("Lets Chat On Ping", forKey: "subject")
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    
    
    @IBAction func whyWeDontSellAdsButtonPressed(_ sender: Any) {
        
    }
    
  
    @IBAction func reviewThisAppButtonPressed(_ sender: Any) {
        UIApplication.shared.openURL(URL(string: "https://itunes.apple.com/us/app/pingme/id1438849522?ls=1&mt=8")!)
    }
    
    
    @IBAction func instagramFollowButtonPressed(_ sender: Any) {
        UIApplication.shared.openURL(URL(string: "https://instagram.com/_facts_fever_?utm_source=ig_profile_share&igshid=wtr2hhx82vu2")!)
    }
    
    
    
    @IBAction func logOutButtonPressed(_ sender: UIButton) {
        if currentUser != nil {
            do {
                try firebaseAuth.signOut()
                FBSDKAccessToken.setCurrent(nil)
                print("UserLogged out")
                let loginVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "loginView") as! LoginViewController
                UserDefaults.standard.removeObject(forKey: "user")
                navigationController?.pushViewController(loginVC, animated: true)
              
            }catch {
                ProgressHUD.showError("Error Login Out Try Again Later")
            }
        }
    }
    
    
    
    
    
}
