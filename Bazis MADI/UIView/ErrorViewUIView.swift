//
//  ErrorViewUIView.swift
//  Bazis MADI
//
//  Created by Всеволод Андрющенко on 06.02.2020.
//  Copyright © 2020 Всеволод Андрющенко. All rights reserved.
//

import UIKit
import AVFoundation

class ErrorViewUIView: UIView {
    
    private let notificationReload = Notification.Name("reloadData")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupBackground()
        createSubView()
        createReloadButton()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupBackground()
        createSubView()
        createReloadButton()
    }

    fileprivate func setupBackground() {
        backgroundColor = SystemColor.whiteTextFill
    }
    
    fileprivate func createSubView() {
        let label = Title2LabelUILabel()
        label.text = "Не удалось загрузить данные, возможно отсутствует интернет соединение"
        label.textAlignment = .center
        label.numberOfLines = 2
        let widthLabel = 400
        let startX = self.center.x - CGFloat(widthLabel/2)
        label.frame = CGRect(x: Int(startX), y: 150, width: widthLabel, height: 50)
        self.addSubview(label)
    }
    
    fileprivate func createReloadButton() {
        let button = InputButton1UIButton()
        button.setTitle("Перезагрузить", for: .normal)
        button.frame = CGRect(x: self.frame.width/2.0 - 100, y: 250, width: 200.0, height: 40)
        self.addSubview(button)
        button.addTarget(self, action: #selector(reloadButtonPress), for: .touchUpInside)
    }
    
    @objc func reloadButtonPress() {
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.impactOccurred()
        NotificationCenter.default.post(name: notificationReload, object: nil,  userInfo: nil)
    }
    
}
