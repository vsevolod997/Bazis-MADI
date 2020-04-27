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
    
    func loadDesc(fileName: String, studentIdc: String) {
        StudentDetailHttpService.getFileDesc(nameFile: fileName, studUIC: studentIdc) { (err, descModel) in
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
}

