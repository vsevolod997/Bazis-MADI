//
//  PasswordChangeViewController.swift
//  Bazis MADI
//
//  Created by Всеволод Андрющенко on 06.12.2019.
//  Copyright © 2019 Всеволод Андрющенко. All rights reserved.
//

import UIKit

class PasswordChangeViewController: UIViewController {

    @IBOutlet weak var oldPswTextField: LoginTextFieldUITextField!
    @IBOutlet weak var newPswTextField: LoginTextFieldUITextField!
    @IBOutlet weak var conformNewPswTextField: LoginTextFieldUITextField!
    @IBOutlet weak var errorMessLabel: ErrorLabel!
    
    let controller = PasswordChangeController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        controller.delegate = self
        setupView()
    }
    
    private func setupView() {
        let leftButton = UIBarButtonItem(title: "Назад", style: .done, target: self, action: #selector(backButtonPress))
        self.navigationItem.leftBarButtonItem = leftButton
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapView(_:)))
        view.addGestureRecognizer(tap)
        
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.barTintColor = SystemColor.blueColor
    }
    
    @objc func backButtonPress() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func tapView(_ gestueRecognizer: UITapGestureRecognizer){
        view.endEditing(true)
    }
    
    @IBAction func ChangedPaswordButton(_ sender: Any) {
        let oldPas = oldPswTextField.text!
        let newPas = newPswTextField.text!
        let conformPas = conformNewPswTextField.text!
        controller.changePassword(oldPass: oldPas, newPassword: newPas, conformPass: conformPas)
    }
}

//MARK: - UITextFieldDelegate
extension PasswordChangeViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == oldPswTextField {
            oldPswTextField.text = ""
        }
        
        if textField == newPswTextField {
            newPswTextField.text = ""
        }
        
        if textField == conformNewPswTextField {
            conformNewPswTextField.text = ""
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
}

extension PasswordChangeViewController: PasswordChangeViewProtocol {
    
    func showError(_ controller: PasswordChangeController, error: String) {
        errorMessLabel.text = error
        print(error)
    }
    
    func dismisController(_ controller: PasswordChangeController) {
        print("dismis")
    }
}
