//
//  ObjectRspByGroupTableViewCell.swift
//  Bazis MADI
//
//  Created by Всеволод Андрющенко on 29.02.2020.
//  Copyright © 2020 Всеволод Андрющенко. All rights reserved.
//

import UIKit

class ObjectRspByGroupTableViewCell: UITableViewCell {
    
    @IBOutlet weak var teacherNameLabel: Title2LabelUILabel!
    @IBOutlet weak var timeLabel: Title3LabelUILabel!
    @IBOutlet weak var dayAndLabel: Title5LabelUILabel!
    @IBOutlet weak var teacherLabel: Title3LabelUILabel!
    @IBOutlet weak var numLabel: Title3LabelUILabel!
    
    var objectData: DailyRaspisanie! {
        didSet {
            
            if objectData.time != "" {
                timeLabel.text = objectData.time
            } else {
                 timeLabel.text = "-"
            }
            
            var typeAndName = ""
            if objectData.typeWeek != "" {
                typeAndName += objectData.typeWeek
            }
            if objectData.name != "" {
                typeAndName += ", " + objectData.name
            }
            dayAndLabel.text = typeAndName
            
            if let room = objectData.room {
                if room == "" {
                    numLabel.text = " - "
                } else {
                    numLabel.text = room
                }
            }
            guard let buff = objectData.typeLesson?.split(separator: " ") else { return }
            teacherLabel.text = String(buff[0])
            if let teacherName = objectData.teacher {
                if teacherName == "" {
                    teacherNameLabel.text = "Преподаватель: -"
                } else {
                    teacherNameLabel.text = "Преподаватель: " + teacherName
                }
            } else {
                teacherNameLabel.text = "Преподаватель: -"
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
