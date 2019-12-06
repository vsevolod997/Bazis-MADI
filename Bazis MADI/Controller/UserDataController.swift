//
//  UserDataController.swift
//  Bazis MADI
//
//  Created by Всеволод Андрющенко on 05.12.2019.
//  Copyright © 2019 Всеволод Андрющенко. All rights reserved.
//

import Foundation

class UserDataController {
    
    let defaults = UserDefaults.standard
    
    // MARK: - сохранение данных логина
    func setUserData(user: UserLoginData) {
        defaults.set(user.login, forKey: "login")
        defaults.set(user.password, forKey: "password")
    }
    // MARK: - получение данных пользователя который заходил крайний раз
    func getUserData() -> UserLoginData? {
        let log = defaults.string(forKey: "login")
        let pas = defaults.string(forKey: "password")
        if let login = log, let password = pas {
            let userData = UserLoginData(login: login, password: password)
            return userData
        } else {
            return nil
        }
    }

    func clearUserData() {
        defaults.removeObject(forKey: "login")
        defaults.removeObject(forKey: "password")
    }
}
