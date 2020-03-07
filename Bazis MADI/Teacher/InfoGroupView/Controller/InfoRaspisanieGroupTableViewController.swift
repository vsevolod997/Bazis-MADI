//
//  InfoGroupTableViewController.swift
//  Bazis MADI
//
//  Created by Всеволод Андрющенко on 24.02.2020.
//  Copyright © 2020 Всеволод Андрющенко. All rights reserved.
//

import UIKit

class InfoRaspisanieGroupTableViewController: UITableViewController {
    
    private let weakController = WeekRaspisanieController()
    private var raspisanie: [RaspisanieGroupInfo] = []
    private var typeWeak: String!
    
    private var loadStatus: stateLoadData = .loading
    private let notificationReload = Notification.Name("reloadData")
    
    private var errorVC: ErrorViewUIView!
    
    private let weekController = WeekRaspisanieController()
    
    var groupName: String! {
        didSet {
            title = groupName
            getRaspisanie(groupName: groupName)
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
        getRaspisanie(groupName: groupName)
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
    
//MARK: - получение данных расписания по группе
    private func getRaspisanie(groupName: String) {
        
        HttpServiceRaspisanie.getRaspisanieData(groupName: groupName) { (error, model) in
            if error != nil {
                self.showErrorView()
            } else {
                if let classes = model {
                    DispatchQueue.main.async {
                        print(classes)
                        self.typeWeak = classes.typeWeek
                        self.raspisanie = RaspisanieGroupInfo.getDayliClasses(raspisanie: classes)
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
extension InfoRaspisanieGroupTableViewController {
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
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
                return 0
            case 1:
                return 0
            default:
                return raspisanie[section - 2].classesData.count
            }
        }
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        switch loadStatus {
        case .loading:
            return 1
        case .load:
            return 2 + raspisanie.count
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch loadStatus {
        case .loading:
            return 96
        case .load:
            return 150
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch loadStatus {
        case .loading:
            let cell = tableView.dequeueReusableCell(withIdentifier: "loadCell", for: indexPath)
            return cell
        case .load:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "cellByTeacherGroup", for: indexPath) as? ObjectRspByGroupTableViewCell else { return UITableViewCell() }
            print(raspisanie[indexPath.section - 2].classesData[indexPath.row])
            cell.objectData = raspisanie[indexPath.section - 2].classesData[indexPath.row]
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        switch section {
        case 0:
            let view = UIView()
            view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 30)
            view.backgroundColor = .systemBackground
            let title = Title6LabelUILabel()
            title.text = "Расписание"
            title.frame = CGRect(x: 15, y: 0, width: self.view.frame.width, height: 30)
            view.addSubview(title)
            
            return view
        case 1:
            let view = UIView()
            view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 30)
            view.backgroundColor = .systemBackground
            let title = Title4LabelUILabel()
            title.textColor = SystemColor.grayColor
            let dayName = weekController.getTodayInStr()
            if SystemDevice().isNormalDevice {
                let formatter = DateFormatter()
                formatter.dateFormat = "dd.MM"
                let dateStr = formatter.string(from: Date.today())
                title.text = "Сегодня: - " + typeWeak + ", " + dayName + " (" + dateStr + ")"
            } else {
                title.text = "Сегодня: - " + typeWeak + " " + dayName
            }
            title.frame = CGRect(x: 15, y: 0, width: self.view.frame.width, height: 30)
            view.addSubview(title)
            
            return view
            
        default:
            let view = UIView()
            view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 30)
            view.backgroundColor = .systemBackground
            let title = Title4WLabelUILabel()
            title.text = raspisanie[section - 2].dayTitle
            title.frame = CGRect(x: 15, y: 0, width: self.view.frame.width, height: 30)
            view.addSubview(title)
            
            return view
        }
        
    }
}

