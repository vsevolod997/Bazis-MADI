//
//  ShowMoreUIButton.swift
//  Bazis MADI
//
//  Created by Всеволод Андрющенко on 28.02.2020.
//  Copyright © 2020 Всеволод Андрющенко. All rights reserved.
//

import UIKit

class ShowMoreUIButton: UIButton {

       override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        setImage(UIImage(named: "buttonArrow"), for: .normal)
        setTitle("Все", for: .normal)
        titleLabel?.font =  UIFont.boldSystemFont(ofSize: 18)
        setTitleColor(SystemColor.blueTextColor, for: .normal)
        imageEdgeInsets = UIEdgeInsets(top: 7, left: 63, bottom: 5, right: 20)
    }
    
    override var isHighlighted: Bool {
        didSet {
            if isHighlighted {
                alpha = 0.6
                transform = .init(scaleX: 0.9, y: 0.9)
            } else {
                alpha = 0.9
                transform = .init(scaleX: 1, y: 1)
            }
        }
    }
}
