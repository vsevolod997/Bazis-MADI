//
//  LoginTextFIeldUITextField.swift
//  Bazis MADI
//
//  Created by Всеволод Андрющенко on 28.11.2019.
//  Copyright © 2019 Всеволод Андрющенко. All rights reserved.
//

import UIKit

class LoginTextFieldUITextField: UITextField {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        borderStyle = .none
        backgroundColor = SystemColor.whiteTextFill
        layer.cornerRadius = 12
        textAlignment = .center
        
        font = UIFont(name: "Arial", size: 18)
        textColor = SystemColor.blueTextColor
    }
    

}
