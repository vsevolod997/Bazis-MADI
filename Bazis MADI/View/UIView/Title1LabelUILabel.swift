//
//  Title1LabelUILabel.swift
//  Bazis MADI
//
//  Created by Всеволод Андрющенко on 27.11.2019.
//  Copyright © 2019 Всеволод Андрющенко. All rights reserved.
//

import UIKit

class Title1LabelUILabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    fileprivate func setup() {
        font = UIFont(name: "Arial Rounded MT Bold", size: 22)
        textColor = SystemColor.blueColor
    }
    
}
