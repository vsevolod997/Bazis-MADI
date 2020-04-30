//
//  MainTableTeacherViewController.swift
//  Bazis MADI
//
//  Created by Всеволод Андрющенко on 03.01.2020.
//  Copyright © 2020 Всеволод Андрющенко. All rights reserved.
//

import UIKit
import AVFoundation

class MainTableTeacherViewController: UITableViewController {
    
    @IBOutlet weak var raspisanieByGroupView: TableRaspisanieByGroupUIView!
    @IBOutlet weak var raspisanieTable: TableRaspisanieTeacherUIVIew!
    @IBOutlet weak var changedView: UISegmentedControl!
    @IBOutlet weak var dataControl: UIPageControl!
    
    private let notificationReload = Notification.Name("reloadData")
    
    private let userLogin = UserDataController()
    private var closeVC: CloseViewUIView! //окно для закрывания загрузки
    private var errorVC: ErrorViewUIView!
    private let homeController = HomeTableViewController()
    private let weakRaspisanie = WeekRaspisanieController()
    
    private var allRaspisanie: RaspisanieModelTeacher!
    private var isWeekNow: Bool = true
    private var isLoad: Bool = false
    
    private var dayCount: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        raspisanieByGroupView.raspisanieByGroupDataSource = self
        raspisanieTable.raspisanieViewDataSource = self
        raspisanieTable.delegate = self
        raspisanieByGroupView.delegate = self
        
        setupView()
        getDataRaspisanie()
        addNotificationCenter()
    }
    
    private func addNotificationCenter() {
        NotificationCenter.default.addObserver(self, selector: #selector(onNotification(notification:)), name: notificationReload, object: nil)
    }
    
    //notification
    @objc func onNotification(notification: Notification) {
        removeVC()
        removeErrorView()
        getDataRaspisanie()
    }
    
    //MARK: - Обработка получения расписания
    private func getDataRaspisanie() {
        self.showVC()
        if let user = UserLogin.userNow.user {
            raspisanieSet(teacherName: user.user_fio)
        } else {// иначе показали окно загрузки загрузку,
            if let user = userLogin.getUserData() {
                HttpService.getUserAccount(login: user.login, password: user.password) { (err, model, modelErr) in // пробуем получили данные по текущему log pas
                    if let user = model { // !получили\\ заролнили поля пользователя
                        self.raspisanieSet(teacherName: user.user_fio)
                    } else { // !не получили \\выкинули на экран логина если log, pas не совпали
                        if modelErr != nil {
                            DispatchQueue.main.async {
                                self.removeVC()
                                self.showLoginView()
                            }
                        } else {
                            DispatchQueue.main.async {
                                self.removeVC()
                                self.showErrorView()
                            }
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Запрос расписания по ФИО пользователя
    private func raspisanieSet(teacherName: String) {
        let dataTeacher = teacherName.split(separator: " ")
        let bufStrTeacer = String(dataTeacher[0]) + " " + String(dataTeacher[1].first!) + "." + String(dataTeacher[2].first!) + "."
        HttpServiceRaspisanieTeacher.getRaspisData(teacherName: bufStrTeacer) { (error, raspisanie) in
            DispatchQueue.main.async {
                if error != nil {
                    self.showErrorView()
                } else {
                    if let raspis = raspisanie {
                        if let errorLoad = raspis.error {
                            print(errorLoad)
                        } else {
                            DispatchQueue.main.async {
                                
                                self.allRaspisanie = raspis
                                self.dayCount = self.countDayliView(teacherRaspisanie: raspis)
                                self.raspisanieTable.setupView(weekInCalendar: .now)
                                self.raspisanieByGroupView.setupDataView()
                                self.dataControl.numberOfPages = self.dayCount
                                self.setDayControl(dayCount: self.dayCount, dayNow: self.weakRaspisanie.getToday())
                                self.removeVC()
                                self.removeErrorView()
                                
                                self.isLoad = true
                                self.tableView.reloadData()
                            }
                            self.selectWeakType(raspisanieData: raspis)
                        }
                    }
                }
            }
        }
    }
    
    // MARK: Отображение текущего типа недели
    private func selectWeakType(raspisanieData: RaspisanieModelTeacher) {
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
    
    private func showVC() {
        closeVC = CloseViewUIView(frame: self.view.frame)
        view.addSubview(closeVC)
    }
    
    private func removeVC() {
        closeVC.removeFromSuperview()
    }
    
    
    //MARK: - выбор дня сегодня
    private func setDayControl(dayCount: Int, dayNow: Int) {
        
        if dayNow > dayCount {
            dataControl.currentPage = dayCount
        } else if dayCount == 1 {
            dataControl.currentPage = 0
        } else if dayCount == dayNow {
            dataControl.currentPage = dayNow
        }
    }
    
    //MARK: - Настройки окна
    private func setupView() {
        
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
        setDayControl(dayCount: self.dayCount, dayNow: weekday)
    }
    
    // MARK: - подсчет кол ва загятых дней в неделю
    private func countDayliView(teacherRaspisanie: RaspisanieModelTeacher) -> Int {
        var count = 0
        if let raspisnie = allRaspisanie {
            if ((raspisnie.result?.monday) != nil) {
                count += 1
            }
            if ((raspisnie.result?.tuesday) != nil) {
                count += 1
            }
            if ((raspisnie.result?.wednesday) != nil) {
                count += 1
            }
            if ((raspisnie.result?.thursday) != nil) {
                count += 1
            }
            if ((raspisnie.result?.friday) != nil) {
                count += 1
            }
            if ((raspisnie.result?.saturday) != nil) {
                count += 1
            }
        }
        return count
    }
    
    // MARK: - нажатин кнопки все, у расписания
    @objc func selectAllGroup() {
        let sb = UIStoryboard(name: "Teacher", bundle: nil)
        guard let vc = sb.instantiateViewController(withIdentifier: "studSearch") as? SearchStudentsTableViewController else { return }
        navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK: - TableRaspisanieDataSource
extension MainTableTeacherViewController: TableRaspisanieTeacherDataSource {
    
    func raspisanieDayliWorkCount(_ parameterView: TableRaspisanieTeacherUIVIew) -> Int {
        return dayCount
    }
    
    func raspisanieDayNow(_ parametrView: TableRaspisanieTeacherUIVIew) -> Int {
        return weakRaspisanie.getToday()
    }
    
    func raspisanieWeakNow(_ parametrView: TableRaspisanieTeacherUIVIew) -> Bool {
        return changedView.selectedSegmentIndex == 0 ? true : false
    }
    
    func raspisanieTableData(_ parametrView: TableRaspisanieTeacherUIVIew, indexDay: Int) -> [DailyRaspisanieTeacher]? {
        
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

extension MainTableTeacherViewController: TableRaspisanieTeacherDelegate {
    func changedDay(_ parametrView: TableRaspisanieTeacherUIVIew, didSelectItem index: Int) {
        dataControl.currentPage = index
    }
}


//MARK: - данные списка групп
extension MainTableTeacherViewController: TableRaspisanieByGroupDataSource, TableRaspisanieByGroupDelegate {
    
    func selectShowInfoGroup(_ parametrView: TableRaspisanieByGroupUIView, selectedGroup : String) {
        
        let alert = UIAlertController(title: nil, message: "Группа: " + selectedGroup, preferredStyle: .actionSheet)
        
        let messImg = UIImage(named:"msgGroup")
        let alertMes = UIAlertAction(title: "Диалог", style: .default) { (sction) in
            print("show message")
        }
        alertMes.setValue(messImg, forKey: "image")
        
        let stydentImage = UIImage(named: "userGroup")
        let aletrStudent = UIAlertAction(title: "Студенты", style: .default) { (action) in
            self.showGroupStudentView(groupName: selectedGroup)
        }
        aletrStudent.setValue(stydentImage, forKey: "image")
        
        let raspisanieImage = UIImage(named: "groupRSP")
        let alertRaspisanie = UIAlertAction(title: "Расписание", style: .default) { (action) in
            self.showGroupRaspisanieView(groupName: selectedGroup)
        }
        alertRaspisanie.setValue(raspisanieImage, forKey: "image")
        
        
        let alertCancel = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)

        alert.addAction(alertMes)
        alert.addAction(aletrStudent)
        alert.addAction(alertRaspisanie)
        alert.addAction(alertCancel)
        
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.impactOccurred()
        
        present(alert, animated: true)
    }
    
    private func showGroupRaspisanieView(groupName: String) {
        let sb = UIStoryboard(name: "Teacher", bundle: nil)
        guard let vc = sb.instantiateViewController(withIdentifier: "detalGroupRaspisanie") as? InfoRaspisanieGroupTableViewController else { return }
        vc.groupName = groupName
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func showGroupStudentView(groupName: String) {
        let sb = UIStoryboard(name: "Teacher", bundle: nil)
        guard let vc = sb.instantiateViewController(withIdentifier: "studentInGroup") as? StudentGroupViewController else { return }
        vc.nameGroup = groupName
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func raspisanieByGroupData(_ parametrView: TableRaspisanieByGroupUIView) -> [String]? {
        var allPars: [DailyRaspisanieTeacher] = []
        
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
            if let name = pars.group {
                if !result.contains(name) && name != "" {
                    result.append(name)
                }
            }
        }
        return result.sorted()
    }
}

//MARK: - отображения
extension MainTableTeacherViewController {
    
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
                    title.text = "По группам"
                } else {
                    title.text = "Расписание по группам"
                }// проверка устройства
                title.frame = CGRect(x: 15, y: 0, width: self.view.frame.width, height: 30)
                view.addSubview(title)
                
                let allButton = ShowMoreUIButton()
                allButton.frame = CGRect(x: self.view.frame.width - 70, y: 0, width: 70, height: 30)
                allButton.addTarget(self, action: #selector(selectAllGroup), for: .touchUpInside)
                view.addSubview(allButton)
                
                return view
            default:
                return UIView()
            }
        } else {
            let view = UIView()
            view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 20)
            view.backgroundColor = .clear
            return view
        }
    }
}
