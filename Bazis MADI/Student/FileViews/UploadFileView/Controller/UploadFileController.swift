//
//  UploadFileController.swift
//  Bazis MADI
//
//  Created by Всеволод Андрющенко on 04.04.2020.
//  Copyright © 2020 Всеволод Андрющенко. All rights reserved.
//

import UIKit

protocol UploadFileDelegate: class {
    func showError(errorMess: String, controller: UploadFileController)
    
    func showOk(controller: UploadFileController)
    
    func uploadFileIsSelected(selectFileName: String, fileName: String, fileType: String, dataFile: Data)
    
}

class UploadFileController {
    
    private let  httpService = UploadFileHTTPService()
    
    public var delegate: UploadFileDelegate!
    
    public func selectUploadFile(urlFile: URL) {
        let file = urlFile.lastPathComponent
        let fileName = String(file.split(separator: ".").first!)
        let fileType = String(file.split(separator: ".").last!)
        
        var data = Data()
        do {
            data = try Data(contentsOf: urlFile) as Data
        } catch {
             print("ERROR", error.localizedDescription )
        }
        
        delegate.uploadFileIsSelected(selectFileName: file, fileName: fileName, fileType: fileType, dataFile: data)
    }
    
    public func selectUploadPhoto(image: UIImage, name: String) {
        let fileType = "jpg"
        let file = name
        let fileName = ""
        
        guard let data = image.jpegData(compressionQuality: 0.8) else { return }
        delegate.uploadFileIsSelected(selectFileName: file, fileName: fileName, fileType: fileType, dataFile: data)
    }
        
    public func uploadFile(uploadData: Data, uploadPath: String, fileName: String, fileDesk: String) {
        
        httpService.uploadFile(data: uploadData, uploadPath: uploadPath, fileName: fileName) { (error, fileModel) in
            if error != nil {
                DispatchQueue.main.async {
                    self.delegate.showError(errorMess: "Не удалось загрузить файл, возможно отсутствует интернет сокдинение!", controller: self)
                    
                    if fileDesk != "" {
                        self.setDescButton(fileDesc: fileDesk, nameFile: fileName)
                    }
                }
            } else {
                if let res = fileModel {
                    if res.error != nil {
                        DispatchQueue.main.async {
                            self.delegate.showError(errorMess: "Не удалось загрузить файл, возможно отсутствует интернет сокдинение!", controller: self)
                        }
                    } else {
                        if res.result == "true" {
                            //if fileDesk != "" {
                            //  self.setDescButton(fileDesc: fileDesk, nameFile: fileName)
                            //}
                            DispatchQueue.main.async {
                                self.delegate.showError(errorMess: "Не удалось загрузить файл, возможно отсутствует интернет сокдинение!", controller: self)
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    private func setDescButton(fileDesc: String, nameFile:String) {
        DetailFileHttpService.setFileDesc(nameFile: nameFile, textDesc: fileDesc) { (err) in
            if err != nil {
                if err != nil {
                    DispatchQueue.main.async {
                        self.delegate.showError(errorMess: "Не удалось установить описание файла!", controller: self)
                    }
                }
            }
        }
    }
}
