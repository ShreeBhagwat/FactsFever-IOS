//
//  WhyWeDontSellAdsViewController.swift
//  FactsFever
//
//  Created by Shree Bhagwat on 03/12/18.
//  Copyright © 2018 Development. All rights reserved.
//

import UIKit

class WhyWeDontSellAdsViewController: UIViewController {

    @IBOutlet weak var webViewOutlet: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        loadHtmlFile()
        // Do any additional setup after loading the view.
    }
    func loadHtmlFile() {
        let url = Bundle.main.url(forResource: "ads", withExtension:"html")
        let request = NSURLRequest(url: url!)
        webViewOutlet.loadRequest(request as URLRequest)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = false
    }



}
