//
//  TableRaspisanieByTeacherUIVIew.swift
//  Bazis MADI
//
//  Created by Всеволод Андрющенко on 09.01.2020.
//  Copyright © 2020 Всеволод Андрющенко. All rights reserved.
//

import UIKit

protocol TableRaspisanieExamsDataSource {
    func raspisanieExamsTableData(_ parametrView: TableRaspisanieExamsUIView) -> [Exam]?
}

class  TableRaspisanieExamsUIView: UIView {
    
    let notFoundtitle = TitleT1WLabelUILabel()
    let scrollView = UIScrollView()
    
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
    
    var raspisanieExamsDataSource: TableRaspisanieExamsDataSource? {
        didSet {
            setupTableExams()
        }
    }
    
    //MARK: - отображение данных о экзамене
    public func  setupTableExams() {
        notFoundtitle.removeFromSuperview()
        if let exams = raspisanieExamsDataSource?.raspisanieExamsTableData(self) {
            createBackground(count: exams.count)
            
            var startX:CGFloat = 10.0
            for exam in exams {
                createExamView(exam: exam, startX: startX)
                startX += self.frame.width/1.3 + 10.0
            }
        } else {
            showExamNotFound()
        }
    }
    
     //MARK: - настройка скрол вью
    private func createBackground(count: Int) {
        scrollView.contentSize = CGSize(width: (self.frame.width/1.3 + 10) * CGFloat(count), height: self.frame.height)
        self.addSubview(scrollView)
        scrollView.backgroundColor = .clear
        scrollView.showsHorizontalScrollIndicator = false
    }
    
    //MARK: - метод создания отобржажения  view
    private func createExamView(exam: Exam, startX: CGFloat) {
        let frame = CGRect(x: startX, y: CGFloat(10.0), width: self.frame.width/1.3 - 20, height: self.frame.height - 35)
        let examView = ExamUIView(frame: frame)
        examView.setupData(examData: exam)
        scrollView.addSubview(examView)
    }
    
    private func showExamNotFound() {
        print(self.frame.width)
        notFoundtitle.frame = CGRect(x: 0, y: 30, width: self.frame.width, height: 60)
        notFoundtitle.textAlignment = .center
        notFoundtitle.text = "В настояшее время расписание экзаменов не установленно"
        
        self.addSubview(notFoundtitle)
    }
    
}
