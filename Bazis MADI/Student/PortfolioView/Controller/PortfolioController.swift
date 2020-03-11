//
//  PortfolioController.swift
//  Bazis MADI
//
//  Created by Всеволод Андрющенко on 11.03.2020.
//  Copyright © 2020 Всеволод Андрющенко. All rights reserved.
//

import Foundation

//MARK: - детальная информация о работе
protocol editPersonalInformationDelegate {
    
    func editDataWorkControll(_ controller: PortfolioController, editData: PortfolioModel)
    
    func editEducationDataControll(_ controller: PortfolioController, editData: PortfolioModel)
    
    func addWorkControll(_ controller: PortfolioController, editData: PortfolioModel)
    
    func addEducControll(_ controller: PortfolioController, editData: PortfolioModel)
    
    func editAboutDataControll(_ controller: PortfolioController, editData: PortfolioModel)
}

class PortfolioController {
    
    var delegate: editPersonalInformationDelegate!
    
    func editWorkData(portfolio: PortfolioModel, index: Int) {
        print("workChsanged", portfolio.work[index])
    }
    
    func editEducationData(portfolio: PortfolioModel, index: Int) {
        print("edicChanged", portfolio.educ[index])
    }
    
    func addWork(portfolio: PortfolioModel) {
        print("addWork", portfolio.work)
    }
    
    func addEduc(portfolio: PortfolioModel) {
        print("addEduc", portfolio.educ)
    }
    
    func editAboutData(portfolio: PortfolioModel) {
        print("editAboutData", portfolio.wprice, portfolio.wpost, portfolio.ldata)
    }
    
}
