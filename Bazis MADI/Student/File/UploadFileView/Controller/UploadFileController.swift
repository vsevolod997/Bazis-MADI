//
//  UploadFileController.swift
//  Bazis MADI
//
//  Created by Всеволод Андрющенко on 04.04.2020.
//  Copyright © 2020 Всеволод Андрющенко. All rights reserved.
//

import UIKit

// MARK: - делеширование здадачь
protocol UploadFileDelegate: class {
    // ошибка
    func showError(errorMess: String, controller: UploadFileController)
    //выгрузка начата
    func uploadIsStart(controller: UploadFileController)
    //выгрузка оконченна
    func uploadIsFinish(controller: UploadFileController)
    //выбор файла для выгрузки
    func uploadFileIsSelected(selectFileName: String, fileName: String, fileType: String, dataFile: Data)
    //доступность кнопки выгрузить
    func exportButtonIsEnabled(controller: UploadFileController, isEnabled: Bool)
    
    func setUploadingPath(controller: UploadFileController, path: [FileDirectoryModel])
}

class UploadFileController {
    
    private let notificationFileAdd = Notification.Name("fileAdd")
    
    private let httpService = UploadFileHTTPService()
    weak var delegate: UploadFileDelegate!
    
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
    
    public func controlUploadButtonEnabled(uploadPath: String?, fileName: String?, dataUpload: Data?) {
        
        if let path = uploadPath, let name = fileName, let _ = dataUpload {
            if name.count > 3 && path != "" {
                delegate.exportButtonIsEnabled(controller: self, isEnabled: true)
            } else {
                delegate.exportButtonIsEnabled(controller: self, isEnabled: false)
            }
        } else {
            delegate.exportButtonIsEnabled(controller: self, isEnabled: false)
        }
    }
    
    public func selectUploadPhoto(image: UIImage, name: String) {
        let fileType = "jpg"
        let file = name
        let fileName = ""
        
        guard let data = image.jpegData(compressionQuality: 0.8) else { return }
        delegate.uploadFileIsSelected(selectFileName: file, fileName: fileName, fileType: fileType, dataFile: data)
    }
    
    public func uploadFile(uploadData: Data, uploadPath: String, fileName: String, fileDesk: String) {
        
        delegate.uploadIsStart(controller: self)
        httpService.uploadFile(data: uploadData, uploadPath: uploadPath, fileName: fileName) { (error, fileModel) in
            if error != nil {
                DispatchQueue.main.async {
                    self.delegate.showError(errorMess: "Не удалось загрузить файл, возможно отсутствует интернет соединение!", controller: self)
                }
            } else {
                if let res = fileModel {
                    if res.error != nil {
                        DispatchQueue.main.async {
                            self.delegate.showError(errorMess: "Не удалось загрузить файл, файл с данным именем уже существует!", controller: self)
                        }
                    } else {
                        if res.result == true {
                            DispatchQueue.main.async {
                                let file = FileModel(file: fileName, path: uploadPath, time: "сейчас", size: uploadData.count)
                                if fileDesk != "" {
                                    self.setDescButton(fileDesc: fileDesk, nameFile: fileName)
                                }
                                NotificationCenter.default.post(name: self.notificationFileAdd, object: nil,  userInfo: ["file": file])
                                self.delegate.uploadIsFinish(controller: self)
                            }
                        }
                    }
                }
            }
        }
    }
   
    public func getPathDirrectory() {
        FileHTTPService.getDirectoryFileData { (error, fileInDirecrtory) in
            if error != nil {
                DispatchQueue.main.async {
                    self.delegate.showError(errorMess: "Не удалось получть список директорий доступных пользователю, повторите попытку позже!", controller: self)
                }
            } else {
                if let directory = fileInDirecrtory {
                    self.delegate.setUploadingPath(controller: self, path: directory)
                } else {
                    DispatchQueue.main.async {
                        self.delegate.showError(errorMess: "Не удалось получть список директорий доступных пользователю, повторите попытку позже!", controller: self)
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
