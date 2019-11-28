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
    
    fileprivate func setup(){
        font = UIFont(name: "HelveticaNeue", size: 32)
        textColor = UIColor(#colorLiteral(red: 0.01158582047, green: 0.3091317415, blue: 0.5136013627, alpha: 1))
    }
    
}
