//
//  QuizQuestionsVC.swift
//  KelimeQuiz
//
//  Created by Muhammed Sefa Biçer on 10.01.2022.
//

import UIKit

class QuizQuestionsVC: UIViewController {
    
    var control:Bool?
    var wordList = [Words]()
    @IBOutlet weak var trueCounterLabel: UILabel!
    @IBOutlet weak var falseCounterLabel: UILabel!
    @IBOutlet weak var wordLabel: UILabel!
    @IBOutlet weak var buttonA: UIButton!
    @IBOutlet weak var buttonB: UIButton!
    @IBOutlet weak var buttonC: UIButton!
    @IBOutlet weak var buttonD: UIButton!
    
    var questions = [Words]()
    var wrongChoices = [Words]()
    var trueQuestion:Words?
    let delay = 1.0
    
    var trueCounter = 0
    var falseCounter = 0
    var questionCounter = 0
    var choices = [Words]()
    var choicesMixList = Set <Words>()
    let d = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if control == true{
            
            wordList = WordsDao().getWord()
            questions = WordsDao().randomlyGetForty()

        }else{
            wordList = MemorizedWordDao().getWordFromEzberlenenTable()
            questions = MemorizedWordDao().randomlyGetForty()
        }
        
        questionUpload()
    }
    
    
    //kelimeyi,kelimenin doğru cevabını ve rastgele 3 yanlış şık getirme
    func questionUpload(){
        
        trueQuestion = questions[questionCounter]
        wordLabel.text = trueQuestion?.english
        
        if control == true {
            wrongChoices = WordsDao().randomlyGetThreeWrong(word_id: trueQuestion!.word_id)
        }else{
            wrongChoices = MemorizedWordDao().randomlyGetThreeWrong(word_id: trueQuestion!.word_id)
        }
        
        choicesMixList.removeAll()
        
        choicesMixList.insert(trueQuestion!)
        choicesMixList.insert(wrongChoices[0])
        choicesMixList.insert(wrongChoices[1])
        choicesMixList.insert(wrongChoices[2])
        
        choices.removeAll()
        
        for s in choicesMixList{
            choices.append(s)
        }
        
        buttonA.setTitle(choices[0].turkish, for: .normal)
        buttonB.setTitle(choices[1].turkish, for: .normal)
        buttonC.setTitle(choices[2].turkish, for: .normal)
        buttonD.setTitle(choices[3].turkish, for: .normal)
        
    }
    
    
    //verilen cevabın doğruluğunun kontrolü ve doğru-yanlış göstergelerinin değişimi
    func trueControl(button: UIButton){
        
        let buttonText = button.titleLabel?.text
        let trueQuest = trueQuestion?.turkish
        
        print("Button yazı : \(buttonText!) ")
        print("Doğru cevap : \(trueQuest!)")
        
        if trueQuest == buttonText{
            button.backgroundColor = .green
            trueCounter+=1
        
        }else{
            button.backgroundColor = .red
            
            falseCounter+=1

        }
        
        trueCounterLabel.text = "Doğru: \(trueCounter)"
        falseCounterLabel.text = "Yanlış: \(falseCounter)"
        
    }
    
    func questionCounterKontrol(){
        
        let wordCounter = d.integer(forKey: "wordCounter")
        questionCounter+=1
        
        if questionCounter != wordCounter && questionCounter != wordList.count {
            questionUpload()
        }else{
            navigationController?.popToRootViewController(animated: true)
            
        }
    }
    
    
   
    @IBAction func buttonA(_ sender: Any) {
        
        trueControl(button: buttonA)
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            self.buttonA.backgroundColor = .systemBrown
            self.questionCounterKontrol()
        }
        
        
    }
    
    @IBAction func buttonB(_ sender: Any) {
        
        trueControl(button: buttonB)
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            self.buttonB.backgroundColor = .systemBrown
            self.questionCounterKontrol()
        }
        
        
    }
    
    @IBAction func buttonC(_ sender: Any) {
        
        trueControl(button: buttonC)
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            self.buttonC.backgroundColor = .systemBrown
            self.questionCounterKontrol()
        }
       
        
    }
    
    @IBAction func buttonD(_ sender: Any) {
        
        trueControl(button: buttonD)
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            self.buttonD.backgroundColor = .systemBrown
            self.questionCounterKontrol()
        }
        
        
    }
}
