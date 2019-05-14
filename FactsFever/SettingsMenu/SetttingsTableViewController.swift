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



class SetttingsTableViewController: UITableViewController {
    let appline = "https://itunes.apple.com/us/app/pingme/id1438849522?ls=1&mt=8"
    let firebaseAuth = Auth.auth()
    let currentUser = Auth.auth().currentUser
    
    
    @IBOutlet weak var versionLableView: UILabel!
    @IBOutlet weak var removeAdLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.tintColor = #colorLiteral(red: 1, green: 0.8258904602, blue: 0.08854053572, alpha: 1)

        tableView.tableFooterView = UIView()
//       tableView.backgroundColor = UIColor.black
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            versionLableView.text = "Version Number  \(version)"
        }
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
        if indexPath.row == 0 {
            print(indexPath.row)
            let storybord = UIStoryboard(name: "Main", bundle: nil)
            let VC = storybord.instantiateViewController(withIdentifier: "AboutFactsFever")
            navigationController?.pushViewController(VC, animated: true)
        }else if indexPath.row == 1 {
            let storybord = UIStoryboard(name: "Main", bundle: nil)
            let VC = storybord.instantiateViewController(withIdentifier: "AboutDeveloper")
            navigationController?.pushViewController(VC, animated: true)
        }else if indexPath.row == 2 {
            shareThisApp()
        }else if indexPath.row == 3 {
            let storybord = UIStoryboard(name: "Main", bundle: nil)
            let VC = storybord.instantiateViewController(withIdentifier: "removeAds")
            navigationController?.pushViewController(VC, animated: true)
        }else if indexPath.row == 4 {
            rateTheAppOnAppStore()
        }else if indexPath.row == 5 {
            followUsOnInstagram()
        }else {
            
        }
    }
    
    

    func shareThisApp(){
        let text = "Daily dose of amazing and mind boggling facts. Download this app to to increase your general knowledge \(appline)"
        let objectsToShare: [Any] = [text]
        let activityViewController = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        activityViewController.setValue("Lets Chat On Ping", forKey: "subject")
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    
    func rateTheAppOnAppStore(){
        UIApplication.shared.openURL(URL(string: "https://itunes.apple.com/us/app/pingme/id1438849522?ls=1&mt=8")!)

    }
    
    func followUsOnInstagram(){
         UIApplication.shared.openURL(URL(string: "https://instagram.com/_facts_fever_?utm_source=ig_profile_share&igshid=wtr2hhx82vu2")!)
    }
    
    func logOut(){
        print("Logout Button pressed")
        if currentUser != nil {
            do {
                //                try firebaseAuth.signOut()
                try Auth.auth().signOut()
                //                FBSDKAccessToken.setCurrent(nil)
                print("UserLogged out")
                let loginVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WelcomeViewController") as! WelcomeViewController
                UserDefaults.standard.removeObject(forKey: "user")
                present(loginVC, animated: true, completion: nil)
                
            }catch {
                ProgressHUD.showError("Error Login Out Try Again Later")
            }
        }
    }
    

    
    
    
    
    
}
