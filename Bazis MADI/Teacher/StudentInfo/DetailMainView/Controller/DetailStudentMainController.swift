//
//  DetailStudentMainController.swift
//  Bazis MADI
//
//  Created by Всеволод Андрющенко on 06.05.2020.
//  Copyright © 2020 Всеволод Андрющенко. All rights reserved.
//

import Foundation

// делегат для  DetailStudMain
protocol DetailStudentMainControllerDelegate: class {
    
    func showErrorReviewAdd(errorMess: String, controller: DetailStudentMainController)
    
    func reviewUpload(controller: DetailStudentMainController)
    
}

class DetailStudentMainController {
    
    weak var delegate: DetailStudentMainControllerDelegate!
    
    public func selectNewReiewFile(fileName: String, studentUIC: String, reviewName: String) {
        DetailStudentMainHttpService.selectReviewFile(nameFile: fileName, studUIC: studentUIC, reviewName: reviewName) { (error, result) in
            if error != nil {
                DispatchQueue.main.async {
                    self.delegate.showErrorReviewAdd(errorMess: "Не удалось добавть рецензию к файлу, возможно отсутствует интернет соединение!", controller: self)
                }
            } else {
                if let res = result {
                    DispatchQueue.main.async {
                        if res.result == true {
                            self.delegate.reviewUpload(controller: self)
                        } else {
                            self.delegate.showErrorReviewAdd(errorMess: "Не удалось добавть рецензию к файлу, возможно произошла ошибка на сервере!", controller: self)
                        }
                    }
                }
            }
        }
    }
}
