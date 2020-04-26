//
//  StudFileDetailController.swift
//  Bazis MADI
//
//  Created by Всеволод Андрющенко on 26.04.2020.
//  Copyright © 2020 Всеволод Андрющенко. All rights reserved.
//

import Foundation


//MARK:- InfoFileDelegate коньроль данных по файлу
protocol StudInfoFileDelegate: class {
    func loadDescFile(fileDesc: DescModel, controller: StudFileDetailController)
    
    func setNewDescFile(fileDiscString: String, controller: StudFileDetailController)
    
    func showError(errorMess: String, controller: StudFileDetailController)
}

class StudFileDetailController {
    
    weak var delegate: StudInfoFileDelegate!
    
    private let notificationFileDelete = Notification.Name("fileDelete")
    
    
    func loadDesc(fileName: String) {
        DetailFileHttpService.getFileDesc(nameFile: fileName) { (err, descModel) in
            if err != nil {
                DispatchQueue.main.async {
                    self.delegate.showError(errorMess: "не удалось загрузить описание файла", controller: self)
                }
            } else {
                if let desc = descModel {
                    DispatchQueue.main.async {
                        self.delegate.loadDescFile(fileDesc: desc, controller: self)
                    }
                }
            }
        }
    }
    
    func updateDesc(fileName: String, textDesc: String) {
        DetailFileHttpService.setFileDesc(nameFile: fileName, textDesc: textDesc) { (error) in
            if error != nil {
                DispatchQueue.main.async {
                    self.delegate.showError(errorMess: "не удалось сохранить изменение, пожалуйста повторите попытку позже", controller: self)
                }
            } else {
                DispatchQueue.main.async {
                    self.delegate.setNewDescFile(fileDiscString: textDesc, controller: self)
                }
            }
        }
    }
    
    func fileDelete(index: Int, nameFile: String) {
        DetailFileHttpService.deleteFile(nameFile: nameFile) { (err) in
            if err == nil {
                DispatchQueue.main.async {
                    NotificationCenter.default.post(name: self.notificationFileDelete, object: nil,  userInfo: ["index": index])
                }
            } else {
                DispatchQueue.main.async {
                    self.delegate.showError(errorMess: "Не удалось удалить файл, пожалуйста повторите попытку позже", controller: self)
                }
            }
        }
    }
}

