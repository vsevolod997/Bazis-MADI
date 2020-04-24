//
//  SearchStudentHttpService.swift
//  Bazis MADI
//
//  Created by Всеволод Андрющенко on 11.04.2020.
//  Copyright © 2020 Всеволод Андрющенко. All rights reserved.
//

import Foundation

class SearchStudentHttpService {
    
    //список студентов по группе
    class func searchStudentInGroup(groupName: String , complition: @escaping(Error?, [StudentModel]?) -> Void) {
        
        let body = "group=\(groupName)"
        
        let urlStr = "https://bazis.madi.ru/stud/api/stud/find"
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
                do{
                    let dataEncode = try JSONDecoder().decode(Array<StudentModel>.self , from: datas)
                    complition(nil, dataEncode)
                } catch let jsonError {
                    complition(jsonError, nil)
                }
            }
        }
        task.resume()
    }
    
    //поиск студента по ФИО
    class func searchStudent(fio: String , complition: @escaping(Error?, [StudentModel]?) -> Void) {
        
        let body = "fio=\(fio)"
        let urlStr = "https://bazis.madi.ru/stud/api/stud/find"
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
                do{
                    let dataEncode = try JSONDecoder().decode(Array<StudentModel>.self , from: datas)
                    complition(nil, dataEncode)
                } catch let jsonError {
                    complition(jsonError, nil)
                }
            }
        }
        task.resume()
    }
}
