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
        setupView()
    }
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        self.layer.borderWidth = 0.5
        self.layer.borderColor = SystemColor.blueColor.cgColor
    }
    
    public func setupDate(dailyRasp: DailyRaspisanie) {
        let nameLabel = Title2LabelUILabel()
        nameLabel.textAlignment = .center
        nameLabel.text = dailyRasp.name
        nameLabel.numberOfLines = 2
        let labelX = self.frame.width/2 - 100
        nameLabel.frame = CGRect(x:labelX , y: 0, width: 200, height: 40)
        
        self.addSubview(nameLabel)
        
        let timeLabel = Title3LabelUILabel()
        timeLabel.text = dailyRasp.time
        timeLabel.numberOfLines = 2
        timeLabel.frame = CGRect(x: 0.0, y: 0, width: 50, height: self.frame.height)
        
        self.addSubview(timeLabel)
        
        let cabLabel = Title1LabelUILabel()
        cabLabel.text = dailyRasp.room
        cabLabel.frame = CGRect(x: self.frame.width - 60, y: 0.0, width: 60, height: self.frame.height)
        
        self.addSubview(cabLabel)
    }

}
