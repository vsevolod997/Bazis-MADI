//
//  MainViewController.swift
//  Bazis MADI
//
//  Created by Всеволод Андрющенко on 08.12.2019.
//  Copyright © 2019 Всеволод Андрющенко. All rights reserved.
//

import UIKit
import AVFoundation

//MARK: - главная страница
class MainTableViewController: UITableViewController {

    
    @IBOutlet weak var raspisanieByTeacher: TableRaspisanieByTeacherUIView!
    @IBOutlet weak var raspisanieExamTable: TableRaspisanieExamsUIView!
    @IBOutlet weak var raspisanieTable: TableRaspisanieUIView!
    @IBOutlet weak var changedView: UISegmentedControl!
    @IBOutlet weak var dataControl: UIPageControl!
    
    private let userLogin = UserDataController()
    private var closeVC: CloseViewUIView! //окно для закрывания загрузки
    private var errorVC: ErrorViewUIView!
    private let homeController = HomeTableViewController()
    private let weakRaspisanie = WeekRaspisanieController()
    
    private var examRaspisanie: RaspisanieExamModel!
    private var allRaspisanie: RaspisanieModel!
    private var isWeekNow: Bool = true
    private var isLoad: Bool = false
    
    private var notificationReload = Notification.Name("reloadData")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        raspisanieExamTable.raspisanieExamsDataSource = self
        
        raspisanieByTeacher.raspisanieByTeacherDataSource = self
        raspisanieByTeacher.delegate = self
        
        raspisanieTable.raspisanieViewDataSource = self
        raspisanieTable.delegate = self
        
        setupView()
        getUserData()
        addNotificationCenter()
    }
    
    
    private func addNotificationCenter() {
        NotificationCenter.default.addObserver(self, selector: #selector(onNotification(notification:)), name: notificationReload, object: nil)
    }
    
    //notification
    @objc func onNotification(notification: Notification) {
        removeCloseView()
        removeErrorView()
        getUserData()
    }
    
    //MARK: - Обработка получения расписания
    private func getUserData() {
        self.showCloseView()
        if let user = UserLogin.userNow.user {
            getUserRaspisanie(groupName: user.user_group)
            getExamRaspisanie(groupName: user.user_group)
        } else {// иначе показали окно загрузки загрузку,
            if let user = userLogin.getUserData() {
                HttpService.getUserAccount(login: user.login, password: user.password) { (err, model, modelErr) in // пробуем получили данные по текущему log pas
                    if let user = model { // !получили\\ заролнили поля пользователя
                        self.getUserRaspisanie(groupName: user.user_group)
                        self.getExamRaspisanie(groupName: user.user_group)
                    } else { // !не получили \\выкинули на экран логина если log, pas не совпали
                        if modelErr != nil {
                            DispatchQueue.main.async {
                                self.showLoginView()
                            }
                        } else {
                            DispatchQueue.main.async {
                                self.removeCloseView()
                                self.showErrorView()
                            }
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Запрос расписания по группе
    private func getUserRaspisanie(groupName: String) {
        HttpServiceRaspisanie.getRaspisanieData(groupName: groupName) { (error, raspisanie) in
            DispatchQueue.main.async {
                if let error = error {
                    print(error)
                } else {
                    if let raspis = raspisanie {
                        if let errorLoad = raspis.error {
                            print(errorLoad)
                        } else {
                            DispatchQueue.main.async {
                                self.allRaspisanie = raspis
                                self.raspisanieTable.setupView(weekInCalendar: .now)
                                self.raspisanieByTeacher.setupDataView()
                                self.isLoad = true
                                self.removeErrorView()
                                self.removeCloseView()
                                self.tableView.reloadData()
                            }
                            self.selectWeakType(raspisanieData: raspis)
                        }
                    }
                }
            }
        }
    }
    // MARK: - получение данных текущего расписания экзаменов
    private func getExamRaspisanie(groupName:String) {
        HttpServiceRaspisanie.getRaspisanieExamData(groupName: groupName) { (error, examData) in
            if error != nil {
                DispatchQueue.main.async {
                    self.raspisanieExamTable.setupTableExams()
                }
            } else {
                if let examRaspis = examData {
                    if let error = examRaspis.error{
                        print(error)
                    } else {
                        DispatchQueue.main.async {
                            self.examRaspisanie = examRaspis
                            self.raspisanieExamTable.setupTableExams()
                        }
                    }
                }
            }
        }
    }
    
    // MARK: Отображение текущего типа недели
    private func selectWeakType(raspisanieData: RaspisanieModel) {
        if raspisanieData.typeWeek == "Числитель" {
            DispatchQueue.main.async {
                self.changedView.selectedSegmentIndex = 0
                self.raspisanieTable.setupView(weekInCalendar: .now)
            }
        }
        
        if raspisanieData.typeWeek == "Знаменатель" {
            DispatchQueue.main.async {
                self.changedView.selectedSegmentIndex = 1
                self.raspisanieTable.setupView(weekInCalendar: .now)
            }
        }
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
    
    private func showCloseView() {
        closeVC = CloseViewUIView(frame: self.view.frame)
        view.addSubview(closeVC)
    }
    
    private func removeCloseView() {
        if closeVC != nil {
            closeVC.removeFromSuperview()
        }
    }
    
    //MARK: - Настройки окна
    private func setupView() {
        dataControl.currentPage = weakRaspisanie.getToday()
        changedView.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: SystemColor.whiteColor], for: UIControl.State.selected)
        changedView.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: SystemColor.grayColor], for: UIControl.State.normal)
        
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:SystemColor.whiteColor]
        navigationController?.navigationBar.tintColor = SystemColor.whiteColor
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
        let generator = UIImpactFeedbackGenerator(style: .rigid)
        generator.impactOccurred()
        
        isWeekNow = !isWeekNow
        if isWeekNow {
            raspisanieTable.setupView(weekInCalendar: .now)
        } else {
            raspisanieTable.setupView(weekInCalendar: .next)
        }
        let weekday = weakRaspisanie.getToday()
        
        dataControl.currentPage = weekday
    }
    //MARK: -  нажатие кнопки "все при просмотре расписания преподавателей"
    @objc func allTeacherButton() {
        print("Swow All Teacher")
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
        return weakRaspisanie.getToday()
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
//MARK: - Отображение выбранного окна
extension MainTableViewController: TableRaspisanieDelegate {
    func changedDay(_ parametrView: TableRaspisanieUIView, didSelectItem index: Int) {
        dataControl.currentPage = index
    }
}
//MARK: - Дата сорс расписания экзаменов
extension MainTableViewController: TableRaspisanieExamsDataSource {
    func raspisanieExamsTableData(_ parametrView: TableRaspisanieExamsUIView) -> [Exam]? {
        return examRaspisanie?.result
    }
}
//MARK: - Дата сорс расписания по преподам
extension MainTableViewController: TableRaspisanieByTeacherDataSource {
    
    func raspisanieByTeacherTableData(_ parametrView: TableRaspisanieByTeacherUIView) -> [String]? {
        var allPars: [DailyRaspisanie] = []
        
        if let raspisanieData = allRaspisanie {
            
            if let monday = raspisanieData.result?.monday {
                allPars.append(contentsOf: monday)
            }
            if let tuesday = raspisanieData.result?.tuesday {
                allPars.append(contentsOf: tuesday)
            }
            if let wednesday = raspisanieData.result?.wednesday {
                allPars.append(contentsOf: wednesday)
            }
            if let thursday = raspisanieData.result?.thursday {
                allPars.append(contentsOf: thursday)
            }
            if let friday = raspisanieData.result?.friday {
                allPars.append(contentsOf: friday)
            }
            if let saturday = raspisanieData.result?.saturday {
                allPars.append(contentsOf: saturday)
            }
        }
        
        var result: [String] = []
        
        for pars in allPars {
            if let name = pars.teacher {
                if !result.contains(name) && name != "" {
                    result.append(name)
                }
            }
        }
        return result.sorted()
    }
}

extension MainTableViewController: TableRaspisanieByTeacherDelegate {
    func selectTeacherButton(_ parametrView: TableRaspisanieByTeacherUIView, teacherData: String) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = sb.instantiateViewController(withIdentifier: "detalRaspisanie") as? InfioTeacherTableViewController else { return }
        vc.teacherName = teacherData
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK: - Отображение секций 
extension MainTableViewController {
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if isLoad {
            switch section {
            case 0:
                let view = UIView()
                view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 20)
                view.backgroundColor = .systemBackground
                let title = Title4LabelUILabel()
                title.text = "Расписание"
                title.frame = CGRect(x: 15, y: 0, width: self.view.frame.width, height: 30)
                view.addSubview(title)
                
                return view
            case 1:
                let view = UIView()
                view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 20)
                view.backgroundColor = .systemBackground
                let title = Title4LabelUILabel()
                
                if !SystemDevice().isNormalDevice {
                    title.text = "По преподавателям"
                } else {
                    title.text = "Расписание по преподавателям"
                }// проверка устройства
                title.frame = CGRect(x: 15, y: 0, width: self.view.frame.width - 50, height: 30)
                view.addSubview(title)
                
                let allButton = ShowMoreUIButton()
                allButton.frame = CGRect(x: self.view.frame.width - 70, y: 0, width: 70, height: 30)
                view.addSubview(allButton)
                allButton.addTarget(self, action: #selector(allTeacherButton), for: .touchUpInside)
                
                return view
            case 2:
                let view = UIView()
                view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 20)
                view.backgroundColor = SystemColor.blueColor
                let title = Title4LabelUILabel()
                title.textColor = SystemColor.whiteColor
                title.text = "Расписание экзаменов"
                title.frame = CGRect(x: 15, y: 0, width: self.view.frame.width, height: 30)
                view.addSubview(title)
                
                return view
            default:
                return UIView()
            }
        } else {
            return nil
        }
    }
}

