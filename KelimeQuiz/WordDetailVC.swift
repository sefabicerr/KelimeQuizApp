//
//  WordDetailVC.swift
//  KelimeQuiz
//
//  Created by Muhammed Sefa Biçer on 8.01.2022.
//

import UIKit

class WordDetailVC: UIViewController {

    @IBOutlet weak var englishTextField: UITextField!
    @IBOutlet weak var turkishTextField: UITextField!
    
    var word:Words?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let inComingWord = word {
            
            englishTextField.text = inComingWord.english
            turkishTextField.text = inComingWord.turkish
        }  
    }
    

    @IBAction func updateButton(_ sender: Any) {
        
        if let inComingWord = word, let english = englishTextField.text, let turkish = turkishTextField.text {
            
            WordsDao().wordUpdate(word_id: inComingWord.word_id, english: english, turkish: turkish)
            
        }
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    
}
