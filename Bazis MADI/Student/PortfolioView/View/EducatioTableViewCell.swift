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
            
            if educationData[0]! != "" {
                yearString += educationData[0]!
            }
            if educationData[1]! != "" {
                yearString += " - " + educationData[1]!
            }
            dateLabel.text = yearString
            
            if educationData[2]! != "" {
                nameLabel.text = educationData[2]
            } else {
                nameLabel.text = "Не указано"
            }
            
            if educationData[3]! != "" {
                typeLabel.text = educationData[3]
            } else{
                typeLabel.text = "Не указано"
            }
            
            if educationData[4]! != "" {
                typeLabel.text = educationData[4]
            } else{
                typeLabel.text = "Не указано"
            }
            
            if educationData[5] != "да" {
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
