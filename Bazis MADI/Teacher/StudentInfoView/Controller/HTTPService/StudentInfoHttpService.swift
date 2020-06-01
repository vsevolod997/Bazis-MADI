//
//  StudentInfoHttpService.swift
//  Bazis MADI
//
//  Created by Всеволод Андрющенко on 01.06.2020.
//  Copyright © 2020 Всеволод Андрющенко. All rights reserved.
//

import Foundation


class StudentInfoHttpService {
    
    class func getFullInfo(uicStudent: String, complition: @escaping(Error?, FullStudInfoModel?) -> Void){
        let urlStr = "https://bazis.madi.ru/stud/api/stud/info"
        let body = "uic=\(uicStudent)"
        guard let urlsStr =  urlStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        let url = URL(string: urlsStr)!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpBody = body.data(using: .utf8)
        urlRequest.httpMethod = "POST"
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let err = error {
                complition(err, nil)
            } else {
                guard let datas = data else { return }
                if let json = try? JSONSerialization.jsonObject(with: datas, options: .mutableContainers) {
                    let result = FullStudInfoModel.convertJson(json: json)
                    complition(nil, result)
                }
            }
        }
        task.resume()
    }
}
