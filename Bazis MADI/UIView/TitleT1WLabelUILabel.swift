//
//  TitleT1WLabelUILabel.swift
//  Bazis MADI
//
//  Created by Всеволод Андрющенко on 09.01.2020.
//  Copyright © 2020 Всеволод Андрющенко. All rights reserved.
//

import UIKit

class TitleT1WLabelUILabel: UILabel {
    
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
        textColor = .white
        textAlignment = .center
        numberOfLines = 2
    }
}
