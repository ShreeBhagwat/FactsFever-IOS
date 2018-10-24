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

    let firebaseAuth = Auth.auth()
    let currentUser = Auth.auth().currentUser
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
       
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 3
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

  
    @IBAction func logOutButtonPressed(_ sender: UIButton) {
        if currentUser != nil {
            do {
                try firebaseAuth.signOut()
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
