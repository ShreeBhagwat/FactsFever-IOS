//
//  AboutTableViewController.swift
//  FactsFever
//
//  Created by Gauri Bhagwat on 12/10/18.
//  Copyright © 2018 Development. All rights reserved.
//

import UIKit

class AboutTableViewController: UITableViewController {
    @IBOutlet weak var yajanImage: UIImageView!
    @IBOutlet weak var parthImage: UIImageView!
    @IBOutlet weak var shreeImage: UIImageView!
    @IBOutlet weak var namrataImage: UIImageView!
    @IBOutlet weak var karamImage: UIImageView!
    @IBOutlet weak var rajatImage: UIImageView!
    
    @IBOutlet weak var textView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        circleProfileView()
        textView.isEditable = false
        textView.dataDetectorTypes = .link
//        textView.backgroundColor = #colorLiteral(red: 0.1242010223, green: 0.1241877451, blue: 0.1290884067, alpha: 1)
        tableView.backgroundColor = UIColor.black

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0 {
            return 1
        }else if section == 1 {
            return 1
        } else {
            return 6
        }
        
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func circleProfileView(){
        rajatImage.clipsToBounds = true
        rajatImage.layer.cornerRadius = (rajatImage.frame.size.width ?? 0.0) / 2
        
        yajanImage.clipsToBounds = true
        yajanImage.layer.cornerRadius = (yajanImage.frame.size.width ?? 0.0) / 2
        
        namrataImage.clipsToBounds = true
        namrataImage.layer.cornerRadius = (namrataImage.frame.size.width ?? 0.0) / 2
        
        karamImage.clipsToBounds = true
        karamImage.layer.cornerRadius = (karamImage.frame.size.width ?? 0.0) / 2
        
        parthImage.clipsToBounds = true
        parthImage.layer.cornerRadius = (parthImage.frame.size.width ?? 0.0) / 2
        
        shreeImage.clipsToBounds = true
        shreeImage.layer.cornerRadius = (shreeImage.frame.size.width ?? 0.0) / 2
    }

}
