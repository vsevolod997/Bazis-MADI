//
//  ExamUIView.swift
//  Bazis MADI
//
//  Created by Всеволод Андрющенко on 09.01.2020.
//  Copyright © 2020 Всеволод Андрющенко. All rights reserved.
//

import UIKit

class ExamUIView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        styleSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        styleSetup()
    }
    
    
    private func styleSetup() {
        backgroundColor = .white
        layer.cornerRadius = 10
    }
    
    public func setupData(examData: Exam) {
        let nameLabel = Title4LabelUILabel()
        let width = self.frame.width - 20
        nameLabel.frame = CGRect(x: 10, y: 10, width: width, height: 90)
        nameLabel.numberOfLines = 3
        nameLabel.text = examData.name
        self.addSubview(nameLabel)
        
        let timeLabel = Title3LabelUILabel()
        let widtTime = self.frame.width - 10.0
        timeLabel.frame = CGRect(x: 10, y: 130, width: widtTime, height: 20)
        timeLabel.text = examData.time
        self.addSubview(timeLabel)
        
        let teacherLabel = Title1LabelUILabel()
        let widthTeacer = self.frame.width
        teacherLabel.frame = CGRect(x: 10, y: 100, width: widthTeacer - 10.0, height: 30)
        teacherLabel.textColor = SystemColor.grayColor
        teacherLabel.text = examData.teacher
        self.addSubview(teacherLabel)
        
        let roomLabel = Title1LabelUILabel()
        let widthRoom = self.frame.width
        roomLabel.frame = CGRect(x: 10, y: 150, width: widthRoom - 10.0, height: 30)
        roomLabel.text = "Аудитория: " + examData.room
        self.addSubview(roomLabel)
    }
}
