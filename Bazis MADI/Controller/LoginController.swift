//
//  LoginProtocol.swift
//  Bazis MADI
//
//  Created by Всеволод Андрющенко on 29.11.2019.
//  Copyright © 2019 Всеволод Андрющенко. All rights reserved.
//

import UIKit

// MARK: -  подписать VC логина
protocol LoginViewProtocol {
    // MARK: - ошибка логина
    func showError(_ controller: LoginController, error: String)
    // MARK: - показать след VC
    func showNextView(_ controller: LoginController, view: UIViewController, data: UserModel)
}

class LoginController {
    
    public var delegate: LoginViewProtocol?
    
    // MARK: -  вход в аккаунт пользователя
    func loginUser(login: String?, password: String?) {
        if let log = login, let pas = password {
            if log == "" {
                error(message: "Логин не введен!")
                return
            }
            if pas == "" {
                error(message: "Пароль не введен!")
                return
            }
            
            HttpService.getUserAccount(login: log, password: pas) { (error, userModel, errorUser) in
                if error != nil{
                    DispatchQueue.main.async {
                        self.error(message: "Сервер не отвечает!, пожалуйста повторите попытку позже!")
                    }
                } else {
                    if errorUser != nil{
                        DispatchQueue.main.async {
                            self.error(message: "Введен неверный логин или пароль!")
                        }
                    } else {
                        guard let user = userModel else { return }
                        DispatchQueue.main.async {
                            UserLogin.userNow.user = user
                            let sb = UIStoryboard(name: "Main", bundle: nil)
                            let view = sb.instantiateViewController(identifier: "studUser")
                            self.delegate?.showNextView(self, view: view, data: user)
                        }
                    }
                }
            }
        }
    }
    // MARK: -  восстановлкние пароля
    func userForgot() {
        print(" i cant go on")
    }
    
    fileprivate func error(message: String) {
        delegate?.showError(self ,error: message)
    }
    
}
