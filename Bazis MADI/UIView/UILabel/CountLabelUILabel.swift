//
//  CountLabelUILabel.swift
//  Bazis MADI
//
//  Created by Всеволод Андрющенко on 30.03.2020.
//  Copyright © 2020 Всеволод Андрющенко. All rights reserved.
//

import UIKit

class CountLabelUILabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    fileprivate func setup() {
        
        font = UIFont.systemFont(ofSize: 18, weight: .heavy)
        textColor = SystemColor.blueColor
        layer.borderWidth = 3.0
        layer.borderColor = SystemColor.blueColor.cgColor
        layer.cornerRadius = self.frame.width/2
        layer.masksToBounds = true
        alpha = 0.7
    }
    
}
