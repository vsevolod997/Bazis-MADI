//
//  ViewController.swift
//  Bazis MADI
//
//  Created by Всеволод Андрющенко on 27.11.2019.
//  Copyright © 2019 Всеволод Андрющенко. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    
    @IBOutlet weak var loginTextField: LoginTextFieldUITextField!
    
    @IBOutlet weak var passworldTextField: LoginTextFieldUITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapView(_:)))
        view.addGestureRecognizer(tap)
    }


    @objc func tapView(_ gestueRecognizer: UITapGestureRecognizer){
        view.endEditing(true)
        print("tap")
    }
    @IBAction func inputButton(_ sender: Any) {
    }
    @IBAction func forgetPassword(_ sender: Any) {
    }
    
}

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == loginTextField {
            loginTextField.text = ""
        }
        if textField == passworldTextField {
            passworldTextField.text = ""
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == loginTextField {
            loginTextField.resignFirstResponder()
            passworldTextField.becomeFirstResponder()
        }
        if textField == passworldTextField {
            passworldTextField.resignFirstResponder()
            
        }
        return true
    }
    
}
