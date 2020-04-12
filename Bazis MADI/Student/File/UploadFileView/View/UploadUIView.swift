//
//  UploadUIView.swift
//  Bazis MADI
//
//  Created by Всеволод Андрющенко on 08.04.2020.
//  Copyright © 2020 Всеволод Андрющенко. All rights reserved.
//

import UIKit

class UploadUIView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        layer.cornerRadius = 15
        backgroundColor = SystemColor.blueColor
        alpha = 0.8
        
        let title = Title2LabelUILabel()
        title.text = "Выгрузка файла..."
        title.textColor = SystemColor.whiteColor
        title.numberOfLines = 2
        title.textAlignment = .center
        print(self.frame.height)
        title.frame = CGRect(x: 10, y: self.frame.height - 40, width: self.frame.width - 10.0, height: 40)
        addSubview(title)
        
        let activity = UIActivityIndicatorView(style: .large)
        activity.color = SystemColor.whiteColor
        activity.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        activity.center = self.center
        activity.startAnimating()
        addSubview(activity)
    }
    
}
