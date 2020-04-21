//
//  ViewController.swift
//  Bazis MADI
//
//  Created by Всеволод Андрющенко on 27.11.2019.
//  Copyright © 2019 Всеволод Андрющенко. All rights reserved.
//

import UIKit
import AVFoundation

class LoginViewController: UIViewController {

    @IBOutlet weak var loginTextField: LoginTextFieldUITextField!
    @IBOutlet weak var passworldTextField: LoginTextFieldUITextField!
    @IBOutlet weak var inputButton: InputButton1UIButton!
    @IBOutlet weak var errorLabel: ErrorLabel!
    
    private var controller = LoginController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        controller.delegate = self
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapView(_:)))
        view.addGestureRecognizer(tap)
    }

    @objc func tapView(_ gestueRecognizer: UITapGestureRecognizer){
        view.endEditing(true)
    }
    
    //MARK: - нажатие кнопки входа
    @IBAction func inputButton(_ sender: Any) {
        let login = loginTextField.text
        let psw = passworldTextField.text
        
        controller.loginUser(login: login, password: psw)
    }
    
    //MARK: - нажатие кнопки не могу войти
    @IBAction func forgetPassword(_ sender: Any) {
        controller.userForgot()
    }
}
//MARK: - LoginController UITextFieldDelegate
extension LoginViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == loginTextField {
            errorLabel.text = ""
            loginTextField.text = ""
        }
        if textField == passworldTextField {
            errorLabel.text = ""
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

//MARK: - LoginController LoginViewProtiocol
extension LoginViewController: LoginViewDelegate {
    func showNextView(_ controller: LoginController, view: UIViewController, data: UserModel) {
        view.modalPresentationStyle = .fullScreen
        present(view, animated: true)
    }
    
    func showError(_ controller: LoginController, error: String) {
        errorLabel.text = error
        inputButton.clickError()
        
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.impactOccurred()
    }
    
}
