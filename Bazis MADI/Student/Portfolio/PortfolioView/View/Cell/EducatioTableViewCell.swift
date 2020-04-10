//
//  EducatioTableViewCell.swift
//  Bazis MADI
//
//  Created by Всеволод Андрющенко on 03.03.2020.
//  Copyright © 2020 Всеволод Андрющенко. All rights reserved.
//

import UIKit

class EducatioTableViewCell: UITableViewCell {

    @IBOutlet weak var specialLabel: Title3LabelUILabel!
    @IBOutlet weak var dateLabel: Title5LabelUILabel!
    @IBOutlet weak var nameLabel: Title4LabelUILabel!
    @IBOutlet weak var typeLabel: Title3LabelUILabel!
    @IBOutlet weak var isPrintImage: UIImageView!
    
    
    var educationData: [String?]! {
        didSet {
            var yearString: String = ""
            
            if let yearStart = educationData[0] {
                if yearStart != "" {
                    yearString += yearStart
                } else {
                     yearString += "_"
                }
            } else {
                yearString += "_"
            }
            
            if let yearsEnd = educationData[1] {
                if yearsEnd != "" {
                    yearString += " - " + yearsEnd
                }
            } else {
                yearString += "- _"
            }
            dateLabel.text = yearString
            
            
            if let name = educationData[2] {
                if name != "" {
                    nameLabel.text = name
                } else {
                    nameLabel.text = "Не указано"
                }
            } else {
                nameLabel.text = "Не указано"
            }
            
            if let type = educationData[3] {
                if type != "" {
                    typeLabel.text = type
                } else {
                    typeLabel.text = "Не указано"
                }
            } else {
                 typeLabel.text = "Не указано"
            }
            
            if let spec = educationData[4] {
                if spec != "" {
                    specialLabel.text = spec
                } else {
                    specialLabel.text = "Не указано"
                }
            }
            
            if educationData[5] == "да" {
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
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
