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
    // MARK: - пароль успешно изменен, скрытие окна смены пароля
    func dismisController(_ controller: PasswordChangeController)
    //MARK: - отображение "статуса введенных данных"
    func presentStatusPswTextField(_ controller: PasswordChangeController, isPswOld: Bool?, isPswNew: Bool?, isPswConform: Bool?, isEnabletButton: Bool)
}

class PasswordChangeController {
    
    let userController = UserDataController()
   
    public var delegate: PasswordChangeViewProtocol?
    
    func changePassword(oldPass: String, newPass: String, conformPass: String) {
        
        let userData = UserDataController()
        guard let user = userData.getUserData() else { return }
        
        
        if oldPass != user.password {
            presentError(mess: "Текущий пароль введен не верно")
            return
        }
        
        if newPass.count < 6 || conformPass.count < 6 {
            presentError(mess: "Новый пароль долже состоять из 6 и более символов")
            return
        }
        
        if newPass != conformPass {
            presentError(mess: "Введенные пароли не совпадают")
            return
        } else {
            setNewPass(newPas: newPass)
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
       
        if oldPass == "" || newPass == "" || conformPass == "" {
            isButtonEnabled = false
        } else {
            isButtonEnabled = true
        }
        delegate?.presentStatusPswTextField(self, isPswOld: isOkOldPsw, isPswNew: isOkNewPsw, isPswConform: isOkConform, isEnabletButton: isButtonEnabled)
    }
    
    private func setNewPass(newPas: String) {
        HTTPServicePasswordChanged.paswordChanged(newPassword: newPas) { (eror, modelChanged) in
            if eror != nil {
                DispatchQueue.main.async {
                    self.presentError(mess: "Произошла ошибка, возможно отсутствует интернет соединение!")
                }
            } else {
                guard let model = modelChanged else { return }
                switch model.err {
                case 0:
                    self.userController.setNewPassword(newPassword: newPas)
                    DispatchQueue.main.async {
                        self.delegate?.dismisController(self)
                    }
                case 1:
                    DispatchQueue.main.async {
                        self.presentError(mess: "Ошибка сервера, повторите попытку позже!")
                    }
                default:
                    return
                }
            }
        }
    }
    
    private func presentError(mess: String) {
        delegate?.showError(self, error: mess)
    }
}
