//
//  FileViewController.swift
//  Bazis MADI
//
//  Created by Всеволод Андрющенко on 23.03.2020.
//  Copyright © 2020 Всеволод Андрющенко. All rights reserved.
//

import UIKit

class FileViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var addButton: AddButtonUIButton!
    
    private var lastKnowContentOfsset: CGFloat = 0.0
    
    private var isClose = false
    private var isFileMode = true
    private var isLoad = false
    
    private var fileData: [FileToShowModel]!
    private var fileDirectoryData: [FileDirectoryModel]!
    
    private let controller = FileToShowModelController()
    
    private let notificationReload = Notification.Name("reloadData")
    private var errorVC: ErrorViewUIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        getDirectoryData()
        getFileData()
    }
    
    private func addNotificationCenter() {
        NotificationCenter.default.addObserver(self, selector: #selector(onNotification(notification:)), name: notificationReload, object: nil)
    }
    
    //notification
    @objc func onNotification(notification: Notification) {
        removeErrorView()
        getDirectoryData()
    }
    
    //MARK: - Настройки окна
    private func setupView() {
        
        let segmentController = UISegmentedControl(items: ["Каталоги", "Файлы"])
        segmentController.selectedSegmentIndex = 1
        segmentController.selectedSegmentTintColor = SystemColor.blueColor
        segmentController.backgroundColor = .systemBackground
        segmentController.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: SystemColor.whiteColor], for: UIControl.State.selected)
        segmentController.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: SystemColor.grayColor], for: UIControl.State.normal)
        segmentController.addTarget(self, action: #selector(selectShowMode(_:)), for: .valueChanged)
        navigationItem.titleView = segmentController
        
        navigationItem.prompt = "Файлы"
        //navigationController?.navigationBar.
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:SystemColor.whiteColor]
        navigationController?.navigationBar.tintColor = SystemColor.whiteColor
        navigationController?.navigationBar.barTintColor = SystemColor.blueColor
        
        let img = UIImage(named: "backButton")
        let backButton = UIBarButtonItem(image: img , style: .done, target: self, action: #selector(backButtonPress) )
        navigationItem.leftBarButtonItem = backButton
    }
    
    
    //MARK: - модель отобрадения данных
    @objc func selectShowMode(_ scopeBar: UISegmentedControl) {
        switch scopeBar.selectedSegmentIndex {
        case 0:
            isFileMode = false
        case 1:
            isFileMode = true
        default:
            return
        }
        tableView.reloadData()
    }
    
    
    @objc func backButtonPress() {
        navigationController?.popViewController(animated: true)
    }
    
    private func removeErrorView() {
        if errorVC != nil {
            errorVC.removeFromSuperview()
        }
    }
    
    //MARK: - получение списка дирректорий
    private func getDirectoryData() {
        isLoad = false
        FileHTTPService.getDirectoryFileData { (error, dirData) in
            if error != nil {
                DispatchQueue.main.async {
                    self.showErrorView()
                }
            } else {
                if let file = dirData {
                    DispatchQueue.main.async {
                        self.isLoad = true
                        self.fileDirectoryData = file
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
    
    //MARK: - получение списка файлов
    private func getFileData() {
        isLoad = false
        fileData = []
        FileHTTPService.getFileData { (error, fileData) in
            if error != nil {
                DispatchQueue.main.async {
                    self.showErrorView()
                }
            } else {
                if let file = fileData {
                    DispatchQueue.main.async {
                        self.isLoad = true
                        let fileModel = self.controller.setupShowFileToData(modelFile: file)
                        self.fileData = fileModel
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
    //MARK: - кнопка "Добавить"
    @IBAction func addButtonPress(_ sender: Any) {
        
    }
    
}

//MARK: - TableRaspisanieDelegate, TableRaspisanieDataSource
extension FileViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView == tableView {
            let contentOffset = scrollView.contentOffset.y
            print("contentOffset: ", contentOffset)
            print(abs(self.lastKnowContentOfsset - contentOffset))
            if contentOffset > 0 && contentOffset > self.lastKnowContentOfsset && abs(self.lastKnowContentOfsset - contentOffset) > 25 {
                if !isClose{
                    print("close")
                    addButton.closeButton()
                    isClose = true
                }
            } else {
                if isClose {
                    print("Open")
                    addButton.oppenButton()
                    isClose = false
                }
            }
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView == tableView {
            self.lastKnowContentOfsset = scrollView.contentOffset.y
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if isLoad {
            if isFileMode {
                return 140
            } else {
                return 79
            }
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
            if isFileMode {
                return fileData.count
            } else {
                return fileDirectoryData.count
            }
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isLoad {
            if isFileMode{
                let cell = tableView.dequeueReusableCell(withIdentifier: "fileCell", for: indexPath) as! FileTableViewCell
                cell.fileData = fileData[indexPath.row]
                
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "folderCell", for: indexPath) as! FolderTableViewCell
                
                cell.nameLabel.text = fileDirectoryData[indexPath.row].path
                if let count = fileDirectoryData[indexPath.row].files?.count {
                    cell.countLabel.text = "/ " + String(count)
                } else {
                    cell.countLabel.text = "/ 0"
                }
                return cell
            }
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "loadCell", for: indexPath)
            return cell
        }
    }
}
