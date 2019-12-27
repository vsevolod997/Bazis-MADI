//
//  CloseViewUIView.swift
//  Bazis MADI
//
//  Created by Всеволод Андрющенко on 05.12.2019.
//  Copyright © 2019 Всеволод Андрющенко. All rights reserved.
//

import UIKit

//MARK: -  uiView как заглушка при получении данных.
class CloseViewUIView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //print("im init")
        setupBackground()
        createSubView()
        createActivityView()
    }
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupBackground()
        createSubView()
        createActivityView()
    }
    
    fileprivate func setupBackground() {
        backgroundColor = .clear
        
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.systemMaterialLight)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(blurEffectView)
    }
    
    fileprivate func createSubView() {
        let label = Title2LabelUILabel()
        label.text = "Ожидайте, загрузка данных..."
        label.textAlignment = .center
        
        let widthLabel = 200
        let startX = self.center.x - CGFloat(widthLabel/2)
        label.frame = CGRect(x: Int(startX), y: 120, width: widthLabel, height: 50)
        self.addSubview(label)
    }
    
    fileprivate func createActivityView() {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.frame = CGRect(x: 0, y: 50, width: 46, height: 46)
        activityIndicator.center.x = center.x
        activityIndicator.startAnimating()
        self.addSubview(activityIndicator)
    }
}
