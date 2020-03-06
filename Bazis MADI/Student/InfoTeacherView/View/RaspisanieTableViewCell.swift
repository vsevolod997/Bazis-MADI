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
            if objectData.time != "" {
                 time.text = objectData.time
            } else {
                time.text = "-"
            }
            
            if let type = objectData.typeLesson {
                if SystemDevice().isNormalDevice {
                    let buf = type.split(separator: "/")
                    typeAndGroupLabel.text = String(buf[0])
                } else {
                    let buf = type.split(separator: " ")
                    typeAndGroupLabel.text = String(buf[0])
                }
            } else {
                typeAndGroupLabel.text = "Не установленно"
            }
            if objectData.room != "" {
                 rumNumLabel.text = objectData.room
            } else {
                rumNumLabel.text = "нет данных"
            }
            
            var typeAndGroup = ""
            if objectData.typeWeek != "" {
                typeAndGroup += objectData.typeWeek
            }
            if objectData.group != "" {
                typeAndGroup += ", " + objectData.group!
            }
            
            
            dayAndDateLabel.text = typeAndGroup
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
