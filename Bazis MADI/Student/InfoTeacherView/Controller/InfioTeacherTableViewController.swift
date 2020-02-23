//
//  InfioTeacherTableViewController.swift
//  Bazis MADI
//
//  Created by Всеволод Андрющенко on 15.01.2020.
//  Copyright © 2020 Всеволод Андрющенко. All rights reserved.
//

import UIKit

enum stateLoadData {
    case loading, load
}

class InfioTeacherTableViewController: UITableViewController {

    private let weakController = WeekRaspisanieController()
    private var raspisanie: [RaspisanieModelInfoByTeacher] = []
    
    private var loadStatus: stateLoadData = .loading
    private let notificationReload = Notification.Name("reloadData")
    
    private var errorVC: ErrorViewUIView!
    
    var teacherName: String! {
        didSet {
            let buff = teacherName.split(separator: " ")[0]
            title = String(buff)
            getRaspisanie(name: teacherName)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        addNotificationCenter()
    }
    
    //reloadViewNotification
    private func addNotificationCenter() {
        NotificationCenter.default.addObserver(self, selector: #selector(onNotification(notification:)), name: notificationReload, object: nil)
    }
    
    //notification
    @objc func onNotification(notification: Notification) {
        removeErrorView()
        getRaspisanie(name: teacherName)
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
    
    private func getRaspisanie(name: String) {
        
        HttpServiceRaspisanieTeacher.getRaspisData(teacherName: teacherName) { (error, model) in
            if let err = error {
                self.showErrorView()
            } else {
                if let classes = model {
                    DispatchQueue.main.async {
                        self.raspisanie = RaspisanieModelInfoByTeacher.getDayliClasses(raspisanie: classes)
                        self.loadStatus = .load
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
    
    
    //MARK: - настройки окна стартовые
    private func setupView() {
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:SystemColor.whiteColor]
        navigationController?.navigationBar.barTintColor = SystemColor.blueColor
    }
}



//MARK: - TableViewDataSource
extension InfioTeacherTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch loadStatus {
        case .loading:
            switch section {
            case 0:
                return 1
            case 1:
                return 1
            default:
                return 0
            }
        case .load:
            switch section {
            case 0:
                return 1
            case 1:
                return 0
            default:
                return raspisanie[section - 2].classesData.count
            }
        }
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2 + raspisanie.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 110
        } else {
            return 96
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch loadStatus {
        case .loading:
            if indexPath.section == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "infoCell", for: indexPath) as! InfioTableViewCell
                cell.name = teacherName
                cell.pressButton = {
                    print("mess") // переход на страницу сообщений к перподу
                }
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "loadCell", for: indexPath)
                return cell
            }
        case .load:
            if indexPath.section == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "infoCell", for: indexPath) as! InfioTableViewCell
                cell.name = teacherName
                cell.pressButton = {
                    print("mess") // переход на страницу сообщений к перподу
                }
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "objectCell", for: indexPath) as! RaspisanieTableViewCell
                cell.objectData = raspisanie[indexPath.section - 2].classesData[indexPath.row]
                return cell
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        switch section {
        case 0:
            let view = UIView()
            view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 20)
            view.backgroundColor = .systemBackground
            let title = Title4LabelUILabel()
            title.text = "Преподаватель"
            title.frame = CGRect(x: 15, y: 0, width: self.view.frame.width, height: 30)
            view.addSubview(title)
            
            return view
            
        case 1:
            let view = UIView()
            view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 20)
            view.backgroundColor = .systemBackground
            let title = Title6LabelUILabel()
            title.text = "Расписание"
            title.frame = CGRect(x: 15, y: 0, width: self.view.frame.width, height: 30)
            view.addSubview(title)
            
            return view
            
        default:
            let view = UIView()
            view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 20)
            view.backgroundColor = .systemBackground
            let title = Title4LabelUILabel()
            title.text = raspisanie[section - 2].dayTitle
            title.frame = CGRect(x: 15, y: 0, width: self.view.frame.width, height: 30)
            view.addSubview(title)
            
            return view
        }
        
    }
}
