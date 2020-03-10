//
//  Title5LabelUILabel.swift
//  Bazis MADI
//
//  Created by Всеволод Андрющенко on 19.01.2020.
//  Copyright © 2020 Всеволод Андрющенко. All rights reserved.
//

import UIKit

class Title5LabelUILabel: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    fileprivate func setup() {
        font = UIFont(name: "Title 2", size: 24)
        textColor = SystemColor.grayColor
    }
}
