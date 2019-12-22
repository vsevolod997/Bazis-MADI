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
}

protocol TableRaspisanieDelegate {
    func changedDay(_ parametrView: TableRaspisanieUIView, didSelectItem index: Int)
}

// MARK: - окно расписания
class TableRaspisanieUIView: UIView {
    
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
            setupView()
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
    
    @objc func swipeScrollView(_ recognizer: UISwipeGestureRecognizer) {
        
        if recognizer.direction == .left {
            print("left")//
            if dayNow < 5 {
                dayNow += 1
                scrollDay(changedDay: dayNow)
            }
        }
        
        if recognizer.direction == .right {
            print("rigth")//
            if dayNow > 0 {
                dayNow -= 1
                scrollDay(changedDay: dayNow)
            }
        }
        
        delegate?.changedDay(self, didSelectItem: dayNow)
    }
    
    //MARK: - настройка отображение окна
    public func setupView() {
        createBakground()
        
        var startX: CGFloat = 30.0
        
        for i in 0...6 {
            let dailyRaspisanie =
                raspisanieViewDataSource?.raspisanieTableData(self, indexDay: i)
            
            if let day = dailyRaspisanie {
                let origrin = CGPoint(x: startX, y: 10.0)
                createDayliView(startPoint: origrin, count: 3)
                startX += self.frame.width - 40
            }
        }
        
        if let day = raspisanieViewDataSource?.raspisanieDayNow(self) {
            dayNow = day
            scrollDay(changedDay: dayNow)
        }
    }
    
    //MARK: -  настройка бекграунда
    private func createBakground() {
        scrollView.contentSize = CGSize(width: self.frame.width * 6, height: self.frame.height)
        self.addSubview(scrollView)
        scrollView.backgroundColor = .systemYellow
        scrollView.isScrollEnabled = false
        scrollView.showsHorizontalScrollIndicator = false
    }
    
    //MARK: - создание view для отображения расписания в определенный день
    private func createDayliView(startPoint: CGPoint, count: Int) {
        let view = DayRaspisUIView()
        let sizeDayView = CGSize(width: self.frame.width - 60 , height: self.frame.height - 20)
        view.frame = CGRect(origin: startPoint, size: sizeDayView)
        scrollView.addSubview(view)
    }
    
    private func scrollDay(changedDay: Int) {
        
        UIView.animate(withDuration: 0.3) {
            let scrollX = CGFloat(changedDay) * (self.frame.width - 40)
            self.scrollView.contentOffset = CGPoint(x: scrollX, y: 0.0)
        }
    }

}
