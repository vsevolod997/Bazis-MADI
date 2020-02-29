//
//  ClassesTeacherUIView.swift
//  Bazis MADI
//
//  Created by Всеволод Андрющенко on 06.01.2020.
//  Copyright © 2020 Всеволод Андрющенко. All rights reserved.
//

import UIKit

class ClassesTeacherUIView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        self .backgroundColor = .clear
    }
    
    public func setupDate(dailyRasp: DailyRaspisanieTeacher) {
        
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
        if  !SystemDevice().isNormalDevice {
            userLabel.text =  dailyRasp.group
        } else {
            if let groupName = dailyRasp.group {
                userLabel.text = "Группа: " + groupName
            } else {
                userLabel.text = "Уточняется"
            }
        } // проверка устройства
        
        let width = self.frame.width/2.2
        userLabel.frame = CGRect(x:self.frame.width - width, y: 40, width: width, height: 20)
        userLabel.textAlignment = .right
        self.addSubview(userLabel)
        
        let typeLabel = Title2LabelUILabel()
        
        
        if let buff = dailyRasp.typeLesson?.components(separatedBy: " ") {
             typeLabel.text = buff[0]
        } else {
            typeLabel.text = "Не установлен"
        }
        
        typeLabel.frame = CGRect(x:0, y: 40, width: self.frame.width/2, height: 20)
        
        self.addSubview(typeLabel)
    }

}
