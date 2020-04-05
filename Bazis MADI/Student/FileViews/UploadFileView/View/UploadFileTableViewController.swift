//
//  UploadFileTableViewController.swift
//  Bazis MADI
//
//  Created by Всеволод Андрющенко on 01.04.2020.
//  Copyright © 2020 Всеволод Андрющенко. All rights reserved.
//

import UIKit

//MARK: - окно выгрузки файла
class UploadFileTableViewController: UITableViewController {
    
    @IBOutlet weak var descriptionFileTextView: InfoTextViewUITextView!
    
    @IBOutlet weak var dirrectoryUploadLabel: EditingTextFieldUITextField!
    
    @IBOutlet weak var fileNameLabel: EditingTextFieldUITextField!
    @IBOutlet weak var stateSelectFile: Title7LabelUILabel!
    @IBOutlet weak var selectFileButton: UIButton!
    @IBOutlet weak var uploadButton: DoneButtonUIButton!
    
    
    var uploadPath: String! = "Учебные работы/Курсовые проекты"
    
    private var filetype = ""
    private var urlFile: URL!
    private var isSelectedFile = false
    
    private let controller = UploadFileController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addGestue()
        controller.delegate = self
    }
    
    
    private func addGestue() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(endEdit(_:)))
        view.addGestureRecognizer(tap)
    }
    
    
    @objc func endEdit(_ selecror: UIGestureRecognizer) {
        view.endEditing(true)
    }
    
    
    @IBAction func selectFileButtonPress(_ sender: Any) {
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let image = UIImage(named: "imgButton")
        let aletrPhoto = UIAlertAction(title: "Фото", style: .default) { (action) in
            self.selectImg()
        }
        aletrPhoto.setValue(image, forKey: "image")
        
        let doc = UIImage(named: "folderButton")
        let alertDoc = UIAlertAction(title: "Документ", style: .default) { (action) in
            self.selectFile()
        }
        alertDoc.setValue(doc, forKey: "image")
        
        let alertCancel = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        
        alert.addAction(aletrPhoto)
        alert.addAction(alertDoc)
        alert.addAction(alertCancel)
        
        present(alert, animated: true)
    }
    
    
    @IBAction func uploadButtonPress(_ sender: Any) {
        
        guard let fileName = fileNameLabel.text else { return }
        guard let uploadP = uploadPath else { return }
        guard let url = urlFile else { return }
        let fullName = fileName + "." + filetype
        
        self.controller.uploadFile(fileURL: url, uploadPath: uploadP, fileName: fullName)
    }
    
    @IBAction func cancelButtonPress(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    private func selectFile() {
        let importMenu = UIDocumentPickerViewController(documentTypes: [String("public.data")], in: .import)
        importMenu.delegate = self
        importMenu.modalPresentationStyle = .formSheet
        self.present(importMenu, animated: true, completion: nil)
    }
    
    private func selectImg() {
        let imagePicer = UIImagePickerController()
        imagePicer.delegate = self
        imagePicer.sourceType = .photoLibrary
        present(imagePicer, animated: true)
    }
}

//MARK: - UIDocumentPickerDelegate
extension UploadFileTableViewController: UIDocumentPickerDelegate {
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        
        if let url = urls.first {
            self.urlFile = url
            self.controller.selectUploadFile(urlFile: url)
            if let type = url.absoluteString.split(separator: ".").last {
                self.filetype = String(type)
            }
        }
    }
}

//MARK: - UIDocumentPickerDelegate
extension UploadFileTableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print(info[UIImagePickerController.InfoKey.imageURL])
        if let pickerImage = info[UIImagePickerController.InfoKey.imageURL] as? URL {
            dismiss(animated: true, completion: nil)
        }
    }
}

//MARK: - UploadFileDelegate
extension UploadFileTableViewController: UploadFileDelegate {
    
    func uploadFileIsSelected(file: String, fileName: String, isSelected: Bool) {
        
        fileNameLabel.text = fileName
        stateSelectFile.text = file
        isSelectedFile = isSelected
    }
    
    func showError(errorMess: String, controller: UploadFileController) {
        print(errorMess)
    }
    
    func showOk(controller: UploadFileController) {
        print("fileAppend")
    }
}

//MARK: - UITextFieldDelegate
extension UploadFileTableViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
    
}


