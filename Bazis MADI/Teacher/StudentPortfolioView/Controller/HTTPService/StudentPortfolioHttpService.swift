//
//  StudentPortfolioHttpService.swift
//  Bazis MADI
//
//  Created by Всеволод Андрющенко on 14.04.2020.
//  Copyright © 2020 Всеволод Андрющенко. All rights reserved.
//

import Foundation

class StudentPortfolioHttpService {
    
    class func getPortfolioData(uic: String, complition: @escaping(Error?, PortfolioModel?) -> Void) {
        let urlStr = "https://bazis.madi.ru/stud/api/stud/portfolio"
        guard let urlsStr =  urlStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        let url = URL(string: urlsStr)!
        var urlReqest = URLRequest(url: url)
        urlReqest.httpMethod = "POST"
        let body = "uic=\(uic)"
        urlReqest.httpBody = body.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: urlReqest) { (data, response, error) in
            if let err = error {
                complition(err, nil)
            } else {
                guard let datas = data else { return }
                do {
                    let dataEncode = try JSONDecoder().decode(PortfolioModel.self, from: datas)
                    complition(nil, dataEncode)
                } catch let jsonError {
                    complition(jsonError, nil)
                }
            }
        }
        task.resume()
    }
}
