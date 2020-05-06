//
//  StudFileDetailController.swift
//  Bazis MADI
//
//  Created by Всеволод Андрющенко on 26.04.2020.
//  Copyright © 2020 Всеволод Андрющенко. All rights reserved.
//

import Foundation

//MARK:- InfoFileDelegate 
protocol StudInfoFileDelegate: class {
    func loadDescFile(fileDesc: DescModel, controller: StudFileDetailController)
    
    func controlHavingReview(isHaveReview: Bool, revieName: String, controller: StudFileDetailController)
    
    func showError(errorMess: String, controller: StudFileDetailController)
    
    func removeReview(controler: StudFileDetailController)
}

class StudFileDetailController {
    
    weak var delegate: StudInfoFileDelegate!
    
    private var reviewName: String = ""
    
    public func loadDesc(fileName: String, studentIdc: String) {
        StudentDetailHttpService.getFileDesc(nameFile: fileName, studUIC: studentIdc) { (err, descModel) in
            if err != nil {
                DispatchQueue.main.async {
                    self.delegate.showError(errorMess: "Не удалось загрузить описание файла!", controller: self)
                }
            } else {
                if let desc = descModel {
                    self.controlReview(ref: desc.ref)
                    DispatchQueue.main.async {
                        self.delegate.loadDescFile(fileDesc: desc, controller: self)
                    }
                }
            }
        }
    }

    
    public func deleteReview(fileName: String, studentIdc: String) {
        
        StudentDetailHttpService.deleteReviewFile(nameFile: fileName, studUIC: studentIdc, reviewName: reviewName) { (error, result) in
            if error != nil {
                DispatchQueue.main.async {
                    self.delegate.showError(errorMess: "Не удалось удалить рецензию: " + self.reviewName + "на данный файл" , controller: self)
                }
            } else {
                guard let res = result else { return }
                if res.result {
                    DispatchQueue.main.async {
                        self.delegate.removeReview(controler: self)
                    }
                }
            }
        }
    }

    
    private func controlReview(ref: [ReviewModel]?) {
        let user = UserLogin.userNow.user.user_fio
        
        let buff = user.split(separator: " ")
        let userFormated = String(buff[0]) + " " + String(buff[1].first!) + ". " + String(buff[2].first!) + "."
        
        ref?.forEach({ (rewiev) in
            if rewiev.own == userFormated {
                reviewName = rewiev.own
                DispatchQueue.main.async {
                    self.delegate.controlHavingReview(isHaveReview: true, revieName: rewiev.link, controller: self)
                }
            }
        })
    }
}

