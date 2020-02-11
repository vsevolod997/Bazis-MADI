//
//  ChangePasswordController.swift
//  Bazis MADI
//
//  Created by Всеволод Андрющенко on 07.12.2019.
//  Copyright © 2019 Всеволод Андрющенко. All rights reserved.
//

import Foundation

protocol PasswordChangeViewProtocol {
    // MARK: - ошибка смены пароля
    func showError(_ controller: PasswordChangeController, error: String)
    // MARK: - показать
    func dismisController(_ controller: PasswordChangeController)
    //MARK: - отображение "статуса введенных данных"
    func presentStatusPswTextField(_ controller: PasswordChangeController, isPswOld: Bool?, isPswNew: Bool?, isPswConform: Bool?, isEnabletButton: Bool)
}

class PasswordChangeController {
    
    let userController = UserDataController()
   
    public var delegate: PasswordChangeViewProtocol?
    
    func changePassword(oldPass: String, newPass: String, conformPass: String) {
        
        let userData = UserDataController()
        if let pswNow = userData.getUserData() {
            if oldPass != pswNow.password {
                presentError(mess: "Введен неверный пароль.")
                return
            }
        }
        if newPass != conformPass{
            presentError(mess: "Пароли не совпадают.")
            return
        } else {
            if newPass.count > 6 {
                presentError(mess: "Минимальная длинна пароля 6 символов.")
                return
            }
            var isInt: Bool = false
            for i in newPass {
                if Int(String(i)) != nil {
                    isInt = true
                }
            }
            
            if isInt != true {
                presentError(mess: "Пароль не подходит по требованиям безопастности")
            } else {
                setNewPass(pas: newPass)
            }
            
        }
    }
    
    func controllPasswordField(oldPass: String, newPass: String, conformPass: String) {
        
        var isOkOldPsw: Bool?
        var isOkNewPsw: Bool?
        var isOkConform: Bool?
        
        guard let userPassword = userController.getUserData() else { return }
        if oldPass != "" {
            if oldPass == userPassword.password {
                isOkOldPsw = true
            } else {
                isOkOldPsw = false
            }
        }
        
        if newPass != ""  {
            if newPass.count > 6 {
                isOkNewPsw = true
            } else {
                isOkNewPsw = false
            }
        }
        
        if conformPass != "" {
            if newPass == conformPass {
                isOkConform = isOkNewPsw
            } else {
                isOkConform = false
            }
        }
        
        var isButtonEnabled: Bool = false
        if let passOld = isOkOldPsw, let passNew = isOkNewPsw, let passConf = isOkConform {
            isButtonEnabled = passOld && passNew && passConf
        } else {
            isButtonEnabled = false 
        }

        delegate?.presentStatusPswTextField(self, isPswOld: isOkOldPsw, isPswNew: isOkNewPsw, isPswConform: isOkConform, isEnabletButton: isButtonEnabled)
    }
    
    private func setNewPass(pas: String) {
        
    }
    
    private func presentError(mess: String) {
        delegate?.showError(self, error: mess)
    }
}
