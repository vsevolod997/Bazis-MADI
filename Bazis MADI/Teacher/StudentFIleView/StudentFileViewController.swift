//
//  StudentFileViewController.swift
//  Bazis MADI
//
//  Created by Всеволод Андрющенко on 22.04.2020.
//  Copyright © 2020 Всеволод Андрющенко. All rights reserved.
//

import UIKit

class StudentFileViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var isLoad = false
    private var isHaveFile = false
    
    private var fileData: [FileToShowModel]!
    private let controller = FileToShowModelController()
    private let notificationReload = Notification.Name("reloadData")
    private var errorVC: ErrorViewUIView!
    
    public var studentInfo: StudentModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        getFileData()
        addNotificationCenter()
        addGestue()
    }
    
    private func addGestue() {
        let gestue = UISwipeGestureRecognizer(target: self, action: #selector(backButtonPress))
        gestue.direction = .right
        self.view.addGestureRecognizer(gestue)
    }
    
    private func addNotificationCenter() {
        NotificationCenter.default.addObserver(self, selector: #selector(onNotification(notification:)), name: notificationReload, object: nil)
    }
    
    //notification
    @objc func onNotification(notification: Notification) {
        removeErrorView()
    }
    
    //MARK: - Настройки окна
    private func setupView() {
        
        if let student = studentInfo {
            let buff = student.name.split(separator: " ")
            if SystemDevice().isNormalDevice {
                title = "Файлы: " + String(buff[0])
            } else {
                title = String(buff[0])
            }
        } else {
            title = "Файлы"
        }
        
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
    //MARK: - получение списка файлов
    private func getFileData() {
        isLoad = false
        fileData = []
        StudFileHttpService.getFileData(stdentUIC: studentInfo.idc) { (error, fileData) in
            if error != nil {
                DispatchQueue.main.async {
                    self.showErrorView()
                }
            } else {
                if let file = fileData {
                    DispatchQueue.main.async {
                        let fileModel = self.controller.setupShowFileToData(modelFile: file)
                        self.isHaveFile = self.setupFilesSelection(filesShow: fileModel)
                        self.fileData = fileModel
                        self.isLoad = true
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
    
    private func setupFilesSelection(filesShow: [FileToShowModel]?) -> Bool{
        if let files = filesShow {
            if files.count > 0 {
                return true
            } else {
                return false
            }
        } else {
            return false
        }
    }
}

//MARK: - TableRaspisanieDelegate, TableRaspisanieDataSource
extension StudentFileViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if isLoad {
            return 140
        } else {
            return 96
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if isLoad {
            return fileData.count
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if isLoad {
            if isHaveFile {
                let cell = tableView.dequeueReusableCell(withIdentifier: "fileCell", for: indexPath) as! FileTableViewCell
                cell.fileData = fileData[indexPath.row]
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "nullCell", for: indexPath)
                return cell
            }
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "loadCell", for: indexPath)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.isSelected = false
        
        if isHaveFile {
            //fileDetal
            let sb = UIStoryboard(name: "Main", bundle: nil)
            guard let vc = sb.instantiateViewController(identifier: "fileDetailMain") as? DetalFileMainViewController else { return }
            vc.fileData = fileData[indexPath.row]
            vc.indexFile = indexPath.row
            present(vc, animated: true)
        }
    }
}
