//
//  DayRaspisUIView.swift
//  Bazis MADI
//
//  Created by Всеволод Андрющенко on 22.12.2019.
//  Copyright © 2019 Всеволод Андрющенко. All rights reserved.
//

import UIKit

class DayRaspisUIView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        createTitleView()
    }
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
        createTitleView()
    }
    
   //override func draw(_ rect: CGRect) {
   //
   //    if let line = UIGraphicsGetCurrentContext() {
   //        let firsPoint = CGPoint(x: 25, y: 60)
   //        let secondPoint = CGPoint(x: self.frame.width - 25, y: 60)
   //        line.move(to: firsPoint)
   //        line.addLine(to: secondPoint)
   //
   //        line.setStrokeColor(SystemColor.grayColor.cgColor)
   //        line.setLineWidth(3)
   //        line.setLineCap(.round)
   //        line.strokePath()
   //    }
   //}
    
    //MARK: - настройка окна
    private func setupView() {
           self.backgroundColor = UIColor.white
           self.layer.cornerRadius = 20
           
           self.layer.shadowColor = UIColor.gray.cgColor
           self.layer.shadowRadius = 8
           self.layer.shadowOffset = CGSize.zero
           self.layer.shadowOpacity = 0.6
       }

    //MARK: - Создание отображения сегодняшенего дня
    public func createDayliView(dayWeak: Int) {
        let startX = 10
        let startY = 4
        
        let dayTitle = Title1LabelUILabel()
        let textDay = intToDay(indexDay: dayWeak)
        dayTitle.text = textDay
        dayTitle.frame = CGRect(x: startX, y: startY, width: 150, height: 26)
        
        self.addSubview(dayTitle)
    }
    
    public func createDayliRasp(daylyRasp: [DailyRaspisanie] ) {
        if daylyRasp.count == 0 {
            let title = 
        }
        for rasp in daylyRasp {
            print("///",rasp)
        }
        print("|||")
    }
    
    //MARK: - Создание "шапки"  таблицы
    private func createTitleView() {
        let startX = 10.0
        var startY = 32.0
        let title = Title2LabelUILabel()
        title.text = "Время"
        title.textAlignment = .center
        title.frame = CGRect(x: startX, y: startY, width: 100, height: 26.0)
        
        self.addSubview(title)
        
        
        let startX2 = self.frame.width/2 - 50
        startY = 32
        let titleName = Title2LabelUILabel()
        titleName.text = "Предмет"
        titleName.textAlignment = .center
        titleName.frame = CGRect(x: Double(startX2), y: startY, width: 100.0, height: 26.0)
        
        self.addSubview(titleName)
        
        let startX3 = self.frame.width - 110
        let titleNum = Title2LabelUILabel()
        titleNum.text = "Кабинет"
        titleNum.textAlignment = .center
        titleNum.frame = CGRect(x: Double(startX3), y: startY, width: 100.0, height: 26.0)
        
        self.addSubview(titleNum)
        
        let path = UIBezierPath()
        let firsPoint = CGPoint(x: 25, y: 60)
        let secondPoint = CGPoint(x: self.frame.width - 25, y: 60)
        path.move(to: firsPoint)
        path.addLine(to: secondPoint)
        path.close()
        
        let lineLayer = CAShapeLayer()
        lineLayer.path = path.cgPath
        lineLayer.fillColor = SystemColor.grayColor.cgColor
        lineLayer.lineWidth = 3
        lineLayer.cornerRadius = 1.5
        lineLayer.fillColor = SystemColor.grayColor.cgColor
        
        self.layer.addSublayer(lineLayer)
    }
    
    //MARK: - перевод индекса дня в текстовое представление
    private func intToDay(indexDay: Int ) -> String {
        switch indexDay {
        case 0:
            return "Понедельник"
        case 1:
            return "Вторник"
        case 2:
            return "Среда"
        case 3:
            return "Четверг"
        case 4:
            return "Пятница"
        case 5:
            return "Суббота"
        default:
            return "Не найдено!"
        }
    }
}
