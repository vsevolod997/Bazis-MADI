//
//  RaspisanieTableViewCell.swift
//  Bazis MADI
//
//  Created by Всеволод Андрющенко on 18.02.2020.
//  Copyright © 2020 Всеволод Андрющенко. All rights reserved.
//

import UIKit

class RaspisanieTableViewCell: UITableViewCell {

    @IBOutlet weak var dayAndDateLabel: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var typeAndGroupLabel: UILabel!
    @IBOutlet weak var rumNumLabel: UILabel!
    
    var objectData: DailyRaspisanieTeacher!  {
        didSet {
            time.text = objectData.time
            typeAndGroupLabel.text = objectData.typeLesson! + " " + objectData.group!
            rumNumLabel.text = objectData.room
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
