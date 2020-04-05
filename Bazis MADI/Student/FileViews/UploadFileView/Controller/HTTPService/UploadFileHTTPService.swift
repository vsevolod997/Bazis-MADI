//
//  UploadFileHTTPService.swift
//  Bazis MADI
//
//  Created by Всеволод Андрющенко on 04.04.2020.
//  Copyright © 2020 Всеволод Андрющенко. All rights reserved.
//

import Foundation

class UploadFileHTTPService {
    
    func uploadFile(fileURL: URL, uploadPath: String, fileName: String, complition: @escaping(Error?, UploadFileModel?) -> Void) {
        
        let urlString = "https://bazis.madi.ru/stud/api/file/upload/?path=\(uploadPath)"
        guard let urlsStr =  urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        
        let sessionURL = URL(string: urlsStr)
        
        var request  = URLRequest(url: sessionURL!)
        request.httpMethod = "POST"
        let boundary = "Boundary-\(UUID().uuidString)"
        
        
        var data = Data()
        do {
            data = try Data(contentsOf: fileURL) as Data
        } catch {
            print("ERROR", error.localizedDescription )
        }
        
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.httpBody = createBody(parameters: [ fileURL.lastPathComponent:fileURL.lastPathComponent], boundary: boundary, data: data, fileName: fileName)
        
        
        let task = URLSession.shared.dataTask(with: request) { (data, resp, error) in
            if let err = error {
                complition(err, nil)
            } else {
                guard let datas = data else { return }
                print(String(data: datas, encoding: .utf8))
                do {
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
        let body = NSMutableData()
        
        let boundaryPrefix = "--\(boundary)\r\n"
        
        for (key, value) in parameters {
            body.appendString(boundaryPrefix)
            body.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
            body.appendString("\(value)\r\n")
        }
        
        body.appendString(boundaryPrefix)
        body.appendString("Content-Disposition: form-data; name=\"file\"; filename=\"\(fileName)\"\r\n")
        //body.appendString("Content-Type: \(mimeType)\r\n\r\n")
        body.append(data)
        body.appendString("\r\n")
        body.appendString("--".appending(boundary.appending("--")))
        
        return body as Data
    }
}

extension NSMutableData {
    func appendString(_ string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: false)
        append(data!)
    }
}
