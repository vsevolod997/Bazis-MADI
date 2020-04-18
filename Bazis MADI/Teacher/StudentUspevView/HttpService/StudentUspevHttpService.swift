//
//  StudentUspevHttpService.swift
//  Bazis MADI
//
//  Created by Всеволод Андрющенко on 17.04.2020.
//  Copyright © 2020 Всеволод Андрющенко. All rights reserved.
//

import Foundation

class StudentUspevHttpService {
    
    class func getStudentUspev(studUic: String, completion: @escaping(Error?, [UspevModel]?)->Void){
        
        let body = "uic=\(studUic)"
        let urlStr = "https://bazis.madi.ru/stud/api/stud/uspev"
        guard let url = URL(string: urlStr) else { return }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpBody = body.data(using: .utf8)
        urlRequest.httpMethod = "POST"
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
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
