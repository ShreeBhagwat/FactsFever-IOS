//
//  SettingsViewController.swift
//  FactsFever
//
//  Created by Shree Bhagwat on 24/02/19.
//  Copyright © 2019 Development. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    
    @IBOutlet weak var tableViewControllerContainerOutlet: UIView!
    @IBOutlet weak var SettingImageViewController: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.tintColor = #colorLiteral(red: 1, green: 0.8258904602, blue: 0.08854053572, alpha: 1)

        tableViewControllerContainerOutlet.layer.cornerRadius = 20
        tableViewControllerContainerOutlet.clipsToBounds = true
      
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
