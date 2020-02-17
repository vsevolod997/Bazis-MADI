//
//  SessionLoginController.swift
//  Bazis MADI
//
//  Created by Всеволод Андрющенко on 29.11.2019.
//  Copyright © 2019 Всеволод Андрющенко. All rights reserved.
//

import Foundation

class HttpService {
    //MARK: - метод логина пользователя 
    class func getUserAccount(login: String, password: String, completion: @escaping(Error?, UserModel?, UserModelError?)->Void){
        
        let userData = UserDataController()
        
        let postString = "json=1&psw=\(password)&usr=\(login)"
        let urlStr = "https://bazis.madi.ru/stud/login.php"
        guard let url = URL(string: urlStr) else {return}
        var urlReqest = URLRequest(url: url)
        urlReqest.httpMethod = "POST"
        urlReqest.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: urlReqest) { (data, response, error) in
            if let err = error {
                completion(err, nil, nil)
            } else {
                guard let datas = data else { return }
                do{
                    let data = try JSONDecoder().decode(UserModel.self, from: datas)
                    
                    let userLogin = UserLoginData(login: login, password: password, typeUser: data.user_type)
                    userData.setUserData(user: userLogin)//запоминаем логин и пароль
                    //key.setSessionKey(response: response)
                    UserLogin.userNow.user = data
                    completion(nil, data, nil)
                    
                } catch let jsonError {
                    completion(jsonError, nil, nil)
                    do{
                        let err = try JSONDecoder().decode(UserModelError.self, from: datas)
                        completion(nil, nil, err)
                    }
                    catch let jsonErr {
                        completion(jsonErr, nil, nil)
                    }
                }
            }
        }
        task.resume()
    }
}
