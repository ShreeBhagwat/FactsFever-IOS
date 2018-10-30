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
        developerImage.clipsToBounds = true
        developerImage.layer.cornerRadius = 120
    }
    

}
