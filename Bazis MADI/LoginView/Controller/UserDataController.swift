//
//  UserDataController.swift
//  Bazis MADI
//
//  Created by Всеволод Андрющенко on 05.12.2019.
//  Copyright © 2019 Всеволод Андрющенко. All rights reserved.
//

import Foundation

//MARK: - класс для работы с аккаунтом
class UserDataController {
    
    let defaults = UserDefaults.standard
    
    // MARK: - сохранение данных логина
    func setUserData(user: UserLoginData) {
        defaults.set(user.login, forKey: "login")
        defaults.set(user.password, forKey: "password")
        defaults.set(user.typeUser, forKey: "typeUser")
    }
    // MARK: - получение данных пользователя который заходил крайний раз
    func getUserData() -> UserLoginData? {
        let log = defaults.string(forKey: "login")
        let pas = defaults.string(forKey: "password")
        let type = defaults.string(forKey: "typeUser")
        if let login = log, let password = pas, let userType = type {
            let userData = UserLoginData(login: login, password: password, typeUser: userType)
            return userData
        } else {
            return nil
        }
    }
    
    func setNewPassword(newPassword: String) {
        defaults.removeObject(forKey: "password")
        defaults.set(newPassword, forKey: "password")
    }

    func clearUserData() {
        defaults.removeObject(forKey: "login")
        defaults.removeObject(forKey: "password")
        defaults.removeObject(forKey: "typeUser")
        defaults.removeObject(forKey: "key")
    }
}
