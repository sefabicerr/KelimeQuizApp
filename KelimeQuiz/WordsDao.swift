//
//  WordsDao.swift
//  KelimeQuiz
//
//  Created by Muhammed Sefa Biçer on 8.01.2022.
//

import Foundation

class WordsDao {
    
    var db:FMDatabase?
    
    init() {
        
        let hedefYol = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let veriTabaniUrl = URL(fileURLWithPath: hedefYol).appendingPathComponent("sozluk.sqlite")
        
        db = FMDatabase(path: veriTabaniUrl.path)
        
    }
    
    //kelimeler tablosundan random kelime
    func getRandomWords() -> [Words] {
        
        var list = [Words]()
        
        db?.open()
        
        do {
            
            let rs = try db!.executeQuery("SELECT * FROM kelimeler ORDER BY RANDOM() LIMIT 2", values: nil)
             
            while rs.next() {
                
                let word = Words(word_id: Int(rs.string(forColumn: "kelime_id"))!,
                                 english: rs.string(forColumn: "ingilizce")!,
                                 turkish: rs.string(forColumn: "turkce")!)
                
                list.append(word)
                
            }
        }catch {
            print(error.localizedDescription)
        }
        
        db?.close()

        return list
    }
    
    
    
    //extra kelime ekleme
    func addWordFromKelimelerTable(ingilizce:String,turkce:String){
        
        db?.open()
        
        do {
            try db!.executeUpdate("INSERT INTO kelimeler (ingilizce,turkce) VALUES (?,?)", values: [ingilizce,turkce])
        } catch  {
            print(error.localizedDescription)
        }

        db?.close()
    }
    
    
    //random çekilip cekilenKelimeler tablosuna atılan verileri çek
    func getWord() -> [Words]{
        
        var list = [Words]()
        
        db?.open()
        
        do {
            let rs = try db!.executeQuery("SELECT * FROM cekilenKelimeler", values: nil)
            
            while rs.next() {
                
                let word = Words(
                                         word_id: Int(rs.string(forColumn: "kelime_id"))!
                                       , english: rs.string(forColumn: "ingilizce")!
                                       , turkish: rs.string(forColumn: "turkce")!)
                
                list.append(word)
            }
            
        } catch  {
            print(error.localizedDescription)
        }
        
        db?.close()
        return list
    }
    
    
    //çekilen kelimeler tablosuna kelimeyi ekle
    func addWord(ingilizce:String,türkçe:String) {
        
        db?.open()
        
        do{
            try db!.executeUpdate("INSERT INTO cekilenKelimeler (ingilizce,turkce) VALUES (?,?)", values: [ingilizce,türkçe])
        }catch{
            print(error.localizedDescription)
        }
        db?.close()
    }
    
    
    //çekilen kelimeler tablosundan veriyi sil
    func deleteWord(word_id:Int){
        
        db?.open()
        
        do {
            try db?.executeUpdate("DELETE FROM cekilenKelimeler WHERE kelime_id = ?", values: [word_id])
        } catch  {
            print(error.localizedDescription)
        }
        
        db?.close()
        
    }
    
    
    //kelimeler tablosundan veriyi sil
    func deleteFromKelimelerTable(word_id:Int){
        
        db?.open()
        
        do{
            try db?.executeUpdate("DELETE FROM kelimeler WHERE kelime_id = ?", values: [word_id])
        }catch{
            print(error.localizedDescription)
        }
        db?.close()
        
    }
    
    //Detayına girilen kelimeyi güncelle
    func wordUpdate(word_id:Int,english:String,turkish:String){
        
        db?.open()
        
        do {
            try db?.executeUpdate("UPDATE cekilenKelimeler SET ingilizce = ?, turkce = ? WHERE kelime_id = ?", values: [english,turkish,word_id])
        } catch  {
            print(error.localizedDescription)
        }
        
        db?.close()
        
    }
    
    
    //cekilenler tablosundan rastgele max40 kelime çeker
    func randomlyGetForty() -> [Words]{
        
        var list = [Words]()
        
        db?.open()
        
        do {
            let rs = try db!.executeQuery("SELECT * FROM cekilenKelimeler ORDER BY RANDOM() LIMIT 40", values: nil)
            
            while rs.next(){
                
                let word = Words(word_id: Int(rs.string(forColumn: "kelime_id"))!, english: rs.string(forColumn: "ingilizce")!, turkish: rs.string(forColumn: "turkce")!)
                list.append(word)
            }
        } catch  {
            print(error.localizedDescription)
        }

        db?.close()
        return list
    }
    

    //question upload fonksiyonuna gönderilecek 3 yanlış seneçenek için
    func randomlyGetThreeWrong(word_id:Int) -> [Words]{
        
        var list = [Words]()
        
        db?.open()
        
        do {
            let rs = try db!.executeQuery("SELECT * FROM cekilenKelimeler WHERE kelime_id != ? ORDER BY RANDOM() LIMIT 3", values: [word_id])
            
            while rs.next(){
                
                let word = Words(word_id: Int(rs.string(forColumn: "kelime_id"))!, english: rs.string(forColumn: "ingilizce")!, turkish: rs.string(forColumn: "turkce")!)
                list.append(word)
            }
        } catch  {
            print(error.localizedDescription)
        }

        db?.close()
        return list
    }
}
