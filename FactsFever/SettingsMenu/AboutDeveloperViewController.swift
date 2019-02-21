//
//  AboutDeveloperViewController.swift
//  FactsFever
//
//  Created by Gauri Bhagwat on 12/10/18.
//  Copyright © 2018 Development. All rights reserved.
//

import UIKit

class AboutDeveloperViewController: UIViewController {

    @IBOutlet weak var developerImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
//        developerImage.clipsToBounds = true
        developerImage.layer.masksToBounds = false
        developerImage.layer.cornerRadius = 20
        developerImage.layer.shadowColor = UIColor.white.cgColor
        developerImage.layer.shadowOffset = CGSize(width: 2, height: 2)
        developerImage.layer.shadowOpacity = 1
        developerImage.layer.shadowRadius = 5
        view.backgroundColor = UIColor.black
    }
    

}
