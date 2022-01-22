//
//  ListTableViewCell.swift
//  KelimeQuiz
//
//  Created by Muhammed Sefa Biçer on 7.01.2022.
//

import UIKit

class ListTableViewCell: UITableViewCell {
    @IBOutlet weak var labelEnglish: UILabel!
    @IBOutlet weak var labelTurkish: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
