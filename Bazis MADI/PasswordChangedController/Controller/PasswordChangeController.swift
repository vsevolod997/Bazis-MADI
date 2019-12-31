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
}

class PasswordChangeController {
   
    public var delegate: PasswordChangeViewProtocol?
    
    func changePassword(oldPass: String, newPassword: String, conformPass: String) {
        
        let userData = UserDataController()
        if let pswNow = userData.getUserData() {
            if oldPass != pswNow.password {
                presentError(mess: "Введен неверный пароль.")
                return
            }
        }
        if newPassword != conformPass{
            presentError(mess: "Пароли не совпадают.")
            return
        } else {
            if newPassword.count > 6 {
                presentError(mess: "Минимальная длинна пароля 6 символов.")
                return
            }
            var isInt: Bool = false
            for i in newPassword {
                if Int(String(i)) != nil {
                    isInt = true
                }
            }
            
            if isInt != true {
                presentError(mess: "Пароль не подходит по требованиям безопастности")
            } else {
                setNewPass(pas: newPassword)
            }
            
        }
    }
    
    private func setNewPass(pas: String) {
        
    }
    
    
    private func presentError(mess: String) {
        delegate?.showError(self, error: mess)
    }
}
