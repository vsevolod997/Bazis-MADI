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
    
    
    class func setPortfolioData(portfolio: PortfolioModel,complition: @escaping(Error?, String?) -> Void) {
        
        let urlStr = "https://bazis.madi.ru/stud/api/stud/portfolio"
        guard let urlsStr =  urlStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        let url = URL(string: urlsStr)!
        
        
        // создаем новую модель данных
        var educationMas:[Educ] = []
        for elemMass in portfolio.educ {
            let elem = Educ(beg: elemMass[0],
                               end: elemMass[1],
                               vuz: elemMass[2],
                               level: elemMass[3],
                               spec: elemMass[4],
                               prn: elemMass[5])
            
            educationMas.append(elem)
        }

        var workMas:[Work] = []
        for elemMass in portfolio.work {
            let elemMas = Work(beg: elemMass[0],
                               end: elemMass[1],
                               post: elemMass[2],
                               firm: elemMass[3],
                               napr: elemMass[4],
                               town: elemMass[5],
                               prn: elemMass[6])
            
            workMas.append(elemMas)
        }
        
        let newDataSet = PortfolioToSent(save: "1", ldata: portfolio.ldata, wpost: portfolio.wpost, wprice: portfolio.wprice, educ: educationMas, work: workMas)
        
        var urlReqest = URLRequest(url: url)
        urlReqest.httpMethod = "POST"
        let json = try! JSONEncoder().encode(newDataSet)
        
        urlReqest.httpBody = json
        
        urlReqest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlReqest.addValue("*/*", forHTTPHeaderField: "Accept")
        urlReqest.addValue("zip, deflate", forHTTPHeaderField: "Accept-Encoding")
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
