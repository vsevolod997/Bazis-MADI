//
//  AddDellUIButton.swift
//  Bazis MADI
//
//  Created by Всеволод Андрющенко on 30.04.2020.
//  Copyright © 2020 Всеволод Андрющенко. All rights reserved.
//

import UIKit

class AddDellUIButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        setAddStyle()
    }
    
    public func setAddStyle() {
        let textColor = SystemColor.whiteColor
        setTitleColor(textColor, for: .normal)
        titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        setTitle("Добавить", for: .normal)
        backgroundColor = SystemColor.greenColor
        layer.cornerRadius = 15
        alpha = 0.9
    }
    
    public func setDellStyle() {
        setTitle("Удалить", for: .normal)
        backgroundColor = SystemColor.redColor
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
    
    override var isEnabled: Bool {
        didSet {
            if isEnabled {
                backgroundColor = SystemColor.greenColor
                alpha = 0.9
            } else {
                alpha = 0.6
                backgroundColor = SystemColor.grayColor
            }
        }
    }
}
