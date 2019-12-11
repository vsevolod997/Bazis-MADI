//
//  HttpServiceRaspisanie.swift
//  Bazis MADI
//
//  Created by Всеволод Андрющенко on 11.12.2019.
//  Copyright © 2019 Всеволод Андрющенко. All rights reserved.
//

import Foundation

class HttpServiceRaspisanie {
    class func getRaspisData(groupName: String, complition: @escaping(Error?, Raspisanie?) -> Void){
        
        let urlStr = "https://bazis.madi.ru/stud/schedule.php?group=\(groupName)"
        guard let url = URL(string: urlStr) else {return}
        var urlReqest = URLRequest(url: url)
        urlReqest.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: urlReqest) { (data, response, error) in
            if let err = error {
                print(err)
            } else {
                guard let datas = data else { return }
                do{
                    print(datas)
                    let data = try JSONDecoder().decode(Raspisanie.self, from: datas)
                    print("data", datas)
                } catch let jsonError {
                    
                    print(jsonError)
                }
            }
        }
        task.resume()
    }
}
