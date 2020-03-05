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
            sityAndNameLabel.text = dataWork[3]! + ", " + dataWork[2]!
            dateLabel.text = dataWork[0]! + " - "
            dateEndLabel.text = dataWork[1]
            typeLabel.text = dataWork[4]
            dolzLabel.text = dataWork[5]
            
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
