//
//  PortfolioController.swift
//  Bazis MADI
//
//  Created by Всеволод Андрющенко on 11.03.2020.
//  Copyright © 2020 Всеволод Андрющенко. All rights reserved.
//

import UIKit

//MARK: - детальная информация о работе
protocol editPersonalInformationDelegate: class {
    
    func editPortfolioData(_ controller: PortfolioController, editData: PortfolioModel)
}

class PortfolioController {
    
    var delegate: editPersonalInformationDelegate!
    
    //MARK: - изменение данных о уже существующей работе
    func editWorkData(portfolio: PortfolioModel, index: Int, rootVC: UIViewController) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = sb.instantiateViewController(withIdentifier: "editWork") as? PortfolioWorkEditTableViewController else { return }
        vc.dataWork = portfolio.work[index]
        
        vc.saveCloser = { newData in
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
    
    func editEducationData(portfolio: PortfolioModel, index: Int, rootVC: UIViewController) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = sb.instantiateViewController(withIdentifier: "editEduc") as? PortfolioEducationTableViewController else { return }
        
        vc.saveCloser = { newData in
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
    
    //MARK: - изменение данных о уже существующей работе
    func addWork(portfolio: PortfolioModel, rootVC: UIViewController) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = sb.instantiateViewController(withIdentifier: "editWork") as? PortfolioWorkEditTableViewController else { return }
        
        vc.saveCloser = { newData in
            var editPortfolio = portfolio
            editPortfolio.work.append(newData)
            self.delegate.editPortfolioData(self, editData: editPortfolio)
        }
        
        rootVC.present(vc, animated: true)
    }
    
    func addEduc(portfolio: PortfolioModel, rootVC: UIViewController) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = sb.instantiateViewController(withIdentifier: "editEduc") as? PortfolioEducationTableViewController else { return }
        
        vc.saveCloser = { newData in
            var editPortfolio = portfolio
            editPortfolio.educ.append(newData)
            self.delegate.editPortfolioData(self, editData: editPortfolio)
        }
        
        rootVC.present(vc, animated: true)
    }
    
    func editAboutData(portfolio: PortfolioModel) {
        print("editAboutData", portfolio.wprice, portfolio.wpost, portfolio.ldata)
    }
    
}
