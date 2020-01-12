//
//  TableRaspisanieTeacerViewController.swift
//  Bazis MADI
//
//  Created by Всеволод Андрющенко on 03.01.2020.
//  Copyright © 2020 Всеволод Андрющенко. All rights reserved.
//

import UIKit

protocol TableRaspisanieTeacherDataSource {
    // MARK: - sub VC indexDay начинается с 0 - ПН, 1 - ВТ
    func raspisanieTableData(_ parametrView: TableRaspisanieTeacherUIVIew,  indexDay: Int) -> [DailyRaspisanieTeacher]?
    
    func raspisanieDayNow(_ parametrView: TableRaspisanieTeacherUIVIew) -> Int
    
    func raspisanieDayliWorkCount(_ parameterView: TableRaspisanieTeacherUIVIew) -> Int
    
    func raspisanieWeakNow(_  parametrView: TableRaspisanieTeacherUIVIew) -> Bool // true  числитель
    // false знвменатель
}

protocol TableRaspisanieTeacherDelegate {
    func changedDay(_ parametrView: TableRaspisanieTeacherUIVIew, didSelectItem index: Int)
}

class TableRaspisanieTeacherUIVIew: UIView {

    let weekController = WeekRaspisanieController()
    let scrollView = UIScrollView()
    var dayNow: Int = 0
    var dayCount: Int = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addGestRecognoizer()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addGestRecognoizer()
    }
    
    public var delegate: TableRaspisanieTeacherDelegate?
    
    public var raspisanieViewDataSource: TableRaspisanieTeacherDataSource? {
        didSet{
            setupView(weekInCalendar: .now)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        scrollView.frame = self.bounds
    }
    
    //MARK: - добавление жестов для анимации скролинга
    private func addGestRecognoizer() {
        let swipeRigthGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeScrollView(_:)))
        self.addGestureRecognizer(swipeRigthGesture)
        
        let swipeLeftGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeScrollView(_:)))
        swipeLeftGesture.direction = .left
        
        self.addGestureRecognizer(swipeLeftGesture)
    }
    
    //MARK: - жесты "перелиствания" дня недели
    @objc func swipeScrollView(_ recognizer: UISwipeGestureRecognizer) {
        
        if recognizer.direction == .left {
            if dayNow < dayCount - 1 {
                dayNow += 1
                scrollDay(changedDay: dayNow, scrollSize: 20)
            }
        }
        
        if recognizer.direction == .right {
            if dayNow > 0 {
                dayNow -= 1
                scrollDay(changedDay: dayNow, scrollSize: 60)
            }
        }
        
        delegate?.changedDay(self, didSelectItem: dayNow)
    }
    
    //MARK: - настройка отображение окна
    public func setupView(weekInCalendar: Week) {
        
        removeAllSuperviews()
        guard let count = raspisanieViewDataSource?.raspisanieDayliWorkCount(self) else { return }
        
        dayCount = count
        createBakground(count: count)
        var startX: CGFloat = 30.0 // стартовая точка отрисовки окон
        guard let typeWeak = raspisanieViewDataSource?.raspisanieWeakNow(self) else { return }
        let dayliTitle = weekController.getDateWeek(week: weekInCalendar)
        
        for i in 0...6 {
            if let dayliRaspisanie = raspisanieViewDataSource?.raspisanieTableData(self, indexDay: i) {
                if let teacherDaily = weekController.getOnlyChangedDayTypeTeacher(dayRasp: dayliRaspisanie, typeWeak: typeWeak) {
                    let origrin = CGPoint(x: startX, y: 10.0)
                    createDayliView(startPoint: origrin, weakDay: i, daylyRaspisanie: teacherDaily, date: dayliTitle[i])
                    
                    startX += self.frame.width - 40
                }
            }
            
            if let day = raspisanieViewDataSource?.raspisanieDayNow(self) {
                //print(dayCount/day) это отвечвет за чек текущего дня
                if day > 0 {
                    dayNow = dayCount/day
                } else {
                    dayNow = 0
                }
                scrollDay(changedDay: dayNow, scrollSize: 40)
            }
        }
    }
    
    //MARK: -  настройка бекграунда создание скрола
    private func createBakground(count: Int) {
        
        let contentWidth = CGFloat(count) * self.frame.width
        scrollView.contentSize = CGSize(width: contentWidth, height: self.frame.height)
        self.addSubview(scrollView)
        scrollView.backgroundColor = .white
        scrollView.isScrollEnabled = false
        scrollView.showsHorizontalScrollIndicator = false
    }
    
    //MARK: - создание view для отображения расписания в определенный день
    private func createDayliView(startPoint: CGPoint, weakDay: Int, daylyRaspisanie: [DailyRaspisanieTeacher], date: String) {
        let sizeDayView = CGSize(width: self.frame.width - 60 , height: self.frame.height - 20)
        let frame = CGRect(origin: startPoint, size: sizeDayView)
        let view = DayliRaspisTeacerUIView(frame: frame)
        view.createDayliView(dayWeak: weakDay, dayDate: date) // создание отобрвдения дня недели
        view.createDayliRasp(daylyRasp: daylyRaspisanie) // создание расписания
        scrollView.addSubview(view)
    }
    
    //MARK: - прокрутка окна отображения расписания
    private func scrollDay(changedDay: Int, scrollSize: CGFloat) {
        
        UIView.animate(withDuration: 0.3, animations: {
            let scrollX = CGFloat(changedDay) * (self.frame.width - scrollSize)
            self.scrollView.contentOffset = CGPoint(x: scrollX, y: 0.0)
        }) { (complite) in
            UIView.animate(withDuration: 0.1) {
                let scrollX = CGFloat(changedDay) * (self.frame.width - 40)
                self.scrollView.contentOffset = CGPoint(x: scrollX, y: 0.0)
            }
        }
    }
    
    //MARK: - Удаление старых окон при перезагрузки
    public func removeAllSuperviews() {
        scrollView.subviews.forEach( { $0.removeFromSuperview() })
    }

}
