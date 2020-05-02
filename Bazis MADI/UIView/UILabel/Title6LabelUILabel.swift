//
//  Title6LabelUILabel.swift
//  Bazis MADI
//
//  Created by Всеволод Андрющенко on 20.02.2020.
//  Copyright © 2020 Всеволод Андрющенко. All rights reserved.
//

import UIKit

class Title6LabelUILabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    fileprivate func setup() {
        font = UIFont.boldSystemFont(ofSize: 24)
        textColor = SystemColor.blueColor
    }
}
