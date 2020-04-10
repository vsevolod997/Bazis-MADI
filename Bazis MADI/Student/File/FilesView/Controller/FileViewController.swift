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
    private var isHaveFile = false
    
    private var fileData: [FileToShowModel]!
    private var fileDirectoryData: [FileDirectoryModel]!
    
    private let controller = FileToShowModelController()
    
    
    private let notificationReload = Notification.Name("reloadData")
    private let notificationFileDelete = Notification.Name("fileDelete")
    private let notificationFileAdd = Notification.Name("fileAdd")
    
    private var errorVC: ErrorViewUIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        getDirectoryData()
        getFileData()
        
        addNotificationCenter()
    }
    
    private func addNotificationCenter() {
        NotificationCenter.default.addObserver(self, selector: #selector(onNotification(notification:)), name: notificationReload, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(deleteNotification(notification:)), name: notificationFileDelete, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(addNotification(notification:)), name: notificationFileAdd, object: nil)
    }
    
    @objc func addNotification(notification: Notification) {
        
        getFileData()
        let queue = DispatchQueue(label: "backUpdate", qos: .background)
        queue.async {
            self.getDirectoryData()
        }
    }
    
    
    // MARK: - удаление файла из списка
    @objc func deleteNotification(notification: Notification) {
        //print(notification.userInfo?.first?.value)
        let index = notification.userInfo?.first?.value as! Int
        fileData.remove(at: index)
        let queue = DispatchQueue(label: "backUpdate", qos: .background)
        queue.async {
            self.getDirectoryData()
        }
        
        tableView.reloadData()
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
                        self.isHaveFile = self.setupFilesSelection(filesShow: fileModel)
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
    
    //MARK: - кнопка "Добавить"
    @IBAction func addButtonPress(_ sender: Any) {
        //uploadFile
        let sb = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = sb.instantiateViewController(identifier: "uploadFile") as? UploadFileTableViewController else { return }
        vc.uploadPathModel = fileDirectoryData
        present(vc, animated: true)
    }
    
}

//MARK: - TableRaspisanieDelegate, TableRaspisanieDataSource
extension FileViewController: UITableViewDelegate, UITableViewDataSource {
    
    //для обработки скрытия/отображения кнопки
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView == tableView {
            let contentOffset = scrollView.contentOffset.y
            if contentOffset > 0 && contentOffset > self.lastKnowContentOfsset && abs(self.lastKnowContentOfsset - contentOffset) > 25 {
                if !isClose{
                    addButton.closeButton()
                    isClose = true
                }
            } else {
                if isClose {
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
                if isHaveFile {
                     return fileData.count
                } else {
                    return 1
                }
            } else {
                return fileDirectoryData.count
            }
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if isLoad {
            if isFileMode {
                if isHaveFile {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "fileCell", for: indexPath) as! FileTableViewCell
                    cell.fileData = fileData[indexPath.row]
                    return cell
                } else {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "nullCell", for: indexPath)
                    return cell
                }
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.isSelected = false
        
        if !isFileMode {
            //inFolder
            let sb = UIStoryboard(name: "Main", bundle: nil)
            guard let vc = sb.instantiateViewController(identifier: "inFolder") as? FileInFolderViewController else { return }
            vc.filesInFolder = fileDirectoryData[indexPath.row].files
            vc.dirrectory = fileDirectoryData[indexPath.row].path
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            //fileDetal
            let sb = UIStoryboard(name: "Main", bundle: nil)
            guard let vc = sb.instantiateViewController(identifier: "fileDetailMain") as? DetalFileMainViewController else { return }
            vc.fileData = fileData[indexPath.row]
            vc.indexFile = indexPath.row
            present(vc, animated: true)
        }
    }
}
