//
//  UploadFileController.swift
//  Bazis MADI
//
//  Created by Всеволод Андрющенко on 04.04.2020.
//  Copyright © 2020 Всеволод Андрющенко. All rights reserved.
//

import Foundation

protocol UploadFileDelegate: class {
    func showError(errorMess: String, controller: UploadFileController)
    
    func showOk(controller: UploadFileController)
}

class UploadFileController {
    
    private let  httpService = UploadFileHTTPService()
    
    public var delegate: UploadFileDelegate!
    
    public func uploadFile(fileURL: URL, uploadPath: String, fileName: String) {
        
        httpService.uploadFile(fileURL: fileURL, uploadPath: uploadPath, fileName: fileName) { (error, fileModel) in
            if error != nil {
                DispatchQueue.main.async {
                    self.delegate.showError(errorMess: "Не удалось загрузить файл, возможно отсутствует интернет сокдинение!", controller: self)
                }
            } else {
                if let res = fileModel {
                    if res.error != nil {
                        DispatchQueue.main.async {
                            self.delegate.showError(errorMess: "Не удалось загрузить файл, возможно отсутствует интернет сокдинение!", controller: self)
                        }
                    } else {
                        if res.result == "true" {
                            DispatchQueue.main.async {
                                self.delegate.showError(errorMess: "Не удалось загрузить файл, возможно отсутствует интернет сокдинение!", controller: self)
                            }
                        }
                    }
                }
            }
        }
    }
}
