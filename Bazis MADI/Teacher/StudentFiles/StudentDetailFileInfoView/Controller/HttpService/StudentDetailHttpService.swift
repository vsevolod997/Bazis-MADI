//
//  StudentDetailHttpService.swift
//  Bazis MADI
//
//  Created by Всеволод Андрющенко on 27.04.2020.
//  Copyright © 2020 Всеволод Андрющенко. All rights reserved.
//

import Foundation


class StudentDetailHttpService {
    
    class func getFileDesc(nameFile: String, studUIC:String, complition: @escaping(Error?, DescModel?) -> Void) {
        let urlStr = "https://bazis.madi.ru/stud/api/file/desc"
        guard let urlsStr =  urlStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        let url = URL(string: urlsStr)!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.httpBody = "&p=\(nameFile)&uic=\(studUIC)".data(using: .utf8)
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let err = error {
                complition(err, nil)
            } else {
                guard let datas = data else { return }
                do {
                    let dataEncode = try JSONDecoder().decode(DescModel.self, from: datas)
                    complition(nil, dataEncode)
                } catch let jsonError {
                    complition(jsonError, nil)
                }
            }
        }
        task.resume()
    }
}
