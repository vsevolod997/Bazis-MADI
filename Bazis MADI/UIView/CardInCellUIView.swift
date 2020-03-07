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
        self.backgroundColor = SystemColor.whiteTextFill
        self.layer.cornerRadius = 20
        
        self.layer.shadowColor = SystemColor.grayColor.cgColor
        self.layer.shadowRadius = 5
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowOpacity = 0.6
    }
    
}
