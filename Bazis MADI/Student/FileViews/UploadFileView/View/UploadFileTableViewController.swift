//
//  UploadFileTableViewController.swift
//  Bazis MADI
//
//  Created by Всеволод Андрющенко on 01.04.2020.
//  Copyright © 2020 Всеволод Андрющенко. All rights reserved.
//

import UIKit

class UploadFileTableViewController: UITableViewController, UIDocumentPickerDelegate  {
    
    let uploadPath = "Учебные работы/Курсовые проекты"
    let fileName = "filename"
    
    private let controller = UploadFileController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        controller.delegate = self
    }
    
    // MARK: - Table view data source
    @IBAction func sendFileButton(_ sender: Any) {
        
        let importMenu = UIDocumentPickerViewController(documentTypes: [String("public.data")], in: .import)
        importMenu.delegate = self
        importMenu.modalPresentationStyle = .formSheet
        self.present(importMenu, animated: true, completion: nil)
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        
        guard let url = urls.first else { return }
        guard let type = url.absoluteString.split(separator: ".").last else { return }
        let fullName = fileName + "." + String(type)
        
        self.controller.uploadFile(fileURL: url, uploadPath: uploadPath, fileName: fullName)
    }
    
}
extension UploadFileTableViewController: UploadFileDelegate {
    func showError(errorMess: String, controller: UploadFileController) {
        print(errorMess)
    }
    
    func showOk(controller: UploadFileController) {
        print("fileAppend")
    }
}

