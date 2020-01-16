//
//  MessegeButton.swift
//  Bazis MADI
//
//  Created by Всеволод Андрющенко on 15.01.2020.
//  Copyright © 2020 Всеволод Андрющенко. All rights reserved.
//

import UIKit

class MessegeButtonUIButton: UIButton {

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        setStyle()
    }
    
    private func setStyle() {
        let textColor = SystemColor.whiteColor
        setTitleColor(textColor, for: .normal)
        titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        backgroundColor = SystemColor.blueColor
        setImage(UIImage(named: "chat")?.withRenderingMode(.alwaysTemplate), for: .normal)
        tintColor = SystemColor.whiteColor
        layer.cornerRadius = 5
    }
    
    override var isHighlighted: Bool {
        didSet {
            if isHighlighted {
                alpha = 0.6
                transform = .init(scaleX: 0.9, y: 0.9)
            } else {
                alpha = 1
                transform = .init(scaleX: 1, y: 1)
            }
        }
    }

}
