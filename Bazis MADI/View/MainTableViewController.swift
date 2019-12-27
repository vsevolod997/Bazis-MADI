//
//  MainViewController.swift
//  Bazis MADI
//
//  Created by Всеволод Андрющенко on 08.12.2019.
//  Copyright © 2019 Всеволод Андрющенко. All rights reserved.
//

import UIKit
//MARK: - главная страница
class MainTableViewController: UITableViewController {

    @IBOutlet weak var raspisanieTable: TableRaspisanieUIView!
    @IBOutlet weak var changedView: UISegmentedControl!
    @IBOutlet weak var dataControl: UIPageControl!
    
    let userLogin = UserDataController()
    var closeVC: CloseViewUIView! //окно для закрывания загрузки
    let homeController = HomeTableViewController()
    
    var allRaspisanie: RaspisanieModel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        raspisanieTable.raspisanieViewDataSource = self
        raspisanieTable.delegate = self
        
        setupView()
        getDataRaspisanie()
    }
    
    //MARK: - Обработка получения расписания
    private func getDataRaspisanie() {
        self.showVC()
        if let user = UserLogin.userNow.user {
            raspisanieSet(groupName: user.user_group)
        } else {// иначе показали окно загрузки загрузку,
            if let user = userLogin.getUserData() {
                HttpService.getUserAccount(login: user.login, password: user.password) { (err, model, modelErr) in // пробуем получили данные по текущему log pas
                    if let user = model { // !получили\\ заролнили поля пользователя
                        self.raspisanieSet(groupName: user.user_group)
                        
                    } else { // !не получили \\выкинули на экран логина если log, pas не совпали
                        DispatchQueue.main.async {
                            self.showLoginView()
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Запрос расписания по группе
    private func raspisanieSet(groupName: String) {
        
        HttpServiceRaspisanie.getRaspisData(groupName: groupName) { (error, raspisanie) in
            DispatchQueue.main.async {
                if let error = error {
                    print(error)
                } else {
                    if let raspis = raspisanie {
                        if let errorLoad = raspis.error{
                            print(errorLoad)
                        } else {
                            DispatchQueue.main.async {
                                self.allRaspisanie = raspis
                                self.raspisanieTable.setupView()
                                self.removeVC()
                            }
                            self.selectWeakType(raspisanieData: raspis)
                        }
                    }
                }
            }
        }
    }
    
    // MARK: отображение текущего типа недели
    private func selectWeakType(raspisanieData: RaspisanieModel) {
        if raspisanieData.typeWeek == "Числитель" {
            DispatchQueue.main.async {
                self.changedView.selectedSegmentIndex = 0
            }
        }
        
        if raspisanieData.typeWeek == "Знаменатель" {
            DispatchQueue.main.async {
                self.changedView.selectedSegmentIndex = 1
            }
        }
    }
    
    private func showVC() {
        closeVC = CloseViewUIView(frame: self.view.frame)
        view.addSubview(closeVC)
    }
    
    private func removeVC() {
        closeVC.removeFromSuperview()
    }
    
    //MARK: - Настройки окна
    private func setupView() {
        
        let date = Date()
        let calendar = Calendar.current
        let weekday = calendar.component(.weekday, from: date)
        dataControl.currentPage = weekday - 2
        
        changedView.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: UIControl.State.selected)
        changedView.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.darkGray], for: UIControl.State.normal)
        
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.barTintColor = SystemColor.blueColor
    }
    
    //MARK: - Возврат к окну логина
    private func showLoginView() {
        
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(identifier: "login")
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
        
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.impactOccurred()
    }
    
    //MARK: -  Изменение отобраджения рассписания в зависимоти типа недели
    @IBAction func changetTypeWeak(_ sender: UISegmentedControl) {
        //raspisanieTable.removeFromSuperview()
        raspisanieTable.setupView()
        
        let date = Date()
        let calendar = Calendar.current
        let weekday = calendar.component(.weekday, from: date)
        dataControl.currentPage = weekday - 2
        
    }
    
}

//MARK: - TableRaspisanieDataSource
extension MainTableViewController: TableRaspisanieDataSource {
     //MARK: - передача данных о типе недели
    func raraspisanieWeakNow(_ parametrView: TableRaspisanieUIView) -> Bool {
        return changedView.selectedSegmentIndex == 0 ? true : false
    }
    
    //MARK: - передача данных о текущем дне
    func raspisanieDayNow(_ parametrView: TableRaspisanieUIView) -> Int {
        
        let date = Date()
        let calendar = Calendar.current
        let weekday = calendar.component(.weekday, from: date)
        
        return weekday - 2
    }
    
    //MARK: - Передача данных текущего расписания по дням
    func raspisanieTableData(_ parametrView: TableRaspisanieUIView, indexDay: Int) -> [DailyRaspisanie]? {
        
        if let raspisanieData = allRaspisanie {
            switch indexDay {
            case 0:
                return raspisanieData.result?.monday
            case 1:
                return raspisanieData.result?.tuesday
            case 2:
                return raspisanieData.result?.wednesday
            case 3:
                return raspisanieData.result?.thursday
            case 4:
                return raspisanieData.result?.friday
            case 5:
                return raspisanieData.result?.saturday
            default:
                return nil
            }
        }
        return nil
    }
}

extension MainTableViewController: TableRaspisanieDelegate {
    func changedDay(_ parametrView: TableRaspisanieUIView, didSelectItem index: Int) {
        dataControl.currentPage = index
    }
}

extension MainTableViewController {
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let view = UIView()
            view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 20)
            view.backgroundColor = .white
            let title = Title1LabelUILabel()
            title.text = "Расписание"
            title.frame = CGRect(x: 15, y: 0, width: self.view.frame.width, height: 30)
            view.addSubview(title)
            return view
        }
        
        return UIView()
    }
}

