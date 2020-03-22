//
//  CardInCellUIView.swift
//  Bazis MADI
//
//  Created by Всеволод Андрющенко on 07.03.2020.
//  Copyright © 2020 Всеволод Андрющенко. All rights reserved.
//

import UIKit

class CardInCellUIView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }

    
    private func setupView() {
        backgroundColor = SystemColor.colorFill
        layer.cornerRadius = 10
        
        //layer.shadowColor = SystemColor.shadowColor.cgColor
        //layer.shadowRadius = 5
        //layer.shadowOffset = CGSize(width: 0.5, height: 0.5)
        //layer.shadowOpacity = 0.6
    }
    
}
