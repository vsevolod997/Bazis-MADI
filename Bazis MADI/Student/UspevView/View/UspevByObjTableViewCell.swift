//
//  UspevByObjTableViewCell.swift
//  Bazis MADI
//
//  Created by Всеволод Андрющенко on 31.01.2020.
//  Copyright © 2020 Всеволод Андрющенко. All rights reserved.
//

import UIKit

class UspevByObjTableViewCell: UITableViewCell {

    @IBOutlet weak var markLabel: Title5LabelUILabel!
    @IBOutlet weak var typeLabel: Title5LabelUILabel!
    @IBOutlet weak var dateLabel: TitleT1WLabelUILabel!
    @IBOutlet weak var hourLabel: TitleT1WLabelUILabel!
    
    @IBOutlet weak var topView: UIView!
    
    @IBOutlet weak var botomView: UIView!
    
    var data: UspevModel! {
        didSet {
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
                typeLabel.text = obj.vid  + " (сем. \(obj.sem))"
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        botomView.alpha = 0.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    public func showFull(isShow: Bool) {
        if isShow {
            topView.alpha = 0.0
            botomView.alpha = 0.8
        } else {
            topView.alpha = 0.8
            botomView.alpha = 0.0
        }
    }

}
