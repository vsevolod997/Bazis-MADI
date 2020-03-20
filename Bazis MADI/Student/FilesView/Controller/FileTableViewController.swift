//
//  ControllerTableViewController.swift
//  Bazis MADI
//
//  Created by Всеволод Андрющенко on 19.03.2020.
//  Copyright © 2020 Всеволод Андрющенко. All rights reserved.
//

import UIKit

class FileTableViewController: UITableViewController {
    
    var isLoad = false
    var fileData: [FileModel]!
    
    private let notificationReload = Notification.Name("reloadData")
    private var errorVC: ErrorViewUIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getFileData()
        setupView()
    }
    
    private func addNotificationCenter() {
        NotificationCenter.default.addObserver(self, selector: #selector(onNotification(notification:)), name: notificationReload, object: nil)
    }
    
    //notification
    @objc func onNotification(notification: Notification) {
        removeErrorView()
        getFileData()
    }
    
    //MARK: - Настройки окна
    private func setupView() {
        title = "Файлы"
        
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:SystemColor.whiteColor]
        navigationController?.navigationBar.tintColor = SystemColor.whiteColor
        navigationController?.navigationBar.barTintColor = SystemColor.blueColor
        
        let img = UIImage(named: "backButton")
        let backButton = UIBarButtonItem(image: img , style: .done, target: self, action: #selector(backButtonPress) )
        navigationItem.leftBarButtonItem = backButton
    }
    
    
    @objc func backButtonPress() {
        navigationController?.popViewController(animated: true)
    }
    
    private func removeErrorView() {
        if errorVC != nil {
            errorVC.removeFromSuperview()
        }
    }
    
    //MARK: - получение списака файлов
    private func getFileData() {
        isLoad = false
        FileHTTPService.getFileData { (error, portfolioData) in
            if error != nil {
                DispatchQueue.main.async {
                    self.showErrorView()
                }
            } else {
                if let file = portfolioData {
                    DispatchQueue.main.async {
                        self.isLoad = true
                        self.fileData = file
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
    
}

extension FileTableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if isLoad {
            return fileData.count
        } else {
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isLoad {
            let cell = tableView.dequeueReusableCell(withIdentifier: "folderCell", for: indexPath) as! FolderTableViewCell
            
            cell.nameLabel.text = fileData[indexPath.row].path
            if let count = fileData[indexPath.row].files?.count {
                cell.countLabel.text = "/ " + String(count)
            } else {
                cell.countLabel.text = "/ 0"
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "loadCell", for: indexPath)
            return cell
        }
    }
}
