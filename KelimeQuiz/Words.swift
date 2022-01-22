//
//  Words.swift
//  KelimeQuiz
//
//  Created by Muhammed Sefa Biçer on 8.01.2022.
//

import Foundation

class Words:Equatable,Hashable{
    
    var word_id:Int
    var english:String
    var turkish:String
    
    
    init(word_id:Int,english:String,turkish:String){
        
        self.word_id = word_id
        self.english = english
        self.turkish = turkish
        
    }
    
    var hashValue: Int{
        get {
            return word_id.hashValue
        }
    }
    
    static func == (lhs: Words,rhs:Words) -> Bool{
        return(lhs.word_id == rhs.word_id)
    }
    
    
     
    
}
