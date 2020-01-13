//
//  MainTableTeacherViewController.swift
//  Bazis MADI
//
//  Created by Всеволод Андрющенко on 03.01.2020.
//  Copyright © 2020 Всеволод Андрющенко. All rights reserved.
//

import UIKit

class MainTableTeacherViewController: UITableViewController {
    
    @IBOutlet weak var raspisanieTable: TableRaspisanieTeacherUIVIew!
    @IBOutlet weak var changedView: UISegmentedControl!
    @IBOutlet weak var dataControl: UIPageControl!
    
    let userLogin = UserDataController()
    var closeVC: CloseViewUIView! //окно для закрывания загрузки
    let homeController = HomeTableViewController()
    let weakRaspisanie = WeekRaspisanieController()
    
    var allRaspisanie: RaspisanieModelTeacher!
    var isWeekNow: Bool = true
    
    var dayCount: Int = 0
    
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
            raspisanieSet(teacherName: user.user_fio)
        } else {// иначе показали окно загрузки загрузку,
            if let user = userLogin.getUserData() {
                HttpService.getUserAccount(login: user.login, password: user.password) { (err, model, modelErr) in // пробуем получили данные по текущему log pas
                    if let user = model { // !получили\\ заролнили поля пользователя
                        self.raspisanieSet(teacherName: user.user_fio)
                    } else { // !не получили \\выкинули на экран логина если log, pas не совпали
                        DispatchQueue.main.async {
                            self.showLoginView()
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
        print(bufStrTeacer)
        HttpServiceRaspisanieTeacher.getRaspisData(teacherName: bufStrTeacer) { (error, raspisanie) in
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
                                self.dayCount = self.countDayliView(teacherRaspisanie: raspis)
                                self.raspisanieTable.setupView(weekInCalendar: .now)
                                self.dataControl.numberOfPages = self.dayCount
                                self.removeVC()
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
    
    private func showVC() {
        closeVC = CloseViewUIView(frame: self.view.frame)
        view.addSubview(closeVC)
    }
    
    private func removeVC() {
        closeVC.removeFromSuperview()
    }
    
    //MARK: - Настройки окна
    private func setupView() {
        dataControl.currentPage = weakRaspisanie.getToday()
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
        isWeekNow = !isWeekNow
        
        if isWeekNow {
            raspisanieTable.setupView(weekInCalendar: .now)
        } else {
            raspisanieTable.setupView(weekInCalendar: .next)
        }
        let weekday = weakRaspisanie.getToday()
        
        if weekday == 0 {
            dataControl.currentPage = weekday
        } else {
            dataControl.currentPage = weekday / dayCount
        }
        
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
//MARK: - отображения
extension MainTableTeacherViewController {
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        switch section {
        case 0:
            let view = UIView()
            view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 20)
            view.backgroundColor = .white
            let title = Title4LabelUILabel()
            title.text = "Расписание"
            title.frame = CGRect(x: 15, y: 0, width: self.view.frame.width, height: 30)
            view.addSubview(title)
            
            return view
        case 1:
            let view = UIView()
            view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 20)
            view.backgroundColor = .white
            let title = Title4LabelUILabel()
            title.text = "Группы"
            title.frame = CGRect(x: 15, y: 0, width: self.view.frame.width, height: 30)
            view.addSubview(title)
            
            return view
            
        default:
            return UIView()
        }
    }
}
