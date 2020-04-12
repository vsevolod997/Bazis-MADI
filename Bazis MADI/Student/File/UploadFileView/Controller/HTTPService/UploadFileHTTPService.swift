//
//  UploadFileHTTPService.swift
//  Bazis MADI
//
//  Created by Всеволод Андрющенко on 04.04.2020.
//  Copyright © 2020 Всеволод Андрющенко. All rights reserved.
//

import UIKit

class UploadFileHTTPService {
    
    func uploadFile(data: Data, uploadPath: String, fileName: String, complition: @escaping(Error?, UploadFileModel?) -> Void) {
        
        let urlString = "https://bazis.madi.ru/stud/api/file/upload/?path=\(uploadPath)"
        guard let urlsStr =  urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        
        let sessionURL = URL(string: urlsStr)
        
        var request  = URLRequest(url: sessionURL!)
        request.httpMethod = "POST"
        let boundary = "Boundary-\(UUID().uuidString)"
        
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.httpBody = createBody(parameters: [ fileName : fileName], boundary: boundary, data: data, fileName: fileName)
        
        
        let task = URLSession.shared.dataTask(with: request) { (data, resp, error) in
            if let err = error {
                complition(err, nil)
            } else {
                guard let datas = data else { return }
                do {
                    print(String(data: datas, encoding: .utf8))
                    let dataEncode = try JSONDecoder().decode(UploadFileModel.self, from: datas)
                    complition(nil, dataEncode)
                } catch let jsonError {
                    complition(jsonError, nil)
                }
            }
        }
        task.resume()
    }
    
    
    private func createBody(parameters: [String: String],
                            boundary: String,
                            data: Data,
                            fileName: String) -> Data {
        //let body = NSMutableData()
        var body = Data()
        let boundaryPrefix = "--\(boundary)\r\n"
        
        for (key, value) in parameters {
              body.appendString(boundaryPrefix)
              body.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
              body.appendString("\(value)\r\n")
        }
        
        body.appendString(boundaryPrefix)
        body.appendString("Content-Disposition: form-data; name=\"\(fileName)\"; filename=\"\(fileName)\"\r\n")
        let mimeType = "application/YourType"
        body.appendString("Content-Type: \(mimeType)\r\n\r\n")
        body.append(data)
        body.appendString("\r\n")
        body.appendString("--".appending(boundary.appending("--")))
        
        return body as Data
    }
}

extension Data {
    mutating func appendString(_ string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: false)
        append(data!)
    }
}
