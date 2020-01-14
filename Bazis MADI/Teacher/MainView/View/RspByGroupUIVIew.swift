//
//  RspByGroupUIVIew.swift
//  Bazis MADI
//
//  Created by Всеволод Андрющенко on 14.01.2020.
//  Copyright © 2020 Всеволод Андрющенко. All rights reserved.
//

import UIKit

class RspByGroupUIVIew: UIView {
    
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
    
    public func createView(nameGroup: String) {
        let label = UserTitleUILabel()
        label.frame = CGRect(x: 20, y: 10, width: self.frame.width - 20, height: self.frame.height - 50)
        label.text = nameGroup
        self.addSubview(label)
        
        let nameLabel = Title3LabelUILabel()
        nameLabel.frame = CGRect(x: 20, y: self.frame.height - 40, width: self.frame.width - 20, height: 20)
        nameLabel.text = nameGroup
        nameLabel.textAlignment = .center
        
        self.addSubview(nameLabel)
    }
    
}
