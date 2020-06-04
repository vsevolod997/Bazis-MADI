//
//  StudentFullInfoTableViewController.swift
//  Bazis MADI
//
//  Created by Всеволод Андрющенко on 04.06.2020.
//  Copyright © 2020 Всеволод Андрющенко. All rights reserved.
//

import UIKit

class StudentFullInfoTableViewController: UITableViewController {
    
    public var studentUIC: String!
    
    private var isLoad = false
    private var studentInfo: FullStudInfoModel!
    private var errorVC: ErrorViewUIView!
    
    private let notificationReload = Notification.Name("reloadData")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addNotificationCenter()
        loadData()
    }
    
    private func addNotificationCenter() {
        NotificationCenter.default.addObserver(self, selector: #selector(onNotification(notification:)), name: notificationReload, object: nil)
    }
    
    //notification
    @objc func onNotification(notification: Notification) {
        removeErrorView()
        loadData()
    }
    
    // получить данные
    private func loadData() {
        StudentInfoHttpService.getFullInfo(uicStudent: studentUIC) { (error, result) in
            if error != nil {
                DispatchQueue.main.async {
                    self.showErrorView()
                }
            } else {
                if let res = result {
                    DispatchQueue.main.async {
                        self.isLoad = true
                        self.studentInfo = res
                        self.tableView.reloadData()
                    }
                }
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
}

// MARK: - Table view data source
extension StudentFullInfoTableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isLoad {
            return studentInfo.lineModel.count
        } else {
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isLoad {
            //partInfo
            let cell = tableView.dequeueReusableCell(withIdentifier: "partInfo", for: indexPath)
            cell.detailTextLabel?.text = studentInfo.lineModel[indexPath.row].lineData as? String
            cell.textLabel?.text = studentInfo.lineModel[indexPath.row].lineTitle
            return cell
        } else {
             let cell = tableView.dequeueReusableCell(withIdentifier: "loadCell", for: indexPath)
             return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if isLoad {
            return studentInfo.nameStudent
        } else {
            return ""
        }
    }
}
