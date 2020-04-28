//
//  TableRaspisanieByGroupUIView.swift
//  Bazis MADI
//
//  Created by Всеволод Андрющенко on 13.01.2020.
//  Copyright © 2020 Всеволод Андрющенко. All rights reserved.
//

import UIKit

protocol TableRaspisanieByGroupDataSource: class {
    func raspisanieByGroupData(_ parametrView: TableRaspisanieByGroupUIView) -> [String]?
}

protocol TableRaspisanieByGroupDelegate: class {
    func selectShowInfoGroup(_ parametrView: TableRaspisanieByGroupUIView, selectedGroup: String)
}


class TableRaspisanieByGroupUIView: UIView {
    
    let scrollView = UIScrollView()
    var groups :[String] = []
    
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
    
    weak var delegate: TableRaspisanieByGroupDelegate?
    
    var raspisanieByGroupDataSource: TableRaspisanieByGroupDataSource? {
        didSet {
            setupDataView()
        }
    }
    
    //MARK: - отображение данных
    public func setupDataView() {
        if let dataGroup = raspisanieByGroupDataSource?.raspisanieByGroupData(self) {
            groups = dataGroup
            let count = dataGroup.count
            createBackground(count: count)
            var index: Int = 0
            
            var startX: CGFloat = 10.0
            for group in dataGroup {
                let frame = CGRect(x: startX, y: 10, width: self.frame.height + 20, height: self.frame.height)
                let view = RspByGroupUIVIew(frame: frame)
                view.tag = index
                view.createView(nameGroup: group)
                scrollView.addSubview(view)
                
                let gesture = UITapGestureRecognizer(target: self, action: #selector(selectTapGesture(gesture:)))
                view.addGestureRecognizer(gesture)
                
                index += 1
                startX += self.frame.height + 10
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
                self.delegate?.selectShowInfoGroup(self, selectedGroup: self.groups[view.tag])
                UIView.animate(withDuration: 0.01) {
                    view.transform = .init(scaleX: 1, y: 1)
                    view.alpha = 1
                }
            }
        }
    }
    
    //MARK: - настройка скрол вью
    private func createBackground(count: Int) {
        scrollView.contentSize = CGSize(width: (self.frame.height + 12) * CGFloat(count), height: self.frame.height)
        self.addSubview(scrollView)
        scrollView.backgroundColor = .clear
        scrollView.showsHorizontalScrollIndicator = false
    }
}
