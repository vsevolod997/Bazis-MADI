//
//  IcoButtonUIButton.swift
//  Bazis MADI
//
//  Created by Всеволод Андрющенко on 06.04.2020.
//  Copyright © 2020 Всеволод Андрющенко. All rights reserved.
//

import UIKit
import AVFoundation

class IcoButtonUIButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
    override var isHighlighted: Bool {
        didSet {
            if isHighlighted {
                impact()
                alpha = 0.6
                transform = .init(scaleX: 0.9, y: 0.9)
            } else {
                alpha = 1
                transform = .init(scaleX: 1, y: 1)
            }
        }
    }
    
    private func impact() {
        let generator = UIImpactFeedbackGenerator(style: .rigid)
        generator.impactOccurred()
    }
    
}
