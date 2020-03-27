//
//  EditingTextFieldUITextField.swift
//  Bazis MADI
//
//  Created by Всеволод Андрющенко on 04.03.2020.
//  Copyright © 2020 Всеволод Андрющенко. All rights reserved.
//

import UIKit

class EditingTextFieldUITextField: UITextField {

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
    private func setup() {
        //font = UIFont(name: "Arial", size: 18)
        font = UIFont.systemFont(ofSize: 18, weight: .medium)
        textColor = SystemColor.blueTextColor
        backgroundColor = SystemColor.whiteTextFill
    }
    
    override var isEnabled: Bool {
        didSet {
            if isEnabled {
                self.borderStyle = .roundedRect
            } else {
                self.borderStyle = .none
            }
        }
    }
}
