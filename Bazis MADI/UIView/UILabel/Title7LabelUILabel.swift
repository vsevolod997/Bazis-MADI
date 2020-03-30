//
//  Title7LabelUILabel.swift
//  Bazis MADI
//
//  Created by Всеволод Андрющенко on 25.03.2020.
//  Copyright © 2020 Всеволод Андрющенко. All rights reserved.
//

import UIKit

class Title7LabelUILabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    fileprivate func setup() {
        //font = UIFont.systemFont(ofSize: 11)
        font = UIFont.systemFont(ofSize: 11, weight: .semibold)
        textColor = SystemColor.grayColor
        alpha = 0.7
    }
}
