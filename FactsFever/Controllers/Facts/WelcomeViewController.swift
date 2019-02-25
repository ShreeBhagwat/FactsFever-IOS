//
//  WelcomeViewController.swift
//  FactsFever
//
//  Created by Shree Bhagwat on 25/02/19.
//  Copyright © 2019 Development. All rights reserved.
//

import UIKit
import liquid_swipe
import FirebaseAuth
import Firebase

class ColoredController: UIViewController {
    var viewColor: UIColor = .white {
        didSet {
            viewIfLoaded?.backgroundColor = viewColor
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = viewColor
    }
}

class WelcomeViewController: LiquidSwipeContainerController, LiquidSwipeContainerDataSource {
     var handler: AuthStateDidChangeListenerHandle?
    var viewController: [UIViewController] = {
        let firstPageVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "page1")
        let secondPageVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "page2")
        let thirdPageVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "page3")
        let loginViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "loginView")
        var controllers: [UIViewController] = [firstPageVC, secondPageVC,thirdPageVC,loginViewController]
        return controllers
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        datasource = self
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        handler = Auth.auth().addStateDidChangeListener({ (auth, user) in
            self.checkLoggedInUser()
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        guard let handler = handler else {return}
        Auth.auth().removeStateDidChangeListener(handler)
        
    }
    
    func checkLoggedInUser(){
        DispatchQueue.main.async {
            if Auth.auth().currentUser == nil {
                
            } else {
                let uid = Auth.auth().currentUser?.uid
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UserDidLoginNotification"), object: nil, userInfo: ["userId": uid])
                let VC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "factsView") as! UITabBarController
                self.present(VC, animated: true, completion: nil)
                return
            }
        }
        
        
    }
    
    func numberOfControllersInLiquidSwipeContainer(_ liquidSwipeContainer: LiquidSwipeContainerController) -> Int {
       return viewController.count
    }
    
    func liquidSwipeContainer(_ liquidSwipeContainer: LiquidSwipeContainerController, viewControllerAtIndex index: Int) -> UIViewController {
        return viewController[index]
    }
    

 
    



}
