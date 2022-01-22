//
//  MemorizedWordsDao.swift
//  KelimeQuiz
//
//  Created by Muhammed Sefa Biçer on 9.01.2022.
//

import Foundation


class MemorizedWordDao {
    
    var db:FMDatabase?
    
    init() {
        
        let hedefYol = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let veriTabaniUrl = URL(fileURLWithPath: hedefYol).appendingPathComponent("sozluk.sqlite")
        
        db = FMDatabase(path: veriTabaniUrl.path)
    }
    
    
    
    func getWordFromEzberlenenTable() -> [Words] {
        
        var list = [Words]()
        
        db?.open()
        
        do {
            
            let rs = try db!.executeQuery("SELECT * FROM ezberlenenKelimeler", values: nil)
             
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
    
    
    func addWordFromEzberlenenTable(english:String,turkish:String) {
        
        db?.open()
        
        do{
            try db!.executeUpdate("INSERT INTO ezberlenenKelimeler (ingilizce,turkce) VALUES (?,?)", values: [english,turkish])
        }catch{
            print(error.localizedDescription)
        }
        db?.close()
    }
    
    
    //ezberlenen kelimeler tablosundan veriyi sil
    func deleteWordFromEzberlenenTable(word_id:Int){
        
        db?.open()
        
        do {
            try db?.executeUpdate("DELETE FROM ezberlenenKelimeler WHERE kelime_id = ?", values: [word_id])
        } catch  {
            print(error.localizedDescription)
        }
        
        db?.close()
        
    }
    
    
    
    func search(english:String) -> [Words]{
        
        var list = [Words]()
        
        db?.open()
        
        do {
            let rs = try db!.executeQuery("SELECT * FROM ezberlenenKelimeler WHERE ingilizce like '%\(english)%'", values: nil)
            
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
    
    
    
    func randomlyGetForty() -> [Words]{
        
        var list = [Words]()
        
        db?.open()
        
        do {
            let rs = try db!.executeQuery("SELECT * FROM ezberlenenKelimeler ORDER BY RANDOM() LIMIT 40", values: nil)
            
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
    

    
    func randomlyGetThreeWrong(word_id:Int) -> [Words]{
        
        var list = [Words]()
        
        db?.open()
        
        do {
            let rs = try db!.executeQuery("SELECT * FROM ezberlenenKelimeler WHERE kelime_id != ? ORDER BY RANDOM() LIMIT 3", values: [word_id])
            
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
