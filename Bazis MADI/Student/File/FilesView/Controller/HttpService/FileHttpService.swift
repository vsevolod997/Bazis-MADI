//
//  FileHttpService.swift
//  Bazis MADI
//
//  Created by Всеволод Андрющенко on 19.03.2020.
//  Copyright © 2020 Всеволод Андрющенко. All rights reserved.
//

import Foundation

class FileHTTPService {
    
    class func getDirectoryFileData(complition: @escaping(Error?, [FileDirectoryModel]?) -> Void) {
        let urlStr = "https://bazis.madi.ru/stud/api/file/folder"
        guard let urlsStr =  urlStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        let url = URL(string: urlsStr)!
        let urlRequest = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let err = error {
                complition(err, nil)
            } else {
                guard let datas = data else { return }
                //print(String(data: datas, encoding: .utf8))
                do {
                    let dataEncode = try JSONDecoder().decode(Array<FileDirectoryModel>.self, from: datas)
                    complition(nil, dataEncode)
                } catch let jsonError {
                    complition(jsonError, nil)
                }
            }
        }
        task.resume()
    }
    
    class func getFileData(complition: @escaping(Error?, [FileModel]?) -> Void) {
        let urlStr = "https://bazis.madi.ru/stud/api/file/files"
        guard let urlsStr =  urlStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        let url = URL(string: urlsStr)!
        let urlRequest = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let err = error {
                complition(err, nil)
            } else {
                guard let datas = data else { return }
                do {
                    if let strResult = String(data: datas, encoding: .utf8) {
                        if strResult.count > 3 {
                            let dataEncode = try JSONDecoder().decode(Array<FileModel>.self, from: datas)
                            complition(nil, dataEncode)
                        } else {
                            complition(nil, nil)
                        }
                    }
                } catch let jsonError {
                    complition(jsonError, nil)
                }
            }
        }
        task.resume()
    }
}
