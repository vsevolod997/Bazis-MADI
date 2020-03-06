//
//  PortfolioViewTableViewController.swift
//  Bazis MADI
//
//  Created by Всеволод Андрющенко on 02.03.2020.
//  Copyright © 2020 Всеволод Андрющенко. All rights reserved.
//

import UIKit

class PortfolioViewTableViewController: UITableViewController {

    private let notificationReload = Notification.Name("reloadData")
    private var errorVC: ErrorViewUIView!
    
    private var isEdit: Bool = false
    private var portfolioData: PortfolioModel!
    private var isLoad: Bool = false // флаг указывающий загруженны ли данные
    
    private var workCount: Int = 0
    private var educationCount: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        getDataPortfolio()
        
    }
    
    private func addNotificationCenter() {
        NotificationCenter.default.addObserver(self, selector: #selector(onNotification(notification:)), name: notificationReload, object: nil)
    }
    
    //notification
    @objc func onNotification(notification: Notification) {
        removeErrorView()
        getDataPortfolio()
    }
    
    //MARK: -  портфолио дата
    private func getDataPortfolio() {
        isLoad = false
        PorfolioHttpService.getPortfolioData { (error, portfolioData) in
            if error != nil {
                DispatchQueue.main.async {
                    self.showErrorView()
                }
            } else {
                if let portfolio = portfolioData {
                    DispatchQueue.main.async {
                        self.isLoad = true
                        self.portfolioData = portfolio
                        self.educationCount = portfolio.educ.count
                        self.workCount = portfolio.work.count
                        print(self.workCount, self.educationCount)
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
    
    //MARK: - Настройки окна
    private func setupView() {
        
        navigationItem.rightBarButtonItem = .init(barButtonSystemItem: .edit, target: self, action: #selector(editButtonPress))
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:SystemColor.whiteColor]
        navigationController?.navigationBar.tintColor = SystemColor.whiteColor
        navigationController?.navigationBar.barTintColor = SystemColor.blueColor
    }

    private func showErrorView() {
        errorVC = ErrorViewUIView(frame: self.view.frame)
        view.addSubview(errorVC)
    }
    
    private func removeErrorView() {
        if errorVC != nil {
            errorVC.removeFromSuperview()
        }
    }
    
    //MARK: - нажатие кнопки редактировния
    @objc func editButtonPress() {
        if isEdit {
            removeCellButton()
            tableView.allowsSelection = false
        } else {
            addCellButton()
            tableView.allowsSelection = true
        }
        isEdit = !isEdit
        
    }
    
    private func addCellButton() {
        
        let pathEduc = IndexPath(row: educationCount, section: 1)
        let pathWork = IndexPath(row: workCount, section: 2)
        
        workCount = workCount + 1
        educationCount  = educationCount + 1
        
        tableView.insertRows(at: [pathEduc, pathWork], with:  .right)
    }
    
    private func removeCellButton() {
        workCount = workCount - 1
        educationCount  = educationCount - 1
        
        let pathEduc = IndexPath(row: educationCount, section: 1)
        let pathWork = IndexPath(row: workCount, section: 2)
        
        tableView.deleteRows(at: [pathEduc, pathWork], with: .left)
    }
}

// MARK: - Table view data source
extension PortfolioViewTableViewController {
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        if isLoad {
            return 3
        } else {
            return 1
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isLoad {
            switch section {
            case 0:
                return 2
            case 1:
                return educationCount
            case 2:
                return workCount
            default:
                return 0
            }
        } else {
            return 1
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isLoad {
            switch  indexPath.section {
            case 0:
                if indexPath.row == 0 {
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: "aboutCell", for: indexPath) as? AboutViewCell else { return UITableViewCell() }
                    cell.aboutText.text = portfolioData.ldata
                    return cell
                } else {
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: "infoCell", for: indexPath) as? InfoPortfolioTableViewCell else { return UITableViewCell() }
                    cell.dolzLabel.text = portfolioData.wpost
                    cell.zpLabel.text = portfolioData.wprice
                    return cell
                }
            case 1: //  образование
                if indexPath.row < portfolioData.educ.count {
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: "educCell", for: indexPath) as? EducatioTableViewCell else { return UITableViewCell() }
                    cell.educationData = portfolioData.educ[indexPath.row]
                    return cell
                } else {
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: "addCell", for: indexPath) as? AddCellTableViewCell else { return UITableViewCell() }
                    return cell
                }
            case 2: //обучение
                if indexPath.row < portfolioData.work.count {
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: "workCell", for: indexPath) as? WorkTableViewCell else {  return UITableViewCell() }
                    cell.dataWork = portfolioData.work[indexPath.row]
                    return cell
                } else {
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: "addCell", for: indexPath) as? AddCellTableViewCell else { return UITableViewCell() }
                    return cell
                }
            default:
                UITableViewCell()
            }
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "loadPortCell", for: indexPath)
            return cell
        }
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if isLoad {
            switch section {
            case 0:
                let view = UIView()
                view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 30)
                view.backgroundColor = SystemColor.blueColor
                let title = Title4WLabelUILabel()
                title.text = "Данные о себе"
                title.frame = CGRect(x: 15, y: 0, width: self.view.frame.width, height: 30)
                view.addSubview(title)
                
                return view
            case 1:
                let view = UIView()
                view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 30)
                view.backgroundColor = SystemColor.blueColor
                let title = Title4WLabelUILabel()
                title.text = "Образование"
                title.frame = CGRect(x: 15, y: 0, width: self.view.frame.width, height: 30)
                view.addSubview(title)
                
                return view
            case 2:
                let view = UIView()
                view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 30)
                view.backgroundColor = SystemColor.blueColor
                let title = Title4WLabelUILabel()
                title.text = "Опыт работы"
                title.frame = CGRect(x: 15, y: 0, width: self.view.frame.width, height: 30)
                view.addSubview(title)
                
                return view
            default:
                return nil
            }
        } else {
            return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if isLoad {
            switch  indexPath.section {
            case 0:
                return 114
            case 1:
                if indexPath.row < portfolioData.educ.count {
                    return 114
                } else {
                    return 90
                }
            case 2:
                if indexPath.row < portfolioData.work.count {
                    return 114
                } else {
                    return 90
                }
            default:
                return 0
            }
        } else {
            return 96
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isEdit {
            print(indexPath)
        }
    }
    
}
