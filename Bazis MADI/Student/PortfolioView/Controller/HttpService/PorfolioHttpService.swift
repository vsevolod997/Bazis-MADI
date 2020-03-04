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
                   do{
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
