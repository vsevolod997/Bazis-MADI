//
//  DetailStudentMainHttpService.swift
//  Bazis MADI
//
//  Created by Всеволод Андрющенко on 06.05.2020.
//  Copyright © 2020 Всеволод Андрющенко. All rights reserved.
//

import Foundation

class DetailStudentMainHttpService {
    
    class func selectReviewFile(nameFile: String, studUIC:String, reviewName: String, complition: @escaping(Error?, ResultModel?) -> Void) {
        
        let urlStr = "https://bazis.madi.ru/stud/api/file/desc"
        let body = "&p=\(nameFile)&uic=\(studUIC)&refadd=\(reviewName)"
        
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
