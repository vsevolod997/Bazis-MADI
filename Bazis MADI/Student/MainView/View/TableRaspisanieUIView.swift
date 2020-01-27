//
//  TableRaspisanieUIView.swift
//  Bazis MADI
//
//  Created by Всеволод Андрющенко on 11.12.2019.
//  Copyright © 2019 Всеволод Андрющенко. All rights reserved.
//

import UIKit

protocol TableRaspisanieDataSource {
    // MARK: - sub VC indexDay начинается с 0 - ПН, 1 - ВТ
    func raspisanieTableData(_ parametrView: TableRaspisanieUIView,  indexDay: Int) -> [DailyRaspisanie]?
    
    func raspisanieDayNow(_ parametrView: TableRaspisanieUIView) -> Int
    
    func raraspisanieWeakNow(_  parametrView: TableRaspisanieUIView) -> Bool // true  числитель
    // false знвменатель
}

protocol TableRaspisanieDelegate {
    func changedDay(_ parametrView: TableRaspisanieUIView, didSelectItem index: Int)
}

// MARK: - окно расписания
class TableRaspisanieUIView: UIView {
    
    let weakController = WeekRaspisanieController()
    let scrollView = UIScrollView()
    var dayNow: Int = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addGestRecognoizer()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addGestRecognoizer()
    }
    
    public var delegate: TableRaspisanieDelegate?
    
    public var raspisanieViewDataSource: TableRaspisanieDataSource? {
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
            if dayNow < 5 {
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
        createBakground()
        
        var startX: CGFloat = 30.0 // стартовая точка отрисовки окон
        guard let typeWeak = raspisanieViewDataSource?.raraspisanieWeakNow(self) else { return }
        let dayliTitle = weakController.getDateWeek(week: weekInCalendar)
        
        for i in 0...5 {
            
            let origrin = CGPoint(x: startX, y: 10.0)
            let dailyRaspisanie =
                raspisanieViewDataSource?.raspisanieTableData(self, indexDay: i)
            if let day = dailyRaspisanie {
                if let presetRaspisanie = weakController.getOnlyChangedDayType(dayRasp: day, typeWeak: typeWeak) {
                    createDayliView(startPoint: origrin, weakDay: i, daylyRaspisanie: presetRaspisanie, date: dayliTitle[i])
                }
            } else {
                createDayliView(startPoint: origrin, weakDay: i, daylyRaspisanie: nil, date: dayliTitle[i])
            }
            startX += self.frame.width - 40
        }
        
        if let day = raspisanieViewDataSource?.raspisanieDayNow(self) {
            dayNow = day
            scrollDay(changedDay: dayNow, scrollSize: 40)
        }
    }
    
    //MARK: -  настройка бекграунда создание скрола
    private func createBakground() {
        scrollView.contentSize = CGSize(width: self.frame.width * 6, height: self.frame.height)
        self.addSubview(scrollView)
        scrollView.backgroundColor = .clear
        scrollView.isScrollEnabled = false
        scrollView.showsHorizontalScrollIndicator = false
    }
    
    //MARK: - создание view для отображения расписания в определенный день
    private func createDayliView(startPoint: CGPoint, weakDay: Int, daylyRaspisanie: [DailyRaspisanie]?, date: String) {
        let sizeDayView = CGSize(width: self.frame.width - 60 , height: self.frame.height - 20)
        let frame = CGRect(origin: startPoint, size: sizeDayView)
        let view = DayRaspisUIView(frame: frame)
        view.createDayliView(dayWeak: weakDay, dayDate: date) // создание отобрвдения дня недели
        view.createDayliRasp(daylyRaspisanie: daylyRaspisanie) // создание расписания
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
