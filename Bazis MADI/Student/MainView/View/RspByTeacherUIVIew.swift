//
//  RspByTeacherUIVIew.swift
//  Bazis MADI
//
//  Created by Всеволод Андрющенко on 11.01.2020.
//  Copyright © 2020 Всеволод Андрющенко. All rights reserved.
//

import UIKit

class RspByTeacherUIVIew: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        styleSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        styleSetup()
    }
    
    
    private func styleSetup() {
        backgroundColor = .clear
    }
    
    public func createView(nameUser: String) {
        let label = UserTitleUILabel()
        label.frame = CGRect(x: 20, y: 10, width: self.frame.height - 50, height: self.frame.height - 50)
        let data = nameUser.split(separator: " ")
        label.text = String(data[0].first!) + "" + String(data[1].first!)
        
        self.addSubview(label)
        
        let nameLabel = Title3LabelUILabel()
        nameLabel.frame = CGRect(x: 0, y: self.frame.height - 40, width: self.frame.width, height: 20)
        nameLabel.text = nameUser
        nameLabel.textAlignment = .center
        
        self.addSubview(nameLabel)
    }
    
}
