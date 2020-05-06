//
//  CancellAddButton.swift
//  Bazis MADI
//
//  Created by Всеволод Андрющенко on 04.05.2020.
//  Copyright © 2020 Всеволод Андрющенко. All rights reserved.
//

import UIKit

class CancellAddButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        setCancellStyle()
    }
    
    public func setAddStyle() {
        let textColor = SystemColor.whiteColor
        setTitleColor(textColor, for: .normal)
        titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        setTitle("Выбрать", for: .normal)
        backgroundColor = SystemColor.blueColor
        layer.cornerRadius = 15
        alpha = 0.9
    }
    
    public func setCancellStyle() {
        setTitle("Отмена", for: .normal)
        titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        backgroundColor = SystemColor.grayColor
        layer.cornerRadius = 15
        alpha = 0.9
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

