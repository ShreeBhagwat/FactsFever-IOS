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
        navigationController?.navigationBar.isHidden = true
        tabBarController?.tabBar.isHidden = true
//        runTimer()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.navigationBar.isHidden = false
        tabBarController?.tabBar.isHidden = false
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
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = UIColor.white
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
   lazy var button1: UIButton = {
       let button = UIButton(type: .custom)
        button.backgroundColor = UIColor.flatBlue()
        button.tag = 1
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
        button.tag = 2
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
        button.tag = 3
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
        button.tag = 4
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
        let rightButton = buttonArray[AnswerNumber]
        rightButton.backgroundColor = UIColor.flatGreen()
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
            let rightButton = buttonArray[AnswerNumber]
            rightButton.backgroundColor = UIColor.flatGreen()
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
            let rightButton = buttonArray[AnswerNumber]
            rightButton.backgroundColor = UIColor.flatGreen()
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
            let rightButton = buttonArray[AnswerNumber]
            rightButton.backgroundColor = UIColor.flatGreen()
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
        navigationController?.pushViewController(FinishQuizViewController, animated: true)
        
        
       
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
        Questions = [Question(Question: "The Smallest living bird is ?", Answers: ["weebill","pardolate","bee hummingbird","Cisticola"], Answer: 2),
                     Question(Question: "The longest street in world is ?", Answers: ["Yonge street","Second street","First street","Wang street"], Answer: 0),
        Question(Question: "Vitamin D come from ?", Answers: ["Sun","Fish","Supplements","Cholesterol"], Answer: 3),
        Question(Question: "The new word added to Oxford Dictionary at the end was ?", Answers: ["zymogens","Zyzzyva","zymosans","Zeda"], Answer: 1),
        Question(Question: "Chewing gum is illegal in what country ?", Answers: ["Nigeria","Switzerland","Singapore","China"], Answer: 2),
        Question(Question: "Which is the country with maximum number of people suffering from depression?", Answers: ["USA","China","indonesia","India"], Answer: 3),
        Question(Question: "Which animals will eat themselves if no other food source is available?", Answers: ["Humans","Ribbon worms","Earthworms","Snakes"], Answer: 1),
        Question(Question: "Name the dead gene that came back to life, prevents cancer by killing cells with DNA damage.", Answers: ["LIF6","Abraxne","Cytoxan","Doxil"], Answer: 0),
        Question(Question: "Number of recognised words for Vagina.", Answers: ["2000","500","10","1000"], Answer: 3),
        Question(Question: "The Lion King  was actually considered a class B movie as all the producers were working on different movie, What movie was that?", Answers: ["Mary Poppins","Sword Stone","Pocahontas","Toy Story"], Answer: 2)]
        quizScoreLable.text = "\(score)/\(Questions.count)"
        totalQuestion = Questions.count
    }
    func questionLevel1(){
        Questions = [Question(Question: "In 1973, which space station turned off all communications with NASA after being over-worked and spent the day relaxing and looking at the Earth. It is the only strike to occur in space.", Answers: ["Skylab space","International Space","Kosmos","Mir Space"], Answer: 0),
         Question(Question: "Dark Energy is Incompatible with what theory", Answers: ["Quantum Theory","Relativity","String Theory","Big Bang"], Answer: 2),
         Question(Question: "People who are aroused by teeth - looking at them, licking them, caressing them lovingly are called as", Answers: ["Haemophiliacs","Odontophiliacs","Podophilia","Paraphilia"], Answer: 1),
         Question(Question: "Where was The Eiffel Tower originally supposed to be ?", Answers: ["Denmark","Spain","Holland","Barcelona"], Answer: 3),
         Question(Question: "Based on landmass, is the smallest country in the world, measuring just 0.2 square miles.", Answers: ["Amsterdam","Vatican City","St Asaph","Maza"], Answer: 1),
         Question(Question: "The first proposal for space travel in English history was made by whose brother in law ?", Answers: ["Oliver Cromwell","Leonardo da Vinci","Galileo Galilei","Avicenna"], Answer: 0),
         Question(Question: "How much time do Sloths take  to digest their food?", Answers: ["4 Hours","2 days","1 week","2 weeks"], Answer: 3),
         Question(Question: "The president of Poland awards a medal to couples that remain married for how many years ?", Answers: ["25","50","40","60+"], Answer: 1),
         Question(Question: "The first man to urinate on the moon was ?", Answers: ["Niel Armstrong","Michael Collins ","Buzz aldrin","Yuri Gagrin"], Answer: 2),
         Question(Question: "Which software is use by movie makers to create fake actors through AI ?", Answers: ["MASSIVE","HOUDINI","SOFTIMAGE","ZBrush"], Answer: 0)]
        quizScoreLable.text = "\(score)/\(Questions.count)"
        totalQuestion = Questions.count
        
    }
    
    func questionLevel2(){
        Questions = [Question(Question: "What was Johnny Depp addicted to as a child ?", Answers: ["Chocolate","Cola","Ice Cream","Sugar"], Answer: 0),
                     Question(Question: "If Bill Gates was a country on number the country come in being rich ?", Answers: ["10th","18th","37th","43rd"], Answer: 2),
                     Question(Question: "World's smallest flowering plant is ? ", Answers: ["Poinsettia","Wolffia","Bromeliads","Peace Lily"], Answer: 1),
                     Question(Question: "On any given time what is the number of people having Sex", Answers: ["120 M","200 M","80 M ","450 M"], Answer: 0),
                     Question(Question: "Where will be the cheapest items be found, while shopping ?", Answers: ["Top","Middle","Bottom","Mixed"], Answer: 2),
                     Question(Question: "How much time does it takes for food to completely digest?", Answers: ["8 hrs","12 hrs","16 hrs","24 hrs"], Answer: 1),
                     Question(Question: "Storm clouds hold about how much rain drops in trillions ", Answers: ["2","4","6","8"], Answer: 2),
                     Question(Question: "Which is the only country to stop it's nuclear program voluntarily?", Answers: ["Israel","Japan","Germany","Africa"], Answer: 3),
                     Question(Question: "Jm was the oldest man ever to travel into space, as a passenger on the Discovery STS-95 mission in 1998. What was his age ?", Answers: ["77","80","83","91"], Answer: 0),
                     Question(Question: "What Does the D in D-Day stands for ?", Answers: ["Do","Doom","Din","Day"], Answer: 3)]
        quizScoreLable.text = "\(score)/\(Questions.count)"
        totalQuestion = Questions.count
    }
    func questionLevel3(){
        Questions = [Question(Question: "Which ancient priests would pluck every hair from their bodies.", Answers: ["Indian","Greek","African","Egyptian"], Answer: 3),
                     Question(Question: "The longest street in world is ?", Answers: ["Yonge street","Second street","First street","Wang street"], Answer: 0),
                     Question(Question: "Name the first fruit to be eaten on the moon.", Answers: ["Peach","Mango","Cherry","Avacado"], Answer: 0),
                     Question(Question: "Which is the food most stolen in the world ?", Answers: ["Meat","Nutella","Chocolate","Cheese"], Answer: 3),
                     Question(Question: "Amount of cups of spit does an healthy individual acumulates ? ", Answers: [">1","1 - 2","2 - 4","6 "], Answer: 2),
                     Question(Question: "Which bird is known to eat more than 1000 items", Answers: ["Eagle","Crow","Vulture","Falcon"], Answer: 1),
                     Question(Question: "What was the size of the entire Super Mario Bro", Answers: ["13 kb","5 mb","32 kb","40 kb"], Answer: 2),
                     Question(Question: "How many days can sperm live inside of woman", Answers: ["1-3 days","5-7 days","7 - 9 days","<9 days"], Answer: 1),
                     Question(Question: "Which tree is most fireproof", Answers: ["Redwood","Conkers","Japanes Elm","Ponderosa"], Answer: 0),
                     Question(Question: "Date of the oldest use of Condums", Answers: ["1590","1600","1640","1710"], Answer: 2)]
        quizScoreLable.text = "\(score)/\(Questions.count)"
        totalQuestion = Questions.count
    }
    func questionLevel4(){
        Questions = [Question(Question: "Who scored the first goal in football history", Answers: ["Raoul Diagne","Lucien Laurent","Larbi Benbarek","Jean Vincent"], Answer: 1),
                     Question(Question: "Guys fall in love after 3 dates, How many dates it takes for a girl to fall in love", Answers: ["2","10","14","20"], Answer: 2),
                     Question(Question: "Its important for the food to mix in saliva, for it to", Answers: ["Taste","Digest","cheewed","Swallowed"], Answer: 0),
                     Question(Question: "Name the village/City in India which plants a tree behind every female child birth", Answers: ["Wadgaon","Kerla","Pune","Piplantri"], Answer: 3),
                     Question(Question: "Which is the first country in the world to allow the creation of babies from the DNA of three people", Answers: ["America","UK","Africa","Japan"], Answer: 1),
                     Question(Question: "How many hours will be there in day on Earth after million years", Answers: ["10","20","30","40"], Answer: 2),
                     Question(Question: "NASAs new mission will study the border of Earths atmosphere and space, what is that mission is called", Answers: ["BORDER","GOLD","HORIZON","MEET"], Answer: 1),
                     Question(Question: "Rupert Grint (Ron from Harry Potter) what was his dream ambition ?", Answers: ["Actor","Ice Cream Seller","Fireman","Sports person"], Answer: 1),
                     Question(Question: "Name the love hormone", Answers: ["Serotonin","Testosteron","corticotropin","Oxytcin"], Answer: 3),
                     Question(Question: "Longest cell in humans ?", Answers: ["Motor Neurons","myocytes","oligodendrocytes","ependymal cells"], Answer:0)]
        quizScoreLable.text = "\(score)/\(Questions.count)"
        totalQuestion = Questions.count
    }
    func questionLevel5(){
        Questions = [Question(Question: "How much can an astronaut increase in height after returning from space", Answers: ["> 1 inch","1 inch","2 inches","2+ inches"], Answer: 2),
     Question(Question: "We identify banana as a tree, but what are they really ?", Answers: ["Shrubs","Grass","Herbs","Non of Above"], Answer: 3),
     Question(Question: "Which country sprouted a a plant on moon?", Answers: ["America","China","India","Russia"], Answer: 1),
     Question(Question: "If you could drive your car straight to the space how long will it take to reach space ?", Answers: ["30 min","1 hr","10 hr","1 day"], Answer: 1 ),
     Question(Question: "Which is the only country without mosquitoes?", Answers: ["iceland","Antartica","Greenland","Russia"], Answer: 0),
     Question(Question: "How many peanuts does to take make a 12 ounce penut butter", Answers: ["400","500","600","700"], Answer: 1),
     Question(Question: "Weirdly interesting thing is that the word “hundred” is derived from another word hundrath, how much is hundrath ", Answers: ["80","100","120","101"], Answer: 2),
     Question(Question: "Which river flows for north to south half year, and south to north rest of the year", Answers: ["Tonle Sap","Ganga","Thames","Mississippi"], Answer: 0),
     Question(Question: "Which alcohol can reduce the acne breakout after applying it to face", Answers: ["Wiskey","Taquila","Gin","Vodka"], Answer: 3),
     Question(Question: "What was the slowest speed of light observed", Answers: ["30km/s","40km/s","50km/s","60km/s"], Answer: 1)]
        quizScoreLable.text = "\(score)/\(Questions.count)"
        totalQuestion = Questions.count
    }
    func questionLevel6(){
        Questions = [Question(Question: "The Smallest living bird is ?", Answers: ["weebill","pardolate","bee hummingbird","Cisticola"], Answer: 2),
                     Question(Question: "The longest street in world is ?", Answers: ["Yonge street","Second street","First street","Wang street"], Answer: 0),
                     Question(Question: "Vitamin D come from ?", Answers: ["Sun","Fish","Supplements","Cholesterol"], Answer: 3),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2)]
        quizScoreLable.text = "\(score)/\(Questions.count)"
        totalQuestion = Questions.count
    }
    func questionLevel7(){
        Questions = [Question(Question: "The Smallest living bird is ?", Answers: ["weebill","pardolate","bee hummingbird","Cisticola"], Answer: 2),
                     Question(Question: "The longest street in world is ?", Answers: ["Yonge street","Second street","First street","Wang street"], Answer: 0),
                     Question(Question: "Vitamin D come from ?", Answers: ["Sun","Fish","Supplements","Cholesterol"], Answer: 3),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2)]
        quizScoreLable.text = "\(score)/\(Questions.count)"
        totalQuestion = Questions.count
    }
    func questionLevel8(){
        Questions = [Question(Question: "The Smallest living bird is ?", Answers: ["weebill","pardolate","bee hummingbird","Cisticola"], Answer: 2),
                     Question(Question: "The longest street in world is ?", Answers: ["Yonge street","Second street","First street","Wang street"], Answer: 0),
                     Question(Question: "Vitamin D come from ?", Answers: ["Sun","Fish","Supplements","Cholesterol"], Answer: 3),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2)]
        quizScoreLable.text = "\(score)/\(Questions.count)"
        totalQuestion = Questions.count
    }
    func questionLevel9(){
        Questions = [Question(Question: "The Smallest living bird is ?", Answers: ["weebill","pardolate","bee hummingbird","Cisticola"], Answer: 2),
                     Question(Question: "The longest street in world is ?", Answers: ["Yonge street","Second street","First street","Wang street"], Answer: 0),
                     Question(Question: "Vitamin D come from ?", Answers: ["Sun","Fish","Supplements","Cholesterol"], Answer: 3),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2)]
        quizScoreLable.text = "\(score)/\(Questions.count)"
        totalQuestion = Questions.count
    }
    func questionLevel10(){
        Questions = [Question(Question: "The Smallest living bird is ?", Answers: ["weebill","pardolate","bee hummingbird","Cisticola"], Answer: 2),
                     Question(Question: "The longest street in world is ?", Answers: ["Yonge street","Second street","First street","Wang street"], Answer: 0),
                     Question(Question: "Vitamin D come from ?", Answers: ["Sun","Fish","Supplements","Cholesterol"], Answer: 3),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2)]
        quizScoreLable.text = "\(score)/\(Questions.count)"
        totalQuestion = Questions.count
    }
    func questionLevel11(){
        Questions = [Question(Question: "The Smallest living bird is ?", Answers: ["weebill","pardolate","bee hummingbird","Cisticola"], Answer: 2),
                     Question(Question: "The longest street in world is ?", Answers: ["Yonge street","Second street","First street","Wang street"], Answer: 0),
                     Question(Question: "Vitamin D come from ?", Answers: ["Sun","Fish","Supplements","Cholesterol"], Answer: 3),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2)]
        quizScoreLable.text = "\(score)/\(Questions.count)"
        totalQuestion = Questions.count
    }
    func questionLevel12(){
        Questions = [Question(Question: "The Smallest living bird is ?", Answers: ["weebill","pardolate","bee hummingbird","Cisticola"], Answer: 2),
                     Question(Question: "The longest street in world is ?", Answers: ["Yonge street","Second street","First street","Wang street"], Answer: 0),
                     Question(Question: "Vitamin D come from ?", Answers: ["Sun","Fish","Supplements","Cholesterol"], Answer: 3),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2)]
        quizScoreLable.text = "\(score)/\(Questions.count)"
        totalQuestion = Questions.count
    }
    func questionLevel13(){
        Questions = [Question(Question: "The Smallest living bird is ?", Answers: ["weebill","pardolate","bee hummingbird","Cisticola"], Answer: 2),
                     Question(Question: "The longest street in world is ?", Answers: ["Yonge street","Second street","First street","Wang street"], Answer: 0),
                     Question(Question: "Vitamin D come from ?", Answers: ["Sun","Fish","Supplements","Cholesterol"], Answer: 3),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2)]
        quizScoreLable.text = "\(score)/\(Questions.count)"
        totalQuestion = Questions.count
    }
    func questionLevel14(){
        Questions = [Question(Question: "The Smallest living bird is ?", Answers: ["weebill","pardolate","bee hummingbird","Cisticola"], Answer: 2),
                     Question(Question: "The longest street in world is ?", Answers: ["Yonge street","Second street","First street","Wang street"], Answer: 0),
                     Question(Question: "Vitamin D come from ?", Answers: ["Sun","Fish","Supplements","Cholesterol"], Answer: 3),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2)]
        quizScoreLable.text = "\(score)/\(Questions.count)"
        totalQuestion = Questions.count
    }
    func questionLevel15(){
        Questions = [Question(Question: "The Smallest living bird is ?", Answers: ["weebill","pardolate","bee hummingbird","Cisticola"], Answer: 2),
                     Question(Question: "The longest street in world is ?", Answers: ["Yonge street","Second street","First street","Wang street"], Answer: 0),
                     Question(Question: "Vitamin D come from ?", Answers: ["Sun","Fish","Supplements","Cholesterol"], Answer: 3),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2)]
        quizScoreLable.text = "\(score)/\(Questions.count)"
        totalQuestion = Questions.count
    }
    func questionLevel16(){
        Questions = [Question(Question: "The Smallest living bird is ?", Answers: ["weebill","pardolate","bee hummingbird","Cisticola"], Answer: 2),
                     Question(Question: "The longest street in world is ?", Answers: ["Yonge street","Second street","First street","Wang street"], Answer: 0),
                     Question(Question: "Vitamin D come from ?", Answers: ["Sun","Fish","Supplements","Cholesterol"], Answer: 3),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2)]
        quizScoreLable.text = "\(score)/\(Questions.count)"
        totalQuestion = Questions.count
    }
    func questionLevel17(){
        Questions = [Question(Question: "The Smallest living bird is ?", Answers: ["weebill","pardolate","bee hummingbird","Cisticola"], Answer: 2),
                     Question(Question: "The longest street in world is ?", Answers: ["Yonge street","Second street","First street","Wang street"], Answer: 0),
                     Question(Question: "Vitamin D come from ?", Answers: ["Sun","Fish","Supplements","Cholesterol"], Answer: 3),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2)]
        quizScoreLable.text = "\(score)/\(Questions.count)"
        totalQuestion = Questions.count
    }
    func questionLevel18(){
        Questions = [Question(Question: "The Smallest living bird is ?", Answers: ["weebill","pardolate","bee hummingbird","Cisticola"], Answer: 2),
                     Question(Question: "The longest street in world is ?", Answers: ["Yonge street","Second street","First street","Wang street"], Answer: 0),
                     Question(Question: "Vitamin D come from ?", Answers: ["Sun","Fish","Supplements","Cholesterol"], Answer: 3),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2)]
        quizScoreLable.text = "\(score)/\(Questions.count)"
        totalQuestion = Questions.count
    }
    func questionLevel19(){
        Questions = [Question(Question: "The Smallest living bird is ?", Answers: ["weebill","pardolate","bee hummingbird","Cisticola"], Answer: 2),
                     Question(Question: "The longest street in world is ?", Answers: ["Yonge street","Second street","First street","Wang street"], Answer: 0),
                     Question(Question: "Vitamin D come from ?", Answers: ["Sun","Fish","Supplements","Cholesterol"], Answer: 3),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2)]
        quizScoreLable.text = "\(score)/\(Questions.count)"
        totalQuestion = Questions.count
    }
    func questionLevel20(){
        Questions = [Question(Question: "The Smallest living bird is ?", Answers: ["weebill","pardolate","bee hummingbird","Cisticola"], Answer: 2),
                     Question(Question: "The longest street in world is ?", Answers: ["Yonge street","Second street","First street","Wang street"], Answer: 0),
                     Question(Question: "Vitamin D come from ?", Answers: ["Sun","Fish","Supplements","Cholesterol"], Answer: 3),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2)]
        quizScoreLable.text = "\(score)/\(Questions.count)"
        totalQuestion = Questions.count
    }
    func questionLevel21(){
        Questions = [Question(Question: "The Smallest living bird is ?", Answers: ["weebill","pardolate","bee hummingbird","Cisticola"], Answer: 2),
                     Question(Question: "The longest street in world is ?", Answers: ["Yonge street","Second street","First street","Wang street"], Answer: 0),
                     Question(Question: "Vitamin D come from ?", Answers: ["Sun","Fish","Supplements","Cholesterol"], Answer: 3),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2)]
        quizScoreLable.text = "\(score)/\(Questions.count)"
        totalQuestion = Questions.count
    }
    func questionLevel22(){
        Questions = [Question(Question: "The Smallest living bird is ?", Answers: ["weebill","pardolate","bee hummingbird","Cisticola"], Answer: 2),
                     Question(Question: "The longest street in world is ?", Answers: ["Yonge street","Second street","First street","Wang street"], Answer: 0),
                     Question(Question: "Vitamin D come from ?", Answers: ["Sun","Fish","Supplements","Cholesterol"], Answer: 3),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2)]
        quizScoreLable.text = "\(score)/\(Questions.count)"
        totalQuestion = Questions.count
    }
    func questionLevel23(){
        Questions = [Question(Question: "The Smallest living bird is ?", Answers: ["weebill","pardolate","bee hummingbird","Cisticola"], Answer: 2),
                     Question(Question: "The longest street in world is ?", Answers: ["Yonge street","Second street","First street","Wang street"], Answer: 0),
                     Question(Question: "Vitamin D come from ?", Answers: ["Sun","Fish","Supplements","Cholesterol"], Answer: 3),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2)]
        quizScoreLable.text = "\(score)/\(Questions.count)"
        totalQuestion = Questions.count
    }
    func questionLevel24(){
        Questions = [Question(Question: "The Smallest living bird is ?", Answers: ["weebill","pardolate","bee hummingbird","Cisticola"], Answer: 2),
                     Question(Question: "The longest street in world is ?", Answers: ["Yonge street","Second street","First street","Wang street"], Answer: 0),
                     Question(Question: "Vitamin D come from ?", Answers: ["Sun","Fish","Supplements","Cholesterol"], Answer: 3),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2)]
        quizScoreLable.text = "\(score)/\(Questions.count)"
        totalQuestion = Questions.count
    }
    func questionLevel25(){
        Questions = [Question(Question: "The Smallest living bird is ?", Answers: ["weebill","pardolate","bee hummingbird","Cisticola"], Answer: 2),
                     Question(Question: "The longest street in world is ?", Answers: ["Yonge street","Second street","First street","Wang street"], Answer: 0),
                     Question(Question: "Vitamin D come from ?", Answers: ["Sun","Fish","Supplements","Cholesterol"], Answer: 3),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2)]
        quizScoreLable.text = "\(score)/\(Questions.count)"
        totalQuestion = Questions.count
    }
    func questionLevel26(){
        Questions = [Question(Question: "The Smallest living bird is ?", Answers: ["weebill","pardolate","bee hummingbird","Cisticola"], Answer: 2),
                     Question(Question: "The longest street in world is ?", Answers: ["Yonge street","Second street","First street","Wang street"], Answer: 0),
                     Question(Question: "Vitamin D come from ?", Answers: ["Sun","Fish","Supplements","Cholesterol"], Answer: 3),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2)]
        quizScoreLable.text = "\(score)/\(Questions.count)"
        totalQuestion = Questions.count
    }
    func questionLevel27(){
        Questions = [Question(Question: "The Smallest living bird is ?", Answers: ["weebill","pardolate","bee hummingbird","Cisticola"], Answer: 2),
                     Question(Question: "The longest street in world is ?", Answers: ["Yonge street","Second street","First street","Wang street"], Answer: 0),
                     Question(Question: "Vitamin D come from ?", Answers: ["Sun","Fish","Supplements","Cholesterol"], Answer: 3),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2)]
        quizScoreLable.text = "\(score)/\(Questions.count)"
        totalQuestion = Questions.count
    }
    func questionLevel28(){
        Questions = [Question(Question: "The Smallest living bird is ?", Answers: ["weebill","pardolate","bee hummingbird","Cisticola"], Answer: 2),
                     Question(Question: "The longest street in world is ?", Answers: ["Yonge street","Second street","First street","Wang street"], Answer: 0),
                     Question(Question: "Vitamin D come from ?", Answers: ["Sun","Fish","Supplements","Cholesterol"], Answer: 3),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2)]
        quizScoreLable.text = "\(score)/\(Questions.count)"
        totalQuestion = Questions.count
    }
    func questionLevel29(){
        Questions = [Question(Question: "The Smallest living bird is ?", Answers: ["weebill","pardolate","bee hummingbird","Cisticola"], Answer: 2),
                     Question(Question: "The longest street in world is ?", Answers: ["Yonge street","Second street","First street","Wang street"], Answer: 0),
                     Question(Question: "Vitamin D come from ?", Answers: ["Sun","Fish","Supplements","Cholesterol"], Answer: 3),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2)]
        quizScoreLable.text = "\(score)/\(Questions.count)"
        totalQuestion = Questions.count
    }
    func questionLevel30(){
        Questions = [Question(Question: "The Smallest living bird is ?", Answers: ["weebill","pardolate","bee hummingbird","Cisticola"], Answer: 2),
                     Question(Question: "The longest street in world is ?", Answers: ["Yonge street","Second street","First street","Wang street"], Answer: 0),
                     Question(Question: "Vitamin D come from ?", Answers: ["Sun","Fish","Supplements","Cholesterol"], Answer: 3),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2)]
        quizScoreLable.text = "\(score)/\(Questions.count)"
        totalQuestion = Questions.count
    }
    func questionLevel31(){
        Questions = [Question(Question: "The Smallest living bird is ?", Answers: ["weebill","pardolate","bee hummingbird","Cisticola"], Answer: 2),
                     Question(Question: "The longest street in world is ?", Answers: ["Yonge street","Second street","First street","Wang street"], Answer: 0),
                     Question(Question: "Vitamin D come from ?", Answers: ["Sun","Fish","Supplements","Cholesterol"], Answer: 3),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2)]
        quizScoreLable.text = "\(score)/\(Questions.count)"
        totalQuestion = Questions.count
    }
    func questionLevel32(){
        Questions = [Question(Question: "The Smallest living bird is ?", Answers: ["weebill","pardolate","bee hummingbird","Cisticola"], Answer: 2),
                     Question(Question: "The longest street in world is ?", Answers: ["Yonge street","Second street","First street","Wang street"], Answer: 0),
                     Question(Question: "Vitamin D come from ?", Answers: ["Sun","Fish","Supplements","Cholesterol"], Answer: 3),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2)]
        quizScoreLable.text = "\(score)/\(Questions.count)"
        totalQuestion = Questions.count
    }
    func questionLevel33(){
        Questions = [Question(Question: "The Smallest living bird is ?", Answers: ["weebill","pardolate","bee hummingbird","Cisticola"], Answer: 2),
                     Question(Question: "The longest street in world is ?", Answers: ["Yonge street","Second street","First street","Wang street"], Answer: 0),
                     Question(Question: "Vitamin D come from ?", Answers: ["Sun","Fish","Supplements","Cholesterol"], Answer: 3),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2)]
        quizScoreLable.text = "\(score)/\(Questions.count)"
        totalQuestion = Questions.count
    }
    func questionLevel34(){
        Questions = [Question(Question: "The Smallest living bird is ?", Answers: ["weebill","pardolate","bee hummingbird","Cisticola"], Answer: 2),
                     Question(Question: "The longest street in world is ?", Answers: ["Yonge street","Second street","First street","Wang street"], Answer: 0),
                     Question(Question: "Vitamin D come from ?", Answers: ["Sun","Fish","Supplements","Cholesterol"], Answer: 3),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2)]
        quizScoreLable.text = "\(score)/\(Questions.count)"
        totalQuestion = Questions.count
    }
    func questionLevel35(){
        Questions = [Question(Question: "The Smallest living bird is ?", Answers: ["weebill","pardolate","bee hummingbird","Cisticola"], Answer: 2),
                     Question(Question: "The longest street in world is ?", Answers: ["Yonge street","Second street","First street","Wang street"], Answer: 0),
                     Question(Question: "Vitamin D come from ?", Answers: ["Sun","Fish","Supplements","Cholesterol"], Answer: 3),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2)]
        quizScoreLable.text = "\(score)/\(Questions.count)"
        totalQuestion = Questions.count
    }
    func questionLevel36(){
        Questions = [Question(Question: "The Smallest living bird is ?", Answers: ["weebill","pardolate","bee hummingbird","Cisticola"], Answer: 2),
                     Question(Question: "The longest street in world is ?", Answers: ["Yonge street","Second street","First street","Wang street"], Answer: 0),
                     Question(Question: "Vitamin D come from ?", Answers: ["Sun","Fish","Supplements","Cholesterol"], Answer: 3),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2)]
        quizScoreLable.text = "\(score)/\(Questions.count)"
        totalQuestion = Questions.count
    }
    func questionLevel37(){
        Questions = [Question(Question: "The Smallest living bird is ?", Answers: ["weebill","pardolate","bee hummingbird","Cisticola"], Answer: 2),
                     Question(Question: "The longest street in world is ?", Answers: ["Yonge street","Second street","First street","Wang street"], Answer: 0),
                     Question(Question: "Vitamin D come from ?", Answers: ["Sun","Fish","Supplements","Cholesterol"], Answer: 3),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2)]
        quizScoreLable.text = "\(score)/\(Questions.count)"
        totalQuestion = Questions.count
    }
    func questionLevel38(){
        Questions = [Question(Question: "The Smallest living bird is ?", Answers: ["weebill","pardolate","bee hummingbird","Cisticola"], Answer: 2),
                     Question(Question: "The longest street in world is ?", Answers: ["Yonge street","Second street","First street","Wang street"], Answer: 0),
                     Question(Question: "Vitamin D come from ?", Answers: ["Sun","Fish","Supplements","Cholesterol"], Answer: 3),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2)]
        quizScoreLable.text = "\(score)/\(Questions.count)"
        totalQuestion = Questions.count
    }
    func questionLevel39(){
        Questions = [Question(Question: "The Smallest living bird is ?", Answers: ["weebill","pardolate","bee hummingbird","Cisticola"], Answer: 2),
                     Question(Question: "The longest street in world is ?", Answers: ["Yonge street","Second street","First street","Wang street"], Answer: 0),
                     Question(Question: "Vitamin D come from ?", Answers: ["Sun","Fish","Supplements","Cholesterol"], Answer: 3),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2)]
        quizScoreLable.text = "\(score)/\(Questions.count)"
        totalQuestion = Questions.count
    }
    func questionLevel40(){
        Questions = [Question(Question: "The Smallest living bird is ?", Answers: ["weebill","pardolate","bee hummingbird","Cisticola"], Answer: 2),
                     Question(Question: "The longest street in world is ?", Answers: ["Yonge street","Second street","First street","Wang street"], Answer: 0),
                     Question(Question: "Vitamin D come from ?", Answers: ["Sun","Fish","Supplements","Cholesterol"], Answer: 3),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2)]
        quizScoreLable.text = "\(score)/\(Questions.count)"
        totalQuestion = Questions.count
    }
    func questionLevel41(){
        Questions = [Question(Question: "The Smallest living bird is ?", Answers: ["weebill","pardolate","bee hummingbird","Cisticola"], Answer: 2),
                     Question(Question: "The longest street in world is ?", Answers: ["Yonge street","Second street","First street","Wang street"], Answer: 0),
                     Question(Question: "Vitamin D come from ?", Answers: ["Sun","Fish","Supplements","Cholesterol"], Answer: 3),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2)]
        quizScoreLable.text = "\(score)/\(Questions.count)"
        totalQuestion = Questions.count
    }
    func questionLevel42(){
        Questions = [Question(Question: "The Smallest living bird is ?", Answers: ["weebill","pardolate","bee hummingbird","Cisticola"], Answer: 2),
                     Question(Question: "The longest street in world is ?", Answers: ["Yonge street","Second street","First street","Wang street"], Answer: 0),
                     Question(Question: "Vitamin D come from ?", Answers: ["Sun","Fish","Supplements","Cholesterol"], Answer: 3),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2)]
        quizScoreLable.text = "\(score)/\(Questions.count)"
        totalQuestion = Questions.count
    }
    func questionLevel43(){
        Questions = [Question(Question: "The Smallest living bird is ?", Answers: ["weebill","pardolate","bee hummingbird","Cisticola"], Answer: 2),
                     Question(Question: "The longest street in world is ?", Answers: ["Yonge street","Second street","First street","Wang street"], Answer: 0),
                     Question(Question: "Vitamin D come from ?", Answers: ["Sun","Fish","Supplements","Cholesterol"], Answer: 3),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2)]
        quizScoreLable.text = "\(score)/\(Questions.count)"
        totalQuestion = Questions.count
    }
    func questionLevel44(){
        Questions = [Question(Question: "The Smallest living bird is ?", Answers: ["weebill","pardolate","bee hummingbird","Cisticola"], Answer: 2),
                     Question(Question: "The longest street in world is ?", Answers: ["Yonge street","Second street","First street","Wang street"], Answer: 0),
                     Question(Question: "Vitamin D come from ?", Answers: ["Sun","Fish","Supplements","Cholesterol"], Answer: 3),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2)]
        quizScoreLable.text = "\(score)/\(Questions.count)"
        totalQuestion = Questions.count
    }
    func questionLevel45(){
        Questions = [Question(Question: "The Smallest living bird is ?", Answers: ["weebill","pardolate","bee hummingbird","Cisticola"], Answer: 2),
                     Question(Question: "The longest street in world is ?", Answers: ["Yonge street","Second street","First street","Wang street"], Answer: 0),
                     Question(Question: "Vitamin D come from ?", Answers: ["Sun","Fish","Supplements","Cholesterol"], Answer: 3),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2)]
        quizScoreLable.text = "\(score)/\(Questions.count)"
        totalQuestion = Questions.count
    }
    func questionLevel46(){
        Questions = [Question(Question: "The Smallest living bird is ?", Answers: ["weebill","pardolate","bee hummingbird","Cisticola"], Answer: 2),
                     Question(Question: "The longest street in world is ?", Answers: ["Yonge street","Second street","First street","Wang street"], Answer: 0),
                     Question(Question: "Vitamin D come from ?", Answers: ["Sun","Fish","Supplements","Cholesterol"], Answer: 3),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2)]
        quizScoreLable.text = "\(score)/\(Questions.count)"
        totalQuestion = Questions.count
    }
    func questionLevel47(){
        Questions = [Question(Question: "The Smallest living bird is ?", Answers: ["weebill","pardolate","bee hummingbird","Cisticola"], Answer: 2),
                     Question(Question: "The longest street in world is ?", Answers: ["Yonge street","Second street","First street","Wang street"], Answer: 0),
                     Question(Question: "Vitamin D come from ?", Answers: ["Sun","Fish","Supplements","Cholesterol"], Answer: 3),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2)]
        quizScoreLable.text = "\(score)/\(Questions.count)"
        totalQuestion = Questions.count
    }
    func questionLevel48(){
        Questions = [Question(Question: "The Smallest living bird is ?", Answers: ["weebill","pardolate","bee hummingbird","Cisticola"], Answer: 2),
                     Question(Question: "The longest street in world is ?", Answers: ["Yonge street","Second street","First street","Wang street"], Answer: 0),
                     Question(Question: "Vitamin D come from ?", Answers: ["Sun","Fish","Supplements","Cholesterol"], Answer: 3),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2)]
        quizScoreLable.text = "\(score)/\(Questions.count)"
        totalQuestion = Questions.count
    }
    func questionLevel49(){
        Questions = [Question(Question: "The Smallest living bird is ?", Answers: ["weebill","pardolate","bee hummingbird","Cisticola"], Answer: 2),
                     Question(Question: "The longest street in world is ?", Answers: ["Yonge street","Second street","First street","Wang street"], Answer: 0),
                     Question(Question: "Vitamin D come from ?", Answers: ["Sun","Fish","Supplements","Cholesterol"], Answer: 3),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2),
                     Question(Question: "What app is this", Answers: ["Game","Fact","Quiz","Golf"], Answer: 2)]
        quizScoreLable.text = "\(score)/\(Questions.count)"
        totalQuestion = Questions.count
    }
   
    

}
