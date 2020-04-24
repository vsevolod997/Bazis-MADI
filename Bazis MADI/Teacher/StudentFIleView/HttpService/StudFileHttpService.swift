//
//  StudFileHttpService.swift
//  Bazis MADI
//
//  Created by Всеволод Андрющенко on 22.04.2020.
//  Copyright © 2020 Всеволод Андрющенко. All rights reserved.
//

import Foundation


class StudFileHttpService {
    
    class func getFileData(stdentUIC:String,  complition: @escaping(Error?, [FileModel]?) -> Void) {
        let body = "uic=\(stdentUIC)"
        let urlStr = "https://bazis.madi.ru/stud/api/file/files"
        guard let urlsStr =  urlStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        let url = URL(string: urlsStr)!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.httpBody = body.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let err = error {
                complition(err, nil)
            } else {
                guard let datas = data else { return }
                do {
                    if let strResult = String(data: datas, encoding: .utf8) {
                        if strResult.count > 3 {
                            let dataEncode = try JSONDecoder().decode(Array<FileModel>.self, from: datas)
                            complition(nil, dataEncode)
                        } else {
                            complition(nil, nil)
                        }
                    }
                } catch let jsonError {
                    complition(jsonError, nil)
                }
            }
        }
        task.resume()
    }
}
