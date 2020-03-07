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
            if let buff = dataWork[3] {
                if buff != "" {
                    name += buff
                }
            }
            
            if let buff2 = dataWork[2] {
                if buff2 != "" {
                    name += ", " + buff2
                }
            }
            
            sityAndNameLabel.text = name
            
            if let buff3 = dataWork[0] {
                if buff3 != "" {
                    dateLabel.text = buff3
                } else {
                    dateLabel.text = "_"
                }
            } else {
                dateLabel.text = "_"
            }
            
            if let buff4 = dataWork[1] {
                if buff4 != "" {
                    dateEndLabel.text = buff4
                } else {
                    dateEndLabel.text = "_"
                }
            } else {
                dateEndLabel.text = "_"
            }
            
            if let buff5 = dataWork[4] {
                if buff5 != "" {
                    typeLabel.text = buff5
                } else {
                    typeLabel.text = "Не указано"
                }
            } else {
                 typeLabel.text = "Не указано"
            }
            
            if let buff6 = dataWork[5] {
                if buff6 != "" {
                     dolzLabel.text = buff6
                 } else {
                     dolzLabel.text = "Не указано"
                 }
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
