//
//  ViewController.swift
//  KelimeQuiz
//
//  Created by Muhammed Sefa Biçer on 29.12.2021.
//

import UIKit

class ViewController: UIViewController {
    
    
    var wordList = [Words]()
    var list = [Words]()
    

    @IBOutlet weak var listTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        listTableView.delegate = self
        listTableView.dataSource = self
        
        veriTabaniKopyala()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        wordList = WordsDao().getWord()
        listTableView.reloadData()
        
    }
    
    
    //Perform Segueden gelen index ile detailVC'ye veri aktarımı
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toDetail" {
            
            let indeks = sender as! Int
            let goToVC = segue.destination as? WordDetailVC
            goToVC?.word = wordList[indeks]
        }
    }
    
    //Veri tabanından çekilenler dışında extra kelime eklemek
    @IBAction func addWord(_ sender: Any) {
        
        let alertController = UIAlertController(title: "Kelime Ekle", message: "Eklemek istediğiniz kelimeyi giriniz.", preferredStyle: .alert)
        
            alertController.addTextField{ textfield in
                textfield.placeholder = "İngilizce"
        
                alertController.addTextField{ textfield in
                    textfield.placeholder = "Türkçe"
                }
            }
        
        
        let saveButton = UIAlertAction(title: "Kaydet", style: .default) { action in
            print("Kaydet tıklandı")
        
            if let english = (alertController.textFields![0] as UITextField).text, let turkish = (alertController.textFields![1] as UITextField).text{
            
                WordsDao().addWord(ingilizce: english, türkçe: turkish)
                self.wordList = WordsDao().getWord()
                self.listTableView.reloadData()
            }
        }
        
        alertController.addAction(saveButton)
        
        let cancelButton = UIAlertAction(title: "İptal", style: .cancel) { action in
            print("İptal tıklandı")
        }
        
        alertController.addAction(cancelButton)
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    
    //Veritabanından random 2 kelime getiren barButtonItem
    @IBAction func getWord(_ sender: Any) {
        
        
        let alertController = UIAlertController(title: "Uyarı", message: "Ezberlemen için listene 2 kelime eklenecek, onaylıyor musun ?", preferredStyle: .alert)
            
        alertController.addAction(UIAlertAction(title: "Evet", style: .default, handler: { (action:UIAlertAction!) in
            
            self.list = WordsDao().getRandomWords()

            for x in 0...self.list.count-1{
                
                if self.list.count != 0{
                            
                    WordsDao().deleteFromKelimelerTable(word_id: self.list[x].word_id)
                       
                }
            }
            
            for i in 0...self.list.count-1{
                
                WordsDao().addWord(ingilizce: self.list[i].english, türkçe: self.list[i].turkish)
                self.wordList = WordsDao().getWord()
                self.listTableView.reloadData()
            }
            self.list = []
            
        }))
        
        alertController.addAction(UIAlertAction(title: "Hayır", style: .cancel, handler: { (action:UIAlertAction!) in
            
        }))
        
        self.present(alertController, animated: true, completion: nil)
            
    }
    
    
    
    //veri tabanının cihaza kopyalanması
    func veriTabaniKopyala(){
        
        let bundleYolu = Bundle.main.path(forResource: "sozluk", ofType: ".sqlite")
        let hedefYol = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let fileManager = FileManager.default
        let kopyalanacakYer = URL(fileURLWithPath: hedefYol).appendingPathComponent("sozluk.sqlite")
        
        if fileManager.fileExists(atPath: kopyalanacakYer.path){
            print("veri tabanı zaten var")
        }else{
            do {
                try fileManager.copyItem(atPath: bundleYolu!, toPath: kopyalanacakYer.path)
            } catch {
                print(error)
            }
        }
    }
}


//Gerekli tableview fonksiyonları, delete ve ezberledim  swipe actionları için gerekli fonksiyonlar
extension ViewController: UITableViewDelegate,UITableViewDataSource{
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return wordList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let word = wordList[indexPath.row]
        let cell = listTableView.dequeueReusableCell(withIdentifier: "wordCell", for: indexPath) as! ListTableViewCell
        cell.labelEnglish.text = word.english
        cell.labelTurkish.text = word.turkish
    
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "toDetail", sender: indexPath.row)
           
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let word = wordList[indexPath.row]
        let memorizeAction = UIContextualAction(style: .normal, title: "Ezberledim") { contextualAction, view, boolValue in
            
            let alertController = UIAlertController(title: "Uyarı", message: "Ezberlenen kelimelere eklemek istediğinize emin misiniz ?", preferredStyle: .alert)
            
            alertController.addAction(UIAlertAction(title: "Ekle", style: .default, handler: {
                (action:UIAlertAction) in
                
                MemorizedWordDao().addWordFromEzberlenenTable(english: word.english, turkish: word.turkish)
                WordsDao().deleteWord(word_id: word.word_id)
                
                self.wordList = WordsDao().getWord()
                self.listTableView.reloadData()
            }))
            
            
            alertController.addAction(UIAlertAction(title: "İptal", style: .cancel, handler: { (action:UIAlertAction!) in
            }))
            
            self.present(alertController, animated: true, completion: nil)
    
        }
        
        
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Sil") { contextualAction,view, boolValue in
                
                let word = self.wordList[indexPath.row]
                WordsDao().addWordFromKelimelerTable(ingilizce: word.english, turkce: word.turkish)
                WordsDao().deleteWord(word_id: word.word_id)
               
                self.wordList = WordsDao().getWord()
                self.listTableView.reloadData()
            }
        return UISwipeActionsConfiguration(actions: [memorizeAction,deleteAction])
    }
}

