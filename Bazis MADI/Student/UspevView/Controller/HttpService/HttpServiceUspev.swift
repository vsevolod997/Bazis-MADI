//
//  HttpServiceUspev.swift
//  Bazis MADI
//
//  Created by Всеволод Андрющенко on 20.01.2020.
//  Copyright © 2020 Всеволод Андрющенко. All rights reserved.
//

import Foundation

class HttpServiceUspev {
    
    //MARK: - получить данные о расписании
    class func getUserUspew( completion: @escaping(Error?, [UspevModel]?)->Void){
        
        let urlStr = "https://bazis.madi.ru/stud/api/stud/uspev"
        guard let url = URL(string: urlStr) else {return}
        var urlReqest = URLRequest(url: url)
        urlReqest.httpMethod = "POST"
        let task = URLSession.shared.dataTask(with: urlReqest) { (data, response, error) in
            if let err = error {
                completion(err, nil)
            } else {
                guard let datas = data else { return }
                do{
                    let data = try JSONDecoder().decode(Array<UspevModel>.self, from: datas)
                    completion(nil, data)
                } catch let jsonError {
                    completion(jsonError, nil)
                }
            }
        }
        task.resume()
    }
}
