//
//  ClassesUIView.swift
//  Bazis MADI
//
//  Created by Всеволод Андрющенко on 28.12.2019.
//  Copyright © 2019 Всеволод Андрющенко. All rights reserved.
//

import UIKit

class ClassesUIView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    //MARK: - отображение данных по паре
    public func setupDate(dailyRasp: DailyRaspisanie) {
        
        let nameLabel = Title2LabelUILabel()
        nameLabel.textAlignment = .center
        nameLabel.text = dailyRasp.name
        nameLabel.numberOfLines = 2
        let labelX = 55.0
        let widthName = self.frame.width - 120.0
        nameLabel.frame = CGRect(x:labelX , y: 0.0, width: Double(widthName), height: 40.0)
        
        self.addSubview(nameLabel)
        
        let timeLabel = Title3LabelUILabel()
        timeLabel.text = dailyRasp.time
        timeLabel.numberOfLines = 2
        timeLabel.frame = CGRect(x: 0.0, y: 0, width: 50, height: self.frame.height - 20)
        
        self.addSubview(timeLabel)
        
        let cabLabel = Title1LabelUILabel()
        cabLabel.text = dailyRasp.room
        cabLabel.frame = CGRect(x: self.frame.width - 60, y: 0.0, width: 70, height: 30)
        
        self.addSubview(cabLabel)
        
        let userLabel = Title3LabelUILabel()
        userLabel.text = dailyRasp.teacher
        let width = self.frame.width/2.2
        userLabel.frame = CGRect(x:self.frame.width - width, y: 40, width: width, height: 20)
        userLabel.textAlignment = .right
        self.addSubview(userLabel)
        
        let typeLabel = Title2LabelUILabel()
        
        if !SystemDevice().isNormalDevice {
            let str = dailyRasp.name.components(separatedBy: " ")
            userLabel.text = str[0]
        } else {
            if let lesson = dailyRasp.typeLesson {
                var bufLes = lesson
                if let index = bufLes.firstIndex(of: "/") {
                    bufLes = String(bufLes.prefix(upTo: index))
                }

                typeLabel.text = bufLes
            }
        }
        typeLabel.frame = CGRect(x:0, y: 40, width: self.frame.width/2, height: 20)
        
        self.addSubview(typeLabel)
    }

}
