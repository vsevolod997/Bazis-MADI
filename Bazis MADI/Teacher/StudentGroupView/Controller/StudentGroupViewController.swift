//
//  StudentGroupViewController.swift
//  Bazis MADI
//
//  Created by Всеволод Андрющенко on 10.04.2020.
//  Copyright © 2020 Всеволод Андрющенко. All rights reserved.
//

import UIKit

class StudentGroupViewController: UITableViewController {
    
    private let notificationReload = Notification.Name("reloadData")
    private var errorVC: ErrorViewUIView!
    private var isLoad = false
    
    private var studentsList: [StudentModel] = []
    
    public var nameGroup: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadStudentInGroup(group: nameGroup)
        addNotificationCenter()
        setupView()
        addGestue()
    }
    
    private func setupView() {
        title = nameGroup
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:SystemColor.whiteColor]
        navigationController?.navigationBar.tintColor = SystemColor.whiteColor
        navigationController?.navigationBar.barTintColor = SystemColor.blueColor
        
        let img = UIImage(named: "backButton")
        let backButton = UIBarButtonItem(image: img , style: .done, target: self, action: #selector(backButtonPress) )
        navigationItem.leftBarButtonItem = backButton
    }
    
    private func addGestue() {
        let gestue = UISwipeGestureRecognizer(target: self, action: #selector(backButtonPress))
        gestue.direction = .right
        self.view.addGestureRecognizer(gestue)
    }

    @objc func backButtonPress() {
         navigationController?.popViewController(animated: true)
    }
    
    private func addNotificationCenter() {
        NotificationCenter.default.addObserver(self, selector: #selector(onNotification(notification:)), name: notificationReload, object: nil)
    }
    
    //notification
    @objc func onNotification(notification: Notification) {
        removeErrorView()
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
    
    private func loadStudentInGroup(group: String) {
        SearchStudentHttpService.searchStudentInGroup(groupName: group) { (error, studentRes) in
            if error != nil {
                DispatchQueue.main.async {
                    self.showErrorView()
                }
            } else {
                guard let student = studentRes else { return }
                if student.count > 0 {
                    DispatchQueue.main.async {
                        self.studentsList = student
                        self.isLoad = true
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
}

// MARK: - Table view data source
extension StudentGroupViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isLoad {
            return studentsList.count
        } else {
             return 1
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isLoad {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "studentCell", for: indexPath) as? SudentInGroupTableViewCell else { return UITableViewCell() }
            cell.student = studentsList[indexPath.row]
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "loadCell", for: indexPath)
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if isLoad {
            return 70
        } else {
            return 96
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isLoad {
            let sb = UIStoryboard(name: "Teacher", bundle: nil)
            guard let vc = sb.instantiateViewController(withIdentifier: "studentInfo") as? StudentInfoTableViewController else { return }
            vc.studentInfo = studentsList[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
