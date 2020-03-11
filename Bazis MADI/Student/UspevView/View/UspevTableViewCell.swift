//
//  UspevTableViewCell.swift
//  Bazis MADI
//
//  Created by Всеволод Андрющенко on 21.01.2020.
//  Copyright © 2020 Всеволод Андрющенко. All rights reserved.
//

import UIKit

//MARK: - ячейка отображения расписания
class UspevTableViewCell: UITableViewCell {

    @IBOutlet weak var hourLabel: TitleT1WLabelUILabel!
    @IBOutlet weak var dateLabel: TitleT1WLabelUILabel!
    @IBOutlet weak var unameLabel: Title3LabelUILabel!
    @IBOutlet weak var typeLabel: Title5LabelUILabel!
    @IBOutlet weak var markLabel: Title5LabelUILabel!
    
    @IBOutlet weak var backgroundVIew: UIView!
    @IBOutlet weak var viewTop: UIView!
    @IBOutlet weak var viewBottom: UIView!
    
    var data: UspevModel! {
        didSet {
            
            viewBottom.alpha = 0
            viewTop.alpha = 0.8
            
            if let obj = data {
                if let hour = obj.hour {
                    if hour != "" {
                        hourLabel.text = "Часы: " + hour
                    } else {
                        hourLabel.text = "Часы: -"
                    }
                }
                if let mark = obj.ocenka {
                    if mark != "" {
                        if mark == "+" {
                            markLabel.text = "Оценка: Зачтено "
                        } else {
                            markLabel.text = "Оценка: " + mark
                        }
                    } else {
                        markLabel.text = "Оценка: -"
                    }
                }
                if let date = obj.date {
                    if date != "" {
                        dateLabel.text = "Дата: " + date
                    } else {
                        hourLabel.text = "Дата: -"
                    }
                }
                typeLabel.text = obj.vid + " (сем. \(obj.sem))"
                unameLabel.text = obj.disc
            }
        }
    }
   
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundView?.backgroundColor = SystemColor.blueColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    public func showFull(isShow: Bool) {
        if isShow {
            viewBottom.alpha = 0.8
            viewTop.alpha = 0.0
        } else {
            viewBottom.alpha = 0.0
            viewTop.alpha = 0.8
        }
    }
}
