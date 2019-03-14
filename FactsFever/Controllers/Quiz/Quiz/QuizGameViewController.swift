//
//  QuizGameViewController.swift
//  FactsFever
//
//  Created by Shree Bhagwat on 19/02/19.
//  Copyright © 2019 Development. All rights reserved.
//

import UIKit
import ChameleonFramework
import PCLBlurEffectAlert

struct Question {
    var Question: String!
    var Answers: [String]!
    var Answer : Int!
}

class QuizGameViewController: UIViewController {

    var selectedGameLevel = Int()
    var buttonArray = [UIButton]()
    var Questions = [Question]()
    var Qnumber = Int()
    var AnswerNumber = Int()
    var score = Int()
    var levelQuestionNumber = Int()
    var totalQuestion = Int()
    let shapeLayer = CAShapeLayer()
    var pulsatingLayer : CAShapeLayer!
    let pulsuatingAnimation = CABasicAnimation(keyPath: "transform.scale")
    let circularAnimation = CABasicAnimation(keyPath: "strokeEnd")
    var seconds = 20
    var timer = Timer()
    var isTimeRunning : Bool!
    var timerpaused = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("QuizGameViewController ......\(selectedGameLevel)")
        self.view.backgroundColor = .clear
        let imageView =  UIImageView(frame: UIScreen.main.bounds)
        imageView.image = UIImage(named: "FinishQuiz")
        imageView.contentMode = UIView.ContentMode.scaleAspectFill
        self.view.insertSubview(imageView, at: 0)
        quizLevelLable.text = "Level\n\(selectedGameLevel)"
        buttonArray = [button1, button2, button3, button4]
        setupView()
        score = 0
        levelQuestionNumber = 1
        quizQuestLable.text = ""
        nextButton.isHidden = true
        picQuestionSet(leveNumber: selectedGameLevel)
        pickQuestion()
        quizScoreLable.text = "Score\n\(score)/\(totalQuestion)"
        drawCircularTimerPath()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        animateCircularStroke()
        animatepulsatingLayer()
//        runTimer()
    }
    
    
    func drawCircularTimerPath(){
        // Creating circle Timer
        
        let XValue = self.view.frame.width / 2
        let center = CGPoint(x: XValue, y: 100)
        // Creating a Circular track Path
        let path = UIBezierPath(arcCenter: .zero, radius: 50, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
        
        // Pulsating Layer
        pulsatingLayer = CAShapeLayer()
        pulsatingLayer.path = path.cgPath
        
        pulsatingLayer.strokeColor = UIColor(hexString: "#d80f19", withAlpha: 0.6)?.cgColor
        pulsatingLayer.lineWidth = 7
        pulsatingLayer.lineCap = .round
        pulsatingLayer.fillColor = UIColor.clear.cgColor
        pulsatingLayer.position = CGPoint(x: XValue, y: 100)
        view.layer.addSublayer(pulsatingLayer)

        let trackLayer = CAShapeLayer()
        trackLayer.path = path.cgPath
        trackLayer.strokeColor = UIColor(hexString: "#7c080e", withAlpha: 0.5)?.cgColor
        trackLayer.lineWidth = 5
        trackLayer.lineCap = .round
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.position = CGPoint(x: XValue, y: 100)
        view.layer.addSublayer(trackLayer)

        // Creating circular motion
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = UIColor(hexString: "#ff020f", withAlpha: 1)?.cgColor
        shapeLayer.lineWidth = 5
        shapeLayer.strokeEnd = 0
        shapeLayer.lineCap = .round
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.position = CGPoint(x: XValue, y: 100)
        shapeLayer.transform = CATransform3DMakeRotation(-CGFloat.pi / 2, 0, 0, 1)
        
        view.layer.addSublayer(shapeLayer)
       
    }
    
    func animatepulsatingLayer(){
        
        pulsuatingAnimation.toValue = 1.2
        pulsuatingAnimation.duration = 0.5
        pulsuatingAnimation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        pulsuatingAnimation.autoreverses = true
        pulsuatingAnimation.repeatCount = 20.0
        pulsatingLayer.add(pulsuatingAnimation, forKey: "pulsatingAnimation")
    }
    
    func animateCircularStroke(){
        
        circularAnimation.toValue = 1
        circularAnimation.duration = 20
        circularAnimation.fillMode = .forwards
        circularAnimation.isRemovedOnCompletion = true
        shapeLayer.add(circularAnimation, forKey: "basicAnimation")
    }
    

    func runTimer() {
            isTimeRunning = true
            timerpaused = false
              timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: #selector(updateTimer) , userInfo: nil, repeats: true)
      
      
    }
    
    @objc func updateTimer(){
        if seconds != 0 {
            seconds -= 1
            timerCountDownLabel.text = "\(seconds)"
        }else{
            isTimeRunning = false
            timerpaused = true
            timer.invalidate()
            disableButtonClick()
            nextButton.isEnabled = true
            nextButton.isHidden = false
            timer.invalidate()
        }
        
       
    }
    
 
    
    func resetTimer(){
        
    }
    
    func stopTimerAndAnimatin(){
        timer.invalidate()
        shapeLayer.stopAnimation(forKey: "basicAnimation")
        pulsatingLayer.stopAnimation(forKey: "pulsatingAnimation")
    }
    
    
 
    // Question Number label
    var timerCountDownLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = UIColor.white
        label.text = "20"
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    // Level Number Label
    var quizLevelLable:UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = UIColor.white
//        label.backgroundColor = UIColor.white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    // Score Number Label
    var quizScoreLable:UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.textAlignment = .center
//        label.backgroundColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = UIColor.white
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()

    // Question Label
    var quizQuestLable:UILabel = {
        let label = UILabel()
        label.numberOfLines = 5
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = UIColor.white
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
   lazy var button1: UIButton = {
       let button = UIButton(type: .custom)
        button.backgroundColor = UIColor.flatBlue()
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        button.setTitle("Answer 1", for: .normal)
        button.titleLabel?.textColor = UIColor.black
        button.addTarget(self, action: #selector(button1Pressed), for:.touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
   lazy var button2: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = UIColor.flatBlue()
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        button.setTitle("Answer 2", for: .normal)
        button.addTarget(self, action: #selector(button2Pressed), for:.touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
   lazy var button3: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Answer 3", for: .normal)
        button.backgroundColor = UIColor.flatBlue()
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(button3Pressed), for:.touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
   lazy var button4: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Answer 4", for: .normal)
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        button.backgroundColor = UIColor.flatBlue()
        button.addTarget(self, action: #selector(button4Pressed), for:.touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var nextButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Next", for: .normal)
        button.backgroundColor = UIColor.flatGreen()
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(nextButtonPressed), for:.touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var cancelQuizButton : UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Cancel", for: .normal)
        button.backgroundColor = UIColor.flatRed()
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(cancelButtonPressed), for:.touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
  
    func setupView(){
        
        self.view.addSubview(quizQuestLable)
        self.view.addSubview(quizLevelLable)
        self.view.addSubview(quizScoreLable)
        self.view.addSubview(button1)
        self.view.addSubview(button2)
        self.view.addSubview(button3)
        self.view.addSubview(button4)
        self.view.addSubview(nextButton)
        self.view.addSubview(cancelQuizButton)
        self.view.addSubview(timerCountDownLabel)
        

        
        let buttonWidth = self.view.frame.width / 2 - 25
        
        quizScoreLable.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 50).isActive = true
        quizScoreLable.heightAnchor.constraint(equalToConstant: 50).isActive = true
        quizScoreLable.widthAnchor.constraint(equalToConstant: 100).isActive = true
        quizScoreLable.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -16).isActive = true
        
        quizLevelLable.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16).isActive = true
        quizLevelLable.widthAnchor.constraint(equalToConstant: 100).isActive = true
        quizLevelLable.topAnchor.constraint(equalTo: self.quizScoreLable.topAnchor).isActive = true
        quizLevelLable.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        timerCountDownLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        timerCountDownLabel.widthAnchor.constraint(equalToConstant: 50).isActive = true
        timerCountDownLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        timerCountDownLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 75).isActive = true
        
        quizQuestLable.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16).isActive = true
        quizQuestLable.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -16).isActive = true
        quizQuestLable.topAnchor.constraint(equalTo: quizScoreLable.bottomAnchor, constant: 100).isActive = true
        quizQuestLable.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        button1.leftAnchor.constraint(equalTo: quizQuestLable.leftAnchor).isActive = true
        button1.topAnchor.constraint(equalTo: quizQuestLable.bottomAnchor, constant: 20).isActive = true
        button1.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button1.widthAnchor.constraint(equalToConstant: CGFloat(buttonWidth)).isActive = true
        
        button2.rightAnchor.constraint(equalTo: quizQuestLable.rightAnchor).isActive = true
        button2.topAnchor.constraint(equalTo: quizQuestLable.bottomAnchor, constant: 20).isActive = true
        button2.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button2.widthAnchor.constraint(equalToConstant: CGFloat(buttonWidth)).isActive = true
        
        button3.leftAnchor.constraint(equalTo: quizQuestLable.leftAnchor).isActive = true
        button3.topAnchor.constraint(equalTo: button1.bottomAnchor, constant: 10).isActive = true
        button3.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button3.widthAnchor.constraint(equalToConstant: CGFloat(buttonWidth)).isActive = true
        
        button4.rightAnchor.constraint(equalTo: quizQuestLable.rightAnchor).isActive = true
        button4.topAnchor.constraint(equalTo: button2.bottomAnchor, constant: 10).isActive = true
        button4.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button4.widthAnchor.constraint(equalToConstant: CGFloat(buttonWidth)).isActive = true
        
        nextButton.topAnchor.constraint(equalTo: button4.bottomAnchor, constant: 30).isActive = true
        nextButton.rightAnchor.constraint(equalTo: quizQuestLable.rightAnchor).isActive = true
        nextButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        nextButton.widthAnchor.constraint(equalToConstant: CGFloat(buttonWidth)).isActive = true
        
        cancelQuizButton.topAnchor.constraint(equalTo: nextButton.topAnchor).isActive = true
        cancelQuizButton.leftAnchor.constraint(equalTo: quizQuestLable.leftAnchor).isActive = true
        cancelQuizButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        cancelQuizButton.widthAnchor.constraint(equalToConstant: CGFloat(buttonWidth)).isActive = true

    }

    
   @objc func button1Pressed(){
    if AnswerNumber == 0 {
        button1.backgroundColor = UIColor.flatGreen()
        
        updateScoreValue()
       
    }else{
        NSLog("Wrong")
        
        button1.backgroundColor = UIColor.flatRed()
    }
        disableButtonClick()
        stopTimerAndAnimatin()
    }
    @objc func button2Pressed(){
        
        if AnswerNumber == 1 {
            button2.backgroundColor = UIColor.flatGreen()
            updateScoreValue()
            
        }else{
            NSLog("Wrong")
            button2.backgroundColor = UIColor.flatRed()
        }
        disableButtonClick()
        stopTimerAndAnimatin()
        
    }
    @objc func button3Pressed(){
        if AnswerNumber == 2 {
            button3.backgroundColor = UIColor.flatGreen()
            updateScoreValue()
            
        }else{
            NSLog("Wrong")
            button3.backgroundColor = UIColor.flatRed()
        }
        disableButtonClick()
        stopTimerAndAnimatin()
        
    }
    @objc func button4Pressed(){
        if AnswerNumber == 3 {
            button4.backgroundColor = UIColor.flatGreen()
            updateScoreValue()
            
        }else{
            NSLog("Wrong")
            button4.backgroundColor = UIColor.flatRed()
        }
        disableButtonClick()
        stopTimerAndAnimatin()
        
    }
    @objc func nextButtonPressed(){
        timer.invalidate()
        
        
        if levelQuestionNumber <= (totalQuestion - 1) {
            levelQuestionNumber += 1
            timerCountDownLabel.text = "20"
        }else {
            
        }
        nextButton.isHidden = true
        enableButtonClick()
        resetButtonColour()
        pickQuestion()
        animateCircularStroke()
        animatepulsatingLayer()
    }
    
    @objc func cancelButtonPressed(){
        // Stop Timmer here, (Pending)
        print("Cancel Button Pressed")
        let alert = PCLBlurEffectAlert.Controller(title: "Cancel Quiz", message: "Are you sure you want cancel quiz ", effect: UIBlurEffect(style: .dark), style: .alert)
//        let cancelButton = PCLBlurEffectAlertAction.init(title: "Cancel", style: .destructive, handler: nil)
        let cancelButton = PCLBlurEffectAlertAction.init(title: "Cancel", style: .destructive) { (alert) in
            // Continew Timer here.(Pending)
            
            print("Cancel Button Pressed inside cancel alert")
        }
        alert.addAction(cancelButton)
        
        let yesButton = PCLBlurEffectAlertAction.init(title: "Yes", style: .default) { (alert) in
            // Stop Timer(Pending)
            print("Quiz cancled")
            // Navigate to finish quiz page
            self.navigateToFinishQuizPage()
        }
        alert.addAction(yesButton)
        alert.configure(cornerRadius: 30)
        alert.configure(titleColor: UIColor.orange)
        alert.configure(messageColor: UIColor.white)
        
        alert.show()
        
    }
    
    func resetButtonColour(){
//        enableButtonClick()
        button1.backgroundColor = UIColor.flatBlue()
        button2.backgroundColor = UIColor.flatBlue()
        button3.backgroundColor = UIColor.flatBlue()
        button4.backgroundColor = UIColor.flatBlue()
    }
    func disableButtonClick(){
        button1.isEnabled = false
        button2.isEnabled = false
        button3.isEnabled = false
        button4.isEnabled = false
        nextButton.isHidden = false
    }
    func enableButtonClick(){
        button1.isEnabled = true
        button2.isEnabled = true
        button3.isEnabled = true
        button4.isEnabled = true
    }
    
    func pickQuestion(){
        resetButtonColour()
        seconds = 20
        runTimer()
        if Questions.count > 0 {
            Qnumber = 0
            quizQuestLable.text = Questions[Qnumber].Question
            AnswerNumber = Questions[Qnumber].Answer
            
            for i in 0..<buttonArray.count{
                buttonArray[i].setTitle(Questions[Qnumber].Answers[i], for: .normal)
            }
            Questions.remove(at: Qnumber)
        } else {
            print("Quiz end")
            navigateToFinishQuizPage()
            stopTimerAndAnimatin()
            
            
        }
    }
    
    func updateScoreValue(){
        score += 1
        quizScoreLable.text = "Score\n\(score)/\(totalQuestion)"
        
    }
    func navigateToFinishQuizPage(){
        print("Navigate to finish quiz function start")
        let FinishQuizViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FinishQuizViewController") as! FinishQuizViewController
        FinishQuizViewController.finalScore = score
        FinishQuizViewController.currentLevelPlayed = selectedGameLevel
        FinishQuizViewController.totalQuestion = self.totalQuestion
        present(FinishQuizViewController, animated: true, completion: nil)
    }
    
    func picQuestionSet(leveNumber : Int){
        if (leveNumber == 0){
            questionLevel0()
        }else if(leveNumber == 1){
            questionLevel1()
        }else if(leveNumber == 2){
            questionLevel2()
        }else if(leveNumber == 3){
            questionLevel3()
        }else if(leveNumber == 4){
            questionLevel4()
        }else if(leveNumber == 5){
            questionLevel5()
        }else if(leveNumber == 6){
            questionLevel6()
        }else if(leveNumber == 7){
            questionLevel7()
        }else if(leveNumber == 8){
            questionLevel8()
        }else if(leveNumber == 9){
            questionLevel9()
        }else if(leveNumber == 10){
            questionLevel10()
        }else if(leveNumber == 11){
            questionLevel11()
        }else if(leveNumber == 12){
            questionLevel12()
        }else if(leveNumber == 13){
            questionLevel13()
        }else if(leveNumber == 14){
            questionLevel14()
        }else if(leveNumber == 15){
            questionLevel15()
        }else if(leveNumber == 16){
            questionLevel16()
        }else if(leveNumber == 17){
            questionLevel17()
        }else if(leveNumber == 18){
            questionLevel18()
        }else if(leveNumber == 19){
            questionLevel19()
        }else if(leveNumber == 20){
            questionLevel20()
        }else if(leveNumber == 21){
            questionLevel21()
        }else if(leveNumber == 22){
            questionLevel22()
        }else if(leveNumber == 23){
            questionLevel23()
        }else if(leveNumber == 24){
            questionLevel24()
        }else if(leveNumber == 25){
            questionLevel25()
        }else if(leveNumber == 26){
            questionLevel26()
        }else if(leveNumber == 27){
            questionLevel27()
        }else if(leveNumber == 28){
            questionLevel28()
        }else if(leveNumber == 29){
            questionLevel29()
        }else if(leveNumber == 30){
            questionLevel30()
        }else if(leveNumber == 31){
            questionLevel31()
        }else if(leveNumber == 32){
            questionLevel32()
        }else if(leveNumber == 33){
            questionLevel33()
        }else if(leveNumber == 34){
            questionLevel34()
        }else if(leveNumber == 35){
            questionLevel35()
        }else if(leveNumber == 36){
            questionLevel36()
        }else if(leveNumber == 37){
            questionLevel37()
        }else if(leveNumber == 38){
            questionLevel38()
        }else if(leveNumber == 39){
            questionLevel39()
        }else if(leveNumber == 40){
            questionLevel40()
        }else if(leveNumber == 41){
            questionLevel41()
        }else if(leveNumber == 42){
            questionLevel42()
        }else if(leveNumber == 43){
            questionLevel43()
        }else if(leveNumber == 44){
            questionLevel44()
        }else if(leveNumber == 45){
            questionLevel45()
        }else if(leveNumber == 46){
            questionLevel46()
        }else if(leveNumber == 47){
            questionLevel47()
        }else if(leveNumber == 48){
            questionLevel48()
        }else {
            questionLevel49()
        }
        
    }
    
    func questionLevel0(){
        Questions = [Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
        Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
        Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
        Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2)]
        quizScoreLable.text = "\(score)/\(Questions.count)"
        totalQuestion = Questions.count
    }
    func questionLevel1(){
        Questions = [Question(Question: "This is Second Level", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "This is Second Level", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "This is Second Level", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "This is Second Level", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2)]
        quizScoreLable.text = "\(score)/\(Questions.count)"
        totalQuestion = Questions.count
        
    }
    
    func questionLevel2(){
        
    }
    func questionLevel3(){
        
    }
    func questionLevel4(){
        
    }
    func questionLevel5(){
        
    }
    func questionLevel6(){
        
    }
    func questionLevel7(){
        
    }
    func questionLevel8(){
        
    }
    func questionLevel9(){
        
    }
    func questionLevel10(){
        
    }
    func questionLevel11(){
        
    }
    func questionLevel12(){
        
    }
    func questionLevel13(){
        
    }
    func questionLevel14(){
        
    }
    func questionLevel15(){
        
    }
    func questionLevel16(){
        
    }
    func questionLevel17(){
        
    }
    func questionLevel18(){
        
    }
    func questionLevel19(){
        
    }
    func questionLevel20(){
        
    }
    func questionLevel21(){
        
    }
    func questionLevel22(){
        
    }
    func questionLevel23(){
        
    }
    func questionLevel24(){
        
    }
    func questionLevel25(){
        
    }
    func questionLevel26(){
        
    }
    func questionLevel27(){
        
    }
    func questionLevel28(){
        
    }
    func questionLevel29(){
        
    }
    func questionLevel30(){
        
    }
    func questionLevel31(){
        
    }
    func questionLevel32(){
        
    }
    func questionLevel33(){
        
    }
    func questionLevel34(){
        
    }
    func questionLevel35(){
        
    }
    func questionLevel36(){
        
    }
    func questionLevel37(){
        
    }
    func questionLevel38(){
        
    }
    func questionLevel39(){
        
    }
    func questionLevel40(){
        
    }
    func questionLevel41(){
        
    }
    func questionLevel42(){
        
    }
    func questionLevel43(){
        
    }
    func questionLevel44(){
        
    }
    func questionLevel45(){
        
    }
    func questionLevel46(){
        
    }
    func questionLevel47(){
        
    }
    func questionLevel48(){
        
    }
    func questionLevel49(){
        
    }
   
    

}
