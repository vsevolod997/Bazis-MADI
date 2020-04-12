//
//  TeacherFileHTTPService.swift
//  Bazis MADI
//
//  Created by Всеволод Андрющенко on 12.04.2020.
//  Copyright © 2020 Всеволод Андрющенко. All rights reserved.
//

import Foundation

class TeacherFileHTTPService {
    
    class func createFileDirectory(path: String, complition: @escaping(Error?, ResultModel?) -> Void) {
        let urlStr = "https://bazis.madi.ru/stud/api/file/mkdir"
        let body = "path=\(path)"
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
                do {
                    let dataEncode = try JSONDecoder().decode(ResultModel.self, from: datas)
                    complition(nil, dataEncode)
                } catch let jsonError {
                    complition(jsonError, nil)
                }
            }
        }
        task.resume()
    }
}

struct ResultModel: Decodable {
    var result: Bool
}

