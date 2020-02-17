//
//  PasswordChangeViewController.swift
//  Bazis MADI
//
//  Created by Всеволод Андрющенко on 06.12.2019.
//  Copyright © 2019 Всеволод Андрющенко. All rights reserved.
//

import UIKit
import Foundation

class PasswordChangeViewController: UIViewController {

    @IBOutlet weak var oldPswTextField: LoginTextFieldUITextField!
    @IBOutlet weak var newPswTextField: LoginTextFieldUITextField!
    @IBOutlet weak var conformNewPswTextField: LoginTextFieldUITextField!
    @IBOutlet weak var errorMessLabel: ErrorLabel!
    @IBOutlet weak var changedPswButton: InputButton1UIButton!
    
    @IBOutlet weak var imgOld: UIImageView!
    @IBOutlet weak var imgConform: UIImageView!
    @IBOutlet weak var imgNew: UIImageView!
    let controller = PasswordChangeController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        controller.delegate = self
        setupView()
        addGesture()
    }
    
    //MARK: - настройка вешнего вида
    private func setupView() {
        
        changedPswButton.isEnabled = false
        let leftButton = UIBarButtonItem(title: "Назад", style: .done, target: self, action: #selector(backButtonPress))
        self.navigationItem.leftBarButtonItem = leftButton
        
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationController?.navigationBar.tintColor = SystemColor.whiteColor
        navigationController?.navigationBar.barTintColor = SystemColor.blueColor
    }
    
    //MARK: - жесты
    private func addGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapView(_:)))
        view.addGestureRecognizer(tap)
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
        controller.changePassword(oldPass: oldPas, newPass: newPas, conformPass: conformPas)
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
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        let oldPas = oldPswTextField.text!
        let newPas = newPswTextField.text!
        let conformPas = conformNewPswTextField.text!
        controller.controllPasswordField(oldPass: oldPas, newPass: newPas, conformPass: conformPas)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
}


//MARK: - контроллер работы с данными
extension PasswordChangeViewController: PasswordChangeViewProtocol {
    
    func presentStatusPswTextField(_ controller: PasswordChangeController, isPswOld: Bool?, isPswNew: Bool?, isPswConform: Bool?, isEnabletButton: Bool) {
        
        if let old = isPswOld {
            if old {
                imgOld.image = UIImage(named: "okPsw")
            } else {
                imgOld.image = UIImage(named: "errPsw")
            }
        } else {
            imgOld.image = UIImage(named: "noPsw")
        }
        if let new = isPswNew {
            if new {
                 imgNew.image = UIImage(named: "okPsw")
            } else {
                 imgNew.image = UIImage(named: "errPsw")
            }
        } else {
            imgNew.image = UIImage(named: "noPsw")
        }
        if let conform = isPswConform {
            if conform {
                imgConform.image = UIImage(named: "okPsw")
            } else {
                imgConform.image = UIImage(named: "errPsw")
            }
        } else {
            imgConform.image = UIImage(named: "noPsw")
        }
        
        changedPswButton.isEnabled = isEnabletButton
    }
    
    
    func showError(_ controller: PasswordChangeController, error: String) {
        changedPswButton.clickError()
        errorMessLabel.text = error
    }
    
    func dismisController(_ controller: PasswordChangeController) {
        
        let alertController = UIAlertController(title: nil, message: "Смена пароля успешно выполненна", preferredStyle: .alert)
        let alertOkButton = UIAlertAction(title: "Ок", style: .cancel) { (action) in
            let generator = UIImpactFeedbackGenerator(style: .heavy)
            generator.impactOccurred()
            
            self.navigationController?.popViewController(animated: true)
        }
        alertController.addAction(alertOkButton)
        self.present(alertController, animated: true, completion: nil)
    }
}
