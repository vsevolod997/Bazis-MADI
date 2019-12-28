//
//  Title2LabelUILabel.swift
//  Bazis MADI
//
//  Created by Всеволод Андрющенко on 27.11.2019.
//  Copyright © 2019 Всеволод Андрющенко. All rights reserved.
//

import UIKit

class Title2LabelUILabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    fileprivate func setup() {
        font = UIFont(name: "Arial", size: 14)
        textColor = SystemColor.grayColor
    }
    
}
