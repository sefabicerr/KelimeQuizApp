//
//  QuizVC.swift
//  KelimeQuiz
//
//  Created by Muhammed Sefa Biçer on 10.01.2022.
//

import UIKit

class QuizVC: UIViewController, UIPickerViewDelegate,UIPickerViewDataSource {

   
    @IBOutlet weak var totalNumberLabel: UILabel!
    let d = UserDefaults.standard
    var numberOfWord = 1
    var chosenPicker : Int?
    var choices = [4,6,8,10,12,14,16,18,20,22,24]
    var pickerView = UIPickerView()
    var typeValue = 1
    var wordList = [Words]()
    var trueCount : Int?
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
     
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        //Ezberlenen toplam kelime sayısını gösterir
        let numberOfMemorized = MemorizedWordDao().getWordFromEzberlenenTable()
        totalNumberLabel.text = "Ezberlenen Kelime Sayısı: \(numberOfMemorized.count)"
    }
    
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
     
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return choices.count
    }
        
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(choices[row])
    }
        
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if row == 0 {
            typeValue = 4
        } else if row == 1  {
            typeValue = 6
        } else if row == 2 {
            typeValue = 8
        } else if row == 3 {
            typeValue = 10
        } else if row == 4 {
            typeValue = 12
        } else if row == 5 {
            typeValue = 14
        } else if row == 6 {
            typeValue = 16
        } else if row == 7 {
            typeValue = 18
        } else if row == 8 {
            typeValue = 20
        } else if row == 9 {
            typeValue = 22
        }
    }
    
    // Hangi quiz butonuna basıldığını algılamak için questionVC'ye gönderilen control bilgisi için geçiş
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "startToQuiz"{
            if let control = sender as? Bool {
                let destinationVC = segue.destination as! QuizQuestionsVC
                destinationVC.control = control
            }
        }
    }
    
    
    @IBAction func newWordsQuiz(_ sender: Any) {
        
        wordList = WordsDao().getWord()
        wordListControl()
        let buttonControl = true
        performSegue(withIdentifier: "startToQuiz", sender: buttonControl)
    }
    
    @IBAction func memorizedWordsQuiz(_ sender: Any) {
        
        wordList = MemorizedWordDao().getWordFromEzberlenenTable()
        wordListControl()
        let buttonControl = false
        performSegue(withIdentifier: "startToQuiz", sender: buttonControl)
    }
    
    
    //quiz'de gösterilecek olan kelime sayısını ayarlama 
    @IBAction func settingsButton(_ sender: Any) {
        
        
        let alert = UIAlertController(title: "Soru Sayısı", message: "\n\n\n\n\n\n", preferredStyle: .alert)
        alert.isModalInPopover = true
        
        let pickerFrame = UIPickerView(frame: CGRect(x: 5, y: 20, width: 250, height: 140))
        
        alert.view.addSubview(pickerFrame)
        pickerFrame.dataSource = self
        pickerFrame.delegate = self
        
        alert.addAction(UIAlertAction(title: "İptal", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Tamam", style: .default, handler: { (UIAlertAction) in
            
            self.d.set(self.typeValue, forKey: "wordCounter")
              
        }))
        self.present(alert,animated: true, completion: nil )
        
            
        alert.addTextField { textfield in
            let x = self.d.integer(forKey: "wordCounter")
            textfield.text = "Son değer: \(x)"
            textfield.isEnabled = false
            
        }
    }
    

    //Anasayfada ya da ezberlenen kelimelerde kelime yoksa quizi ekranında uyarı verir
    func wordListControl(){
        
        if wordList.count <= 3 {
            
            let alertController = UIAlertController(title: "Uyarı", message: "Quize başlamak için kelime listenizde en az 4 kelime bulunmalı.", preferredStyle: .actionSheet)
            let okAction = UIAlertAction(title: "Tamam", style: .default) { action in
                
            }
            
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
}
        


    

