//
//  SelectionUIView.swift
//  Bazis MADI
//
//  Created by Всеволод Андрющенко on 06.05.2020.
//  Copyright © 2020 Всеволод Андрющенко. All rights reserved.
//

import UIKit

class SelectionUIView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    private func setupView() {
        let radious = self.frame.height / 2
        layer.cornerRadius = radious
        layer.borderWidth = 1
        layer.borderColor = SystemColor.shadowColor.cgColor
        
        backgroundColor = .clear
    }
    
    public func selectStyle() {
        self.backgroundColor = SystemColor.greenColor
    }
    
    public func deSelectStyle() {
        self.backgroundColor = .clear
    }

}
