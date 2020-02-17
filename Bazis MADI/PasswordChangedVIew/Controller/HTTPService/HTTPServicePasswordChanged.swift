//
//  HTTPServicePasswordChanged.swift
//  Bazis MADI
//
//  Created by Всеволод Андрющенко on 10.02.2020.
//  Copyright © 2020 Всеволод Андрющенко. All rights reserved.
//

import Foundation

class HTTPServicePasswordChanged {
    
    //MARK: - сменить пароль
    class func paswordChanged(newPassword: String, completion: @escaping(Error?, NewPassModel?)->Void){
        
        let postString = "exec=wLoginSave&psw=\(newPassword)"
        let urlStr = "https://bazis.madi.ru/stud/_exec.php"
        guard let url = URL(string: urlStr) else {return}
        var urlReqest = URLRequest(url: url)
        urlReqest.httpMethod = "POST"
        urlReqest.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: urlReqest) { (data, response, error) in
            if let err = error {
                completion(err, nil)
            } else {
                guard let datas = data else { return }
                print(String(data: datas, encoding: .utf8))
                do{
                    let data = try JSONDecoder().decode(NewPassModel.self, from: datas)
                    completion(nil, data)
                } catch let jsonError {
                    completion(jsonError, nil)
                }
            }
        }
        task.resume()
    }
    
}
