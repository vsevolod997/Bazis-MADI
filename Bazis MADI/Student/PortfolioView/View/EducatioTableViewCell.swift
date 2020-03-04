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
    @IBOutlet weak var printSwich: UISwitch!
    
    
    var educationData: [String?]! {
        didSet {
            dateLabel.text = educationData[0]! + " - " + educationData[1]!
            nameLabel.text = educationData[2]
            typeLabel.text = educationData[3]
            specialLabel.text = educationData[4]
            if educationData[5] == "да" {
                printSwich.isOn = true
            } else {
                printSwich.isOn = false
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
