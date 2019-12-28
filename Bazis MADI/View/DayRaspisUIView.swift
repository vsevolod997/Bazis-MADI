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
    
    
    fileprivate func homeDayCreate() {
        let title = Title1LabelUILabel()
        title.text = "День самостоятельной работы!"
        title.frame = CGRect(x: self.frame.width / 2 - 125, y: 100, width: 250, height: 65)
        title.numberOfLines = 2
        title.textAlignment = .center
        self.addSubview(title)
    }
    
    //MARK: - Отображение пар в текущий день
    public func createDayliRasp(daylyRasp: [DailyRaspisanie]) {
        let originX = 10.0
        var originY = 60.0
        let heigtView = 50.0
        
        if daylyRasp.count == 0 {
            homeDayCreate()
        }
        for rasp in daylyRasp {
            if rasp.name == "День самостоятельной работы" {
                homeDayCreate()
            } else {
                let width =  self.frame.width - 20
                let frameClasses = CGRect(x: originX, y: originY, width: Double(width), height: heigtView)
                let classesView = ClassesUIView(frame: frameClasses)
                self.addSubview(classesView)
                classesView.setupDate(dailyRasp: rasp)
                
                originY += 5 + heigtView
            }
        }
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
        
        
        let startX2 = self.frame.width/2 - 60
        startY = 32
        let titleName = Title2LabelUILabel()
        titleName.text = "Наименование дисциплины"
        titleName.textAlignment = .center
        titleName.numberOfLines = 2
        titleName.frame = CGRect(x: Double(startX2), y: startY - 10, width: 120.0, height: 35)
        
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
