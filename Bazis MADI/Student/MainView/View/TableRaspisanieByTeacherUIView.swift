//
//  TableRaspisanieByTeacerUIView.swift
//  Bazis MADI
//
//  Created by Всеволод Андрющенко on 11.01.2020.
//  Copyright © 2020 Всеволод Андрющенко. All rights reserved.
//

import UIKit
 //MARK:  - дата сорс расписания по преподавателям
protocol TableRaspisanieByTeacherDataSource {
    func raspisanieByTeacherTableData(_ parametrView: TableRaspisanieByTeacherUIView) -> [String]?
}

protocol TableRaspisanieByTeacherDelegate {
    func selectTeacherButton(_ parametrView: TableRaspisanieByTeacherUIView, teacherData: String)
}

class TableRaspisanieByTeacherUIView: UIView {
    
    let scrollView = UIScrollView()
    var teachers:[String] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        scrollView.frame = self.bounds
    }
    
    public var delegate: TableRaspisanieByTeacherDelegate?
    
    var raspisanieByTeacherDataSource: TableRaspisanieByTeacherDataSource? {
        didSet {
            setupDataView()
        }
    }
    
    //MARK: - отображение данных
    public func setupDataView() {
        if let dataTeacher = raspisanieByTeacherDataSource?.raspisanieByTeacherTableData(self) {
            teachers = dataTeacher
            let count = dataTeacher.count
            createBackground(count: count)
            var index: Int = 0
            
            var startX: CGFloat = 10.0
            for teacher in dataTeacher {
                let frame = CGRect(x: startX, y: 10, width: self.frame.height, height: self.frame.height)
                let view = RspByTeacherUIVIew(frame: frame)
                view.tag = index
                view.createView(nameUser: teacher)
                scrollView.addSubview(view)
                
                let gesture = UITapGestureRecognizer(target: self, action: #selector(selectTapGesture(gesture:)))
                view.addGestureRecognizer(gesture)
                
                index += 1
                startX += self.frame.height
            }
        }
    }
    
     //MARK: - обработка данных по нажатию на форму
    @objc func selectTapGesture(gesture: UIGestureRecognizer) {
        if let view = gesture.view {
            UIView.animate(withDuration: 0.05, animations: {
                view.transform = .init(scaleX: 0.8, y: 0.8)
                view.alpha = 0.8
            }) { (anim) in
                self.delegate?.selectTeacherButton(self, teacherData: self.teachers[view.tag])
                
                UIView.animate(withDuration: 0.01) {
                    view.transform = .init(scaleX: 1, y: 1)
                    view.alpha = 1
                }
            }
        }
    }
    
    func showTeacherView(name: String ) {
        
    }
    
    //MARK: - настройка скрол вью
    private func createBackground(count: Int) {
        scrollView.contentSize = CGSize(width: (self.frame.width/3 + 10) * CGFloat(count), height: self.frame.height)
        self.addSubview(scrollView)
        scrollView.backgroundColor = .clear
        scrollView.showsHorizontalScrollIndicator = false
    }
}
