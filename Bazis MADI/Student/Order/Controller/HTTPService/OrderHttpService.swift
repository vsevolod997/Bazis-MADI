//
//  OrderHttpService.swift
//  Bazis MADI
//
//  Created by Всеволод Андрющенко on 18.04.2020.
//  Copyright © 2020 Всеволод Андрющенко. All rights reserved.
//

import Foundation

class OrderHttpService {
    
    class func getStudentOrder( completion: @escaping(Error?, [OrderModel]?)->Void){
        
        let urlStr = "https://bazis.madi.ru/stud/api/stud/prikaz"
        guard let url = URL(string: urlStr) else { return }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let err = error {
                completion(err, nil)
            } else {
                guard let datas = data else { return }
                print(String(data: datas, encoding: .utf8))
                //let data = try JSONDecoder().decode(Array<UspevModel>.self, from: datas)
                //completion(nil, data)
            }
        }
        task.resume()
    }
}
