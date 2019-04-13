//
//  AboutDeveloperViewController.swift
//  FactsFever
//
//  Created by Gauri Bhagwat on 12/10/18.
//  Copyright © 2018 Development. All rights reserved.
//

import UIKit

class AboutDeveloperViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.layer.cornerRadius = imageView.frame.width * 0.5
        imageView.layer.borderWidth = 5.0
        imageView.layer.borderColor = #colorLiteral(red: 0.01084895124, green: 0.06884861029, blue: 0.1449754088, alpha: 1)
        imageView.clipsToBounds = true
        navigationController?.navigationBar.tintColor = #colorLiteral(red: 1, green: 0.8274509804, blue: 0.09019607843, alpha: 1)

    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = false
    }

}
