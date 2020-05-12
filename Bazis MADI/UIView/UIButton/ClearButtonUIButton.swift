//
//  ClaerButtonUIButton.swift
//  Bazis MADI
//
//  Created by Всеволод Андрющенко on 12.05.2020.
//  Copyright © 2020 Всеволод Андрющенко. All rights reserved.
//

import UIKit

class ClearButtonUIButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    
    override var isHighlighted: Bool {
        didSet {
            if isHighlighted {
                backgroundColor = .systemBlue
                alpha = 0.2
            } else {
                backgroundColor = .clear
               alpha = 0.2
            }
        }
    }
        
}
