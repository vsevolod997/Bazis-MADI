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
    
    private func setup(){
        borderStyle = .none
        backgroundColor = .white
        layer.cornerRadius = 12
        textAlignment = .center
        
        font = UIFont(name: "Arial", size: 18)
        textColor = UIColor(#colorLiteral(red: 0, green: 0.3093259037, blue: 0.5303913355, alpha: 1))
    }
    

}
