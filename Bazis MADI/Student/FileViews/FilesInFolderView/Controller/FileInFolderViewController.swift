//
//  FileInFolderViewController.swift
//  Bazis MADI
//
//  Created by Всеволод Андрющенко on 23.03.2020.
//  Copyright © 2020 Всеволод Андрющенко. All rights reserved.
//

import UIKit

class FileInFolderViewController: UIViewController {
    
    @IBOutlet weak var addButton: AddButtonUIButton!
    @IBOutlet weak var tableView: UITableView!
    
    private var fileToShowController =  FileToShowModelController()
    private var filesToShow: [FileToShowModel]!
    
    private var fileName = ""
    
    private var isFile = false
    private var isClose = false
    
    private var lastKnowContentOfsset: CGFloat = 0.0
    
    
    var dirrectory: String! {
        didSet {
            title = dirrectory
        }
    }
    
    var filesInFolder: [FileModel]! {
        didSet {
            filesToShow = fileToShowController.setupShowFileToData(modelFile: filesInFolder)
            isFile = setupFilesSelection(filesShow: filesToShow)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
    }
    
    // MARK: - удаление файла из списка
    @objc func deleteNotification(notification: Notification) {
        let index = notification.userInfo?.first?.value as! Int
        filesToShow.remove(at: index)
        tableView.reloadData()
    }
    
    private func setupView() {
        navigationItem.prompt = "Файлы"
        //navigationController?.navigationBar.
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
    
    @IBAction func addButtonPress(_ sender: Any) {
        
    }
}

//MARK: UITableViewDataSource, UITableViewDelegate
extension FileInFolderViewController: UITableViewDataSource, UITableViewDelegate {
    
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
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFile {
            return filesToShow.count
        } else {
            return 1
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isFile {
            let cell = tableView.dequeueReusableCell(withIdentifier: "fileCell", for: indexPath) as! FileTableViewCell
            cell.fileData = filesToShow[indexPath.row]
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "nullCell", for: indexPath)
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if isFile {
            return 140
        } else {
            return 60
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isFile {
            let sb = UIStoryboard(name: "Main", bundle: nil)
            guard let vc = sb.instantiateViewController(identifier: "fileDetailMain") as? DetalFileMainViewController else { return }
            vc.fileData = filesToShow[indexPath.row]
            vc.indexFile = indexPath.row
            present(vc, animated: true)
        }
    }
}
