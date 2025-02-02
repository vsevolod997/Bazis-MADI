//
//  DayliRaspisPrepodUIView.swift
//  Bazis MADI
//
//  Created by Всеволод Андрющенко on 04.01.2020.
//  Copyright © 2020 Всеволод Андрющенко. All rights reserved.
//

import UIKit

class DayliRaspisTeacerUIView: UIView {
    
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
        self.backgroundColor = SystemColor.whiteTextFill
        self.layer.cornerRadius = 20
        
        self.layer.shadowColor = SystemColor.shadowColor.cgColor
        self.layer.shadowRadius = 8
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowOpacity = 0.6
    }
    
    //MARK: - Создание отображения сегодняшенего дня
    public func createDayliView(dayWeak: Int, dayDate: String) {
        // создание отображения текущего дня недели
        let startDateX = self.frame.width/2.2
        let startDateY = 4.0
        let dateTitle = Title1LabelUILabel()
        dateTitle.text = dayDate
        dateTitle.textAlignment = .right
        dateTitle.frame = CGRect(x: Double(startDateX), y: startDateY, width: Double(self.frame.width - startDateX - 10.0), height: 26.0)
        
        self.addSubview(dateTitle)
        
        // создание отображения текущего дня недели
        let startX = 10
        let startY = 4
        
        let dayTitle = Title1LabelUILabel()
        let textDay = intToDay(indexDay: dayWeak)
        dayTitle.text = textDay
        dayTitle.frame = CGRect(x: startX, y: startY, width: 150, height: 26)
        
        self.addSubview(dayTitle)
    }
    
    private func homeDayCreate() {
        let title = Title1LabelUILabel()
        title.text = "В этот день пар нет."
        title.frame = CGRect(x: self.frame.width / 2 - 125, y: 100, width: 250, height: 65)
        title.numberOfLines = 2
        title.textAlignment = .center
        self.addSubview(title)
    }
    
    //MARK: - Отображение пар в текущий день
    public func createDayliRasp(daylyRasp: [DailyRaspisanieTeacher]) {
        
        if daylyRasp.count != 0 {
            
            let originX = 10.0
            let heigtView = 65.0
            
            let scrollHeigth = (self.frame.height - 65.0)
            let scrollView = UIScrollView()
            let width = self.frame.width
            scrollView.frame = CGRect(x: 0.0, y: 60.0, width: Double(width), height: Double(scrollHeigth))
            
            let height = (65.0 + 7.0) * Double(daylyRasp.count)
            scrollView.contentSize = CGSize(width: Double(self.frame.width), height: height)
            self.addSubview(scrollView)
            
            var originY = 0.0
            for rasp in daylyRasp {
                let width =  self.frame.width - 20
                let frameClasses = CGRect(x: originX, y: Double(originY), width: Double(width), height: heigtView)
                let classesView = ClassesTeacherUIView(frame: frameClasses)
                scrollView.addSubview(classesView)
                classesView.setupDate(dailyRasp: rasp)
                originY += 7.0 + heigtView
            }
        } else {
            homeDayCreate()
        }
    }
    
    //MARK: - Создание "шапки" таблицы
    private func createTitleView() {
        let startX = 10.0
        var startY = 32.0
        let title = Title2LabelUILabel()
        title.text = "Время"
        title.textAlignment = .left
        title.frame = CGRect(x: startX, y: startY, width: 100, height: 26.0)
        
        self.addSubview(title)
        
        
        let startX2 = self.frame.width/2 - 70
        startY = 32
        let titleName = Title2LabelUILabel()
        titleName.text = "Дисциплина"
        titleName.textAlignment = .center
        titleName.numberOfLines = 2
        titleName.frame = CGRect(x: Double(startX2), y: startY, width: 120.0, height: 26.0)
        
        self.addSubview(titleName)
        
        let startX3 = self.frame.width - 110
        let titleNum = Title2LabelUILabel()
        titleNum.text = "Аудитория"
        titleNum.textAlignment = .right
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
    
    //MARK: - Перевод индекса дня в текстовое представление
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
