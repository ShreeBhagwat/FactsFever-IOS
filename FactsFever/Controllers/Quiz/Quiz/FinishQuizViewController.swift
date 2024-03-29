//
//  FinishQuizViewController.swift
//  FactsFever
//
//  Created by Shree Bhagwat on 21/02/19.
//  Copyright © 2019 Development. All rights reserved.
//

import UIKit
import SAConfettiView
import ChameleonFramework
import GoogleMobileAds

class FinishQuizViewController: UIViewController {

    @IBOutlet weak var ImageViewOutlet: UIImageView!
    @IBOutlet weak var percentageScoreLable: UILabel!
    @IBOutlet weak var scoreLabelOutlet: UILabel!
    @IBOutlet weak var resultLabelOutlet: UILabel!
    @IBOutlet weak var viewContainerOutlet: UIView!
    var adPlayed = Bool()
    var finalScore = Int()
    var totalQuestion = Int()
    var currentLevelPlayed = Int()
    var levelWon = Bool()
    var percentageScore = Float()
    let userDefaults = UserDefaults.standard
    var higestLevelWon = 0
    var interstitial: GADInterstitial!
    override func viewDidLoad() {
        super.viewDidLoad()
      self.view.addSubview(confettiView)
       print("FinalScore = \(finalScore)")
        print("Total Question = \(totalQuestion)")
        percentageScore = (Float(finalScore)) / (Float(totalQuestion)) * 100
        setupView()
    
        higestLevelWon = userDefaults.integer(forKey: "higestLevelWon")

       
        
        if percentageScore >= 75 {
            levelWon = true
            confettiView.startConfetti()
            resultLabelOutlet.text = "Congratulation"
//            resultLabelOutlet.textColor = UIColor
            ImageViewOutlet.image = #imageLiteral(resourceName: "win")
            scoreLabelOutlet.text = "Score \n\(finalScore)/\(totalQuestion)"
            percentageScoreLable.text = "Percentage Score \n\(percentageScore) %"
            tryAgainButton.isHidden = true
            tryAgainButton.isEnabled = false
            nextLevelButton.isEnabled = true
            nextLevelButton.isHidden = false
//            tryAgainButton.bringSubviewToFront(nextLevelButton)
            nextLevelButton.bringSubviewToFront(tryAgainButton)
            confettiView.bringSubviewToFront(nextLevelButton)
            
        }else{
            levelWon = false
            resultLabelOutlet.text = "Failed"
            resultLabelOutlet.textColor = UIColor.flatRed()
            ImageViewOutlet.image = #imageLiteral(resourceName: "sad1")
            scoreLabelOutlet.text = "Score \n\(finalScore)/\(totalQuestion)"
            percentageScoreLable.text = "Percentage Score \n\(percentageScore) %"
            tryAgainButton.isHidden = false
            tryAgainButton.isEnabled = true
            nextLevelButton.isEnabled = false
            nextLevelButton.isHidden = true
        }
        print("Level result \(levelWon)")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        tabBarController?.tabBar.isHidden = true
        viewContainerOutlet.layer.cornerRadius = 20
        viewContainerOutlet.clipsToBounds = true
        nextLevelButton.layer.cornerRadius = 10
        nextLevelButton.clipsToBounds = true
        tryAgainButton.layer.cornerRadius = 10
        tryAgainButton.clipsToBounds = true
        quizHomeScreen.layer.cornerRadius = 10
        quizHomeScreen.clipsToBounds = true
        
        let save = UserDefaults.standard
        if save.value(forKey: "purchase") == nil {
//            adPlayed = false
            interstitial = GADInterstitial(adUnitID: "ca-app-pub-8893803128543470/2149409947" )
            let request = GADRequest()
            request.testDevices = [kGADSimulatorID]
            interstitial.load(request)
        } else {
        adPlayed = true
        }
        
        FactsFeverCustomLoader.instance.hideLoader()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = false
        tabBarController?.tabBar.isHidden = false
        
    }
    
    lazy var confettiView : SAConfettiView = {
        let view = SAConfettiView(frame: self.view.bounds)
        view.type = .Star
        return view
    }()
    
    var nextLevelButton : UIButton = {
       let button = UIButton()
        button.setTitle("Next Level", for: .normal)
        button.addTarget(self, action: #selector(nextLevelButtonPressed), for: .touchUpInside)
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.flatGreen()

        return button
    }()
    
    lazy var tryAgainButton : UIButton = {
        let button = UIButton()
        button.setTitle("Try Again", for: .normal)
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(tryAgainButtonPressed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.flatRed()
        
        
        return button
    }()
    
    lazy var quizHomeScreen : UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(quizHomeScreenButtonPressed), for: .touchUpInside)
        button.setTitle("Home ", for: .normal)
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.flatBlue()
        return button
    }()
    
    func setupView(){
        confettiView.addSubview(quizHomeScreen)
        confettiView.addSubview(nextLevelButton)
        confettiView.addSubview(tryAgainButton)
        
        let buttonWidth = viewContainerOutlet.frame.width / 2 - 30
        
        quizHomeScreen.leftAnchor.constraint(equalTo: viewContainerOutlet.leftAnchor, constant: 10).isActive = true
        quizHomeScreen.heightAnchor.constraint(equalToConstant: 50).isActive = true
        quizHomeScreen.bottomAnchor.constraint(equalTo: viewContainerOutlet.bottomAnchor, constant: -10).isActive = true
        quizHomeScreen.widthAnchor.constraint(equalToConstant: buttonWidth).isActive = true
        
        nextLevelButton.rightAnchor.constraint(equalTo: viewContainerOutlet.rightAnchor, constant: -10).isActive = true
        nextLevelButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        nextLevelButton.bottomAnchor.constraint(equalTo: viewContainerOutlet.bottomAnchor, constant: -10).isActive = true
        nextLevelButton.widthAnchor.constraint(equalToConstant: buttonWidth).isActive = true
//
        tryAgainButton.rightAnchor.constraint(equalTo: viewContainerOutlet.rightAnchor, constant: -10).isActive = true
        tryAgainButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        tryAgainButton.bottomAnchor.constraint(equalTo: viewContainerOutlet.bottomAnchor, constant: -10).isActive = true
        tryAgainButton.widthAnchor.constraint(equalToConstant: buttonWidth).isActive = true
        
        viewContainerOutlet.layer.cornerRadius = 20
        viewContainerOutlet.clipsToBounds = true
        
        
    }
    
    
    
    func loadInterstitialAdd(){
        if (interstitial.isReady && adPlayed == false){
            print("Presenting add")
            interstitial.present(fromRootViewController: self)
            adPlayed = true
        }
    }
    
    @objc func nextLevelButtonPressed(){
        print("Next ButtonPressed")
        if adPlayed == false && interstitial.isReady {
            interstitial.present(fromRootViewController: self)
            adPlayed = true
        }else {
            let lastLevelWon = currentLevelPlayed + 1
            if currentLevelPlayed == higestLevelWon {
                higestLevelWon += 1
                userDefaults.set(lastLevelWon, forKey: "higestLevelWon")
                userDefaults.synchronize()
            }
            
            let VC = QuizGameViewController()
            VC.selectedGameLevel = lastLevelWon
            navigationController?.pushViewController(VC, animated: true)
        }
    }
    
    @objc func tryAgainButtonPressed(){
        print("try again Button Pressed")
        if adPlayed == false && interstitial.isReady {
            interstitial.present(fromRootViewController: self)
            adPlayed = true
        }else{
            let VC = QuizGameViewController()
            VC.selectedGameLevel = currentLevelPlayed
            navigationController?.pushViewController(VC, animated: true)
        }

    }
    
    @objc func quizHomeScreenButtonPressed(){
        print("Home Screen Button Pressed")
        if adPlayed == false && interstitial.isReady{
            interstitial.present(fromRootViewController: self)
            adPlayed = true
        }else{
            if levelWon {
                won()
            }else{
                navigateToHomeScreen()
            }
        }
    }
    
 
    func won(){
        let lastLevelWon = currentLevelPlayed
        if lastLevelWon == higestLevelWon {
            higestLevelWon += 1
            print(higestLevelWon)
            userDefaults.set(higestLevelWon, forKey: "higestLevelWon")
            userDefaults.synchronize()
            navigateToHomeScreen()
        }else{
            navigateToHomeScreen()
        }
        
    }
    
    func navigateToHomeScreen(){
        if #available(iOS 11.0, *) {
            let FinishQuizViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "quizlevel") as! QuizLevelsCollectionViewController
            self.hidesBottomBarWhenPushed = false
                navigationController?.pushViewController(FinishQuizViewController, animated: true)
        } else {
            // Fallback on earlier versions
        }
        
        
    }

}
