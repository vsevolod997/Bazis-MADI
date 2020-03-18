//
//  PorfolioHttpService.swift
//  Bazis MADI
//
//  Created by Всеволод Андрющенко on 03.03.2020.
//  Copyright © 2020 Всеволод Андрющенко. All rights reserved.
//

import Foundation

class PorfolioHttpService {
    
    class func getPortfolioData(complition: @escaping(Error?, PortfolioModel?) -> Void) {
        let urlStr = "https://bazis.madi.ru/stud/api/stud/portfolio"
        guard let urlsStr =  urlStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        let url = URL(string: urlsStr)!
        let urlReqest = URLRequest(url: url)
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
    
    
    class func setPortfolioData(portfolio: PortfolioModel,complition: @escaping(Error?, String?) -> Void) {
        
        let urlStr = "https://bazis.madi.ru/stud/api/stud/portfolio"
        guard let urlsStr =  urlStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        let url = URL(string: urlsStr)!
        
        var educUnvarp:[[String]] = []
        for mass in portfolio.educ {
            var masUnvarp:[String] = []
            for elem in mass {
                if let okElem = elem {
                    masUnvarp.append(okElem)
                } else {
                    masUnvarp.append(" ")
                }
            }
            educUnvarp.append(masUnvarp)
        }
        
        var workUnvarp:[[String]] = []
        for mass in portfolio.work {
            var masUnvarp:[String] = []
            for elem in mass {
                if let okElem = elem {
                    masUnvarp.append(okElem)
                } else {
                    masUnvarp.append(" ")
                }
            }
            workUnvarp.append(masUnvarp)
        }
        
        var postString = "save=1&ldata=\(String(describing: portfolio.ldata!))&wpost=\(String(describing: portfolio.wpost!))&wprice=\(String(describing: portfolio.wprice!))&educ="
        postString += educUnvarp.description
        postString += "&work=" + workUnvarp.description
        print(postString)
        var urlReqest = URLRequest(url: url)
        urlReqest.httpMethod = "POST"
        urlReqest.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: urlReqest) { (data, response, error) in
            if let err = error {
                complition(err, nil)
            } else {
                guard let datas = data else { return }
                do {
                    complition(nil, String(data: datas, encoding: .utf8))
                }
            }
        }
        task.resume()
    }
}
