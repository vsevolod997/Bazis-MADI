//
//  DetailFileHttpService.swift
//  Bazis MADI
//
//  Created by Всеволод Андрющенко on 26.03.2020.
//  Copyright © 2020 Всеволод Андрющенко. All rights reserved.
//

import UIKit

class DetailFileHttpService {
    
    class func getFileDesc(nameFile: String, complition: @escaping(Error?, DescModel?) -> Void) {
        let urlStr = "https://bazis.madi.ru/stud/api/file/desc"
        guard let urlsStr =  urlStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        let url = URL(string: urlsStr)!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.httpBody = "&p=\(nameFile)".data(using: .utf8)
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let err = error {
                complition(err, nil)
            } else {
                guard let datas = data else { return }
                do {
                    let dataEncode = try JSONDecoder().decode(DescModel.self, from: datas)
                    complition(nil, dataEncode)
                } catch let jsonError {
                    complition(jsonError, nil)
                }
            }
        }
        task.resume()
    }
    
    class func setFileDesc(nameFile: String, textDesc: String, complition: @escaping(Error?) -> Void) {
        
        let postString = "&p=\(nameFile)&text=\(textDesc)"
        let urlStr = "https://bazis.madi.ru/stud/api/file/desc"
        guard let urlsStr =  urlStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        let url = URL(string: urlsStr)!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let err = error {
                complition(err)
            } else {
                if data != nil {
                    complition(nil)
                }
            }
        }
        task.resume()
    }
    
    class func deleteFile(nameFile: String, complition: @escaping(Error?) -> Void) {
        
        let postString = "&p=\(nameFile)"
        let urlStr = "https://bazis.madi.ru/stud/api/file/delete"
        guard let urlsStr =  urlStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        let url = URL(string: urlsStr)!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let err = error {
                complition(err)
            } else {
                if data != nil {
                    complition(nil)
                }
            }
        }
        task.resume()
    }
    
}
