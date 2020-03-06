//
//  WorkTableViewCell.swift
//  Bazis MADI
//
//  Created by Всеволод Андрющенко on 03.03.2020.
//  Copyright © 2020 Всеволод Андрющенко. All rights reserved.
//

import UIKit

class WorkTableViewCell: UITableViewCell {

    @IBOutlet weak var dateEndLabel: Title5LabelUILabel!
    @IBOutlet weak var sityAndNameLabel: Title4LabelUILabel!
    @IBOutlet weak var dateLabel: Title5LabelUILabel!
    @IBOutlet weak var typeLabel: Title3LabelUILabel!
    @IBOutlet weak var dolzLabel: Title3LabelUILabel!
    @IBOutlet weak var isPrintImage: UIImageView!
    
    var dataWork: [String?]! {
        didSet {
            var name = ""
            
            if dataWork[3]! != "" {
                name += dataWork[3]!
            }
            if dataWork[2]! != "" {
                name += ", " + dataWork[2]!
            }
            sityAndNameLabel.text = name
            
            if dataWork[0]! != "" {
                dateLabel.text = dataWork[0]! + ""
            } else {
                dateLabel.text = "_"
            }
            
            if dataWork[1]! != "" {
                dateEndLabel.text = dataWork[1]!
            } else {
                dateEndLabel.text = "_"
            }
            
            if dataWork[4]! != "" {
                dateEndLabel.text = dataWork[4]!
            } else {
                dateEndLabel.text = "Не указано"
            }
            
            if dataWork[5]! != "" {
                dolzLabel.text = dataWork[5]
            } else {
                dolzLabel.text = "Не указано"
            }
            
            if dataWork[6] == "да" {
                let img = UIImage(named: "okPsw")
                isPrintImage.image = img
            } else {
                let img = UIImage(named: "errPsw")
                isPrintImage.image = img
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
 
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
