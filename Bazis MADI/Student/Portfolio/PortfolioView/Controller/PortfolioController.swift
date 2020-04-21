//
//  PortfolioController.swift
//  Bazis MADI
//
//  Created by Всеволод Андрющенко on 11.03.2020.
//  Copyright © 2020 Всеволод Андрющенко. All rights reserved.
//

import UIKit

//MARK: - редактирование данных портофолио
protocol editPersonalInformationDelegate: class {
    
    func editPortfolioData(_ controller: PortfolioController, editData: PortfolioModel)
}


// MARK: - навигация между информауией и окнами для редактирования
class PortfolioController {
    
    weak var delegate: editPersonalInformationDelegate!
    
    //MARK: - изменение данных о работе
    func editWorkData(portfolio: PortfolioModel, index: Int, rootVC: UIViewController) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = sb.instantiateViewController(withIdentifier: "editWork") as? PortfolioWorkEditTableViewController else { return }
        vc.dataWork = portfolio.work[index]
        
        vc.saveCloser = { [weak self] newData in
            guard let self = self else { return }
            var editPortfolio = portfolio
            editPortfolio.work[index] = newData
            self.delegate.editPortfolioData(self, editData: editPortfolio)
        }
        
        vc.deleteCloser = {
            var editPortfolio = portfolio
            editPortfolio.work.remove(at: index)
            self.delegate.editPortfolioData(self, editData: editPortfolio)
        }
        
        rootVC.present(vc, animated: true)
    }
    
    //MARK: - изменение данных обарзовании
    func editEducationData(portfolio: PortfolioModel, index: Int, rootVC: UIViewController) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = sb.instantiateViewController(withIdentifier: "editEduc") as? PortfolioEducationTableViewController else { return }
        
        vc.saveCloser = { [weak self] newData in
            guard let self = self else { return }
            var editPortfolio = portfolio
            editPortfolio.educ[index] = newData
            self.delegate.editPortfolioData(self, editData: editPortfolio)
        }
        
         vc.deleteCloser = {
             var editPortfolio = portfolio
             editPortfolio.educ.remove(at: index)
             self.delegate.editPortfolioData(self, editData: editPortfolio)
         }
        
        vc.dataEduc = portfolio.educ[index]
        rootVC.present(vc, animated: true)
    }
    
    // MARK: - добавление работы
    func addWork(portfolio: PortfolioModel, rootVC: UIViewController) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = sb.instantiateViewController(withIdentifier: "editWork") as? PortfolioWorkEditTableViewController else { return }
        
        vc.saveCloser = { [weak self] newData in
            guard let self = self else { return }
            var editPortfolio = portfolio
            editPortfolio.work.append(newData)
            self.delegate.editPortfolioData(self, editData: editPortfolio)
        }
        
        rootVC.present(vc, animated: true)
    }
    
    
    // MARK: - добавление образования
    func addEduc(portfolio: PortfolioModel, rootVC: UIViewController) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = sb.instantiateViewController(withIdentifier: "editEduc") as? PortfolioEducationTableViewController else { return }
        
        vc.saveCloser = { [weak self] newData in
            guard let self = self else { return }
            var editPortfolio = portfolio
            editPortfolio.educ.append(newData)
            self.delegate.editPortfolioData(self, editData: editPortfolio)
        }
        
        rootVC.present(vc, animated: true)
    }
    
    
    //MARK:- общая инф
    func editAboutData(portfolio: PortfolioModel, rootVC: UIViewController) {
        
        let sb = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = sb.instantiateViewController(withIdentifier: "editInfo") as? PortfolioInfoEditTableViewController else { return }
        vc.allInformation = portfolio
        
        vc.saveCloser = { [weak self] newData in
            if let portfolio = newData {
                guard let self = self else { return }
                self.delegate.editPortfolioData(self, editData: portfolio)
            }
        }
            
        rootVC.present(vc, animated: true)
    }
    
}
