//
//  Title3LabelUILAbel.swift
//  Bazis MADI
//
//  Created by Всеволод Андрющенко on 28.12.2019.
//  Copyright © 2019 Всеволод Андрющенко. All rights reserved.
//

import UIKit

class Title3LabelUILabel: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    fileprivate func setup() {
        font = UIFont(name: "Arial", size: 16)
        //font = UIFont.systemFont(ofSize: 15, weight: .regular)
        textColor = SystemColor.blueTextColor
    }

}
