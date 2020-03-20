//
//  PortfolioViewTableViewController.swift
//  Bazis MADI
//
//  Created by Всеволод Андрющенко on 02.03.2020.
//  Copyright © 2020 Всеволод Андрющенко. All rights reserved.
//

import UIKit
import AVFoundation

class PortfolioViewTableViewController: UITableViewController {

    private let controller = PortfolioController()
    
    private let notificationReload = Notification.Name("reloadData")
    private var errorVC: ErrorViewUIView!
    
    private var editButton: UIBarButtonItem = UIBarButtonItem()
    private var isEdit: Bool = false
    private var portfolioData: PortfolioModel!
    private var isLoad: Bool = false // флаг указывающий загруженны ли данные
    
   
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
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
    
    //MARK: - Настройки окна
    private func setupView() {
        title = "Портфолио"
        
        let addImg = UIImage(named: "addButton")
        let addButton = UIBarButtonItem(image: addImg, style:.plain, target: self, action: #selector(addButtonPress))
        editButton = UIBarButtonItem(title: "Править", style: .plain, target: self, action: #selector(editButtonPress))
           
        navigationItem.rightBarButtonItems = [addButton, editButton]
        
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:SystemColor.whiteColor]
        navigationController?.navigationBar.tintColor = SystemColor.whiteColor
        navigationController?.navigationBar.barTintColor = SystemColor.blueColor
        
        let img = UIImage(named: "backButton")
        let backButton = UIBarButtonItem(image: img , style: .done, target: self, action: #selector(backButtonPress) )
        navigationItem.leftBarButtonItem = backButton
        
        controller.delegate = self
    }
    
    //MARK:- если ошибка при сохранении
    private func showErrorSave() {
        
        let alert = UIAlertController(title: "Внимание!", message: "Ошибка сохранения, возможно отсутствует интернет соединение.", preferredStyle: .alert)
        let actionRes = UIAlertAction(title: "Повторить", style:  .default) { (_) in
            self.updateServerPortfolioData(editData: self.portfolioData)
        }
        alert.addAction(actionRes)
    
        let alertCancel = UIAlertAction(title: "Отмена", style: .destructive) { (_) in
            
        }
        alert.addAction(alertCancel)
        
        present(alert, animated: true)
    }
    
    //MARK: - обновление данынх на сервере
    private func updateServerPortfolioData(editData: PortfolioModel) {
        PorfolioHttpService.setPortfolioData(portfolio: editData) { (error, result) in
            if error != nil {
                DispatchQueue.main.async {
                    self.showErrorSave()
                }
            } else {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    //MARK: - выбор того что хотим добавить
    @objc func addButtonPress() {
        let alert = UIAlertController(title: "Добавить", message: nil, preferredStyle: .actionSheet)
        let workAction = UIAlertAction(title: "Место работы", style: .default) { (action) in
            self.controller.addWork(portfolio: self.portfolioData, rootVC: self)
        }
        let educAction = UIAlertAction(title: "Образование", style: .default) { (action) in
            self.controller.addEduc(portfolio: self.portfolioData, rootVC: self)
        }
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        
        alert.addAction(workAction)
        alert.addAction(educAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    @objc func backButtonPress() {
        navigationController?.popViewController(animated: true)
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
            editButton.title = "Править"
            tableView.allowsSelection = false
        } else {
            editButton.title = "Готово"
            tableView.allowsSelection = true
        }
        isEdit = !isEdit
        tableView.reloadData()
    }
}

// MARK: - Table view data source
extension PortfolioViewTableViewController {
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
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
                return portfolioData.educ.count
            case 2:
                return portfolioData.work.count
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
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: "educCell", for: indexPath) as? EducatioTableViewCell else { return UITableViewCell() }
                    cell.educationData = portfolioData.educ[indexPath.row]
                    return cell
            case 2: //обучение
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: "workCell", for: indexPath) as? WorkTableViewCell else {  return UITableViewCell() }
                    cell.dataWork = portfolioData.work[indexPath.row]
                    return cell
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
                view.backgroundColor = .systemBackground
                let title = Title4WLabelUILabel()
                title.text = "Данные о себе"
                title.frame = CGRect(x: 15, y: 0, width: self.view.frame.width, height: 30)
                view.addSubview(title)
                
                return view
            case 1:
                let view = UIView()
                view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 30)
                view.backgroundColor = .systemBackground
                let title = Title4WLabelUILabel()
                title.text = "Образование"
                title.frame = CGRect(x: 15, y: 0, width: self.view.frame.width, height: 30)
                view.addSubview(title)
                
                return view
            case 2:
                let view = UIView()
                view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 30)
                view.backgroundColor = .systemBackground
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
                if isEdit {
                    return 170
                } else {
                    return 132
                }
            case 2:
                if isEdit {
                    return 170
                } else {
                    return 132
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
            let cell = tableView.cellForRow(at: indexPath)
            UIView.animate(withDuration: 0.2, animations: {
                cell?.transform = .init(scaleX: 0.9, y: 0.9)
            }) { (_) in
                UIView.animate(withDuration: 0.1) {
                    cell?.transform = .init(scaleX: 1, y: 1)
                }
            }
            switch indexPath.section {
            case 1:
                controller.editEducationData(portfolio: portfolioData, index: indexPath.row, rootVC: self)
            case 2:
                controller.editWorkData(portfolio: portfolioData, index: indexPath.row, rootVC: self)
            default:
                controller.editAboutData(portfolio: portfolioData, rootVC: self)
            }
        }
    }
    
}

//MARK: - редактирование данных
extension PortfolioViewTableViewController: editPersonalInformationDelegate {
    
    func editPortfolioData(_ controller: PortfolioController, editData: PortfolioModel) {
        
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.impactOccurred()
        portfolioData = editData
        updateServerPortfolioData(editData: portfolioData)
    }
    
}
