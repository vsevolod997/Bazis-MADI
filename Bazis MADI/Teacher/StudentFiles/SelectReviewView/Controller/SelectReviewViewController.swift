//
//  SelectReviewViewController.swift
//  Bazis MADI
//
//  Created by Всеволод Андрющенко on 02.05.2020.
//  Copyright © 2020 Всеволод Андрющенко. All rights reserved.
//

import UIKit


//MARK:- SelectReviewFileDelegate
protocol SelectReviewFileDelegate: class {
    
    func scrollView(scrollValue: CGFloat, controller: UIViewController)
    
    func selectView(fileSelected: FileToShowModel, controller: UIViewController)
    
    func deselectView(controller: UIViewController)
}

class SelectReviewViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var isFileMode = true  {
        didSet {
            tableView.separatorStyle = fileDirectoryData.count != 0 ? .singleLine : .singleLine
        }
    }
    
    private var nowSelected = -1 //так как парвое выделение не может быть повторным
    
    private var isLoad = false {
        didSet {
            tableView.separatorStyle = isLoad ? .singleLine : .none
        }
    }
    private var isHaveFile = false {
        didSet {
            tableView.separatorStyle = isHaveFile ? .singleLine : .none
        }
    }
    
    private var fileData: [FileToShowModel]!
    private var fileDirectoryData: [FileDirectoryModel]!
    
    private let controller = FileToShowModelController()
    private let notificationReload = Notification.Name("reloadData")
    
    private var errorVC: ErrorViewUIView!
    
    
    weak var delegate: SelectReviewFileDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        getFileData()
        
        addNotificationCenter()
    }
    
    private func addNotificationCenter() {
        NotificationCenter.default.addObserver(self, selector: #selector(onNotification(notification:)), name: notificationReload, object: nil)
    }
    
    //notification
    @objc func onNotification(notification: Notification) {
        removeErrorView()
        getDirectoryData()
        getFileData()
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

        //navigationItem.prompt = "Выбор файла"

        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:SystemColor.whiteColor]
        navigationController?.navigationBar.tintColor = SystemColor.whiteColor
        navigationController?.navigationBar.barTintColor = SystemColor.blueColor
        
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
        dismiss(animated: true, completion: nil)
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
                } else {
                    DispatchQueue.main.async {
                        self.isLoad = true
                        self.isHaveFile = false
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
extension SelectReviewViewController: UITableViewDelegate, UITableViewDataSource {
    
    //для обработки скрытия/отображения кнопки
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == tableView {
            let contentOffset = scrollView.contentOffset.y
            delegate.scrollView(scrollValue: contentOffset, controller: self)
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView == tableView {
            
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if isLoad {
            if isFileMode {
                return 119
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
                    let cell = tableView.dequeueReusableCell(withIdentifier: "fileCell", for: indexPath) as! SelectReviewFileTableViewCell
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
                    print(count)
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
        
        if !isFileMode {
            let sb = UIStoryboard(name: "Teacher", bundle: nil)
            guard let vc = sb.instantiateViewController(identifier: "inFolder") as? TeacherFileInFolderViewController else { return }
            vc.filesInFolder = fileDirectoryData[indexPath.row].files
            vc.dirrectory = fileDirectoryData[indexPath.row].path
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            if nowSelected != indexPath.row {
                delegate.selectView(fileSelected: fileData[indexPath.row], controller: self)
                nowSelected = indexPath.row
            } else {
                tableView.cellForRow(at: indexPath)?.isSelected = false
                delegate.deselectView(controller: self)
                nowSelected = -1
            }
        }
    }
}
