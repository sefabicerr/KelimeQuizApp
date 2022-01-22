//
//  MemorizedWordsVC.swift
//  KelimeQuiz
//
//  Created by Muhammed Sefa Biçer on 9.01.2022.
//

import UIKit

class MemorizedWordsVC: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var memorizedWordsTableView: UITableView!
    var memorizedWordList = [Words]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        memorizedWordsTableView.delegate = self
        memorizedWordsTableView.dataSource = self
   
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        memorizedWordList = MemorizedWordDao().getWordFromEzberlenenTable()
        memorizedWordsTableView.reloadData()
        
    }
}


//Sil swipe action'ın,search bar'ın ve tableview diğer fonksiyonları
extension MemorizedWordsVC:UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        memorizedWordList = MemorizedWordDao().search(english: searchText)
        memorizedWordsTableView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memorizedWordList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let word = memorizedWordList[indexPath.row]
        let cell = memorizedWordsTableView.dequeueReusableCell(withIdentifier: "memorizedCell", for: indexPath) as! MemorizedWordsTableViewCell
        cell.labelEnglish.text = word.english
        cell.labelTurkish.text = word.turkish
    
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Sil") { contextualAction,view, boolValue in
                
                let word = self.memorizedWordList[indexPath.row]
                WordsDao().addWord(ingilizce: word.english, türkçe: word.turkish)
                MemorizedWordDao().deleteWordFromEzberlenenTable(word_id: word.word_id)
               
                self.memorizedWordList = MemorizedWordDao().getWordFromEzberlenenTable()
                self.memorizedWordsTableView.reloadData()
            }

        return UISwipeActionsConfiguration(actions: [deleteAction])  
        
    }
    
}

