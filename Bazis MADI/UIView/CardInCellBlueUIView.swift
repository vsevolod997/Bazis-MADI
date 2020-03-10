//
//  CardInCellBlueUIView.swift
//  Bazis MADI
//
//  Created by Всеволод Андрющенко on 10.03.2020.
//  Copyright © 2020 Всеволод Андрющенко. All rights reserved.
//

import UIKit

class CardInCellBlueUIView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    private func setupView() {
        clipsToBounds = false
        layer.cornerRadius = 20
        layer.maskedCorners = [.layerMinXMaxYCorner , .layerMaxXMaxYCorner]
    }
}
