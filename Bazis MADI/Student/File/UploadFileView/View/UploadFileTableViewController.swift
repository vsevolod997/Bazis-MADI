//
//  UploadFileTableViewController.swift
//  Bazis MADI
//
//  Created by Всеволод Андрющенко on 01.04.2020.
//  Copyright © 2020 Всеволод Андрющенко. All rights reserved.
//

import UIKit
import AVFoundation

//MARK: - окно выгрузки файла
class UploadFileTableViewController: UITableViewController {
    
    @IBOutlet weak var descriptionFileTextView: InfoTextViewUITextView!
    @IBOutlet weak var dirrectoryUploadLabel: EditingTextFieldUITextField!
    @IBOutlet weak var fileNameLabel: EditingTextFieldUITextField!
    @IBOutlet weak var stateSelectFile: Title7LabelUILabel!
    @IBOutlet weak var selectFileButton: UIButton!
    @IBOutlet weak var uploadButton: DoneButtonUIButton!
    
    private var uploadingView: UploadUIView!
    private var pathPicker = UIPickerView()
   
    private var isHaveChanging = false {
        didSet {
            isModalInPresentation = isHaveChanging
        }
    }
    
    private var fileType = ""
    private var fileData: Data!
    private var isSelectedFile = false
    private var row: Int!
    
    private let controller = UploadFileController()
    
    public var uploadPath: String!
    public var uploadPathModel: [FileDirectoryModel]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addGestue()
        setupView()
        setupPathPicker()
    }
    
    private func setupView() {
        
        
        controller.delegate = self
        uploadButton.isEnabled = false
        
        if let path = uploadPath {
            dirrectoryUploadLabel.text = path
        }
        
        if uploadPathModel == nil {
            controller.getPathDirrectory()
        }
    }
    
    
    private func setupPathPicker() {
        pathPicker.dataSource = self
        pathPicker.delegate = self
        descriptionFileTextView.delegate = self
        
        let toolBar = UIToolbar()
        toolBar.isTranslucent = true
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Готово", style:.done, target: self, action: #selector(selectPathUpload(sender:)) )
        let spacer = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        toolBar.setItems([doneButton, spacer], animated: true)
        
        dirrectoryUploadLabel.inputAccessoryView = toolBar
        dirrectoryUploadLabel.inputView = pathPicker
    }
    
    @objc func selectPathUpload(sender: UIPickerView) {
        let r = row ?? 0
        dirrectoryUploadLabel.text = uploadPathModel[r].path
        view.endEditing(true)
    }
    
    private func addGestue() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(endEdit(_:)))
        view.addGestureRecognizer(tap)
    }
    
    
    @objc func endEdit(_ selecror: UIGestureRecognizer) {
        view.endEditing(true)
    }
    
    
    //MARK - выбор файла
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
    
    
    //MARK: - Выгрузить
    @IBAction func uploadButtonPress(_ sender: Any) {
        view.endEditing(true)
        
        guard let fileDesc = descriptionFileTextView.text else { return }
        guard let fileName = fileNameLabel.text else { return }
        uploadPath = dirrectoryUploadLabel.text
        guard let path = uploadPath else { return }
        
        guard let data = fileData else { return }
        let fullName = fileName + "." + fileType
        
        self.controller.uploadFile(uploadData: data, uploadPath: path, fileName: fullName, fileDesk: fileDesc)
    }
    
    
    //MARK: - Отмена
    @IBAction func cancelButtonPress(_ sender: Any) {
        if isHaveChanging {
           showExitAlert()
        } else {
             self.dismiss(animated: true, completion: nil)
        }
    }
    
    
    //MARK - предупреждение о наличии несохраненных изменений
    private func showExitAlert() {
        let alert = UIAlertController(title: "Внимание!", message: "Присутствуют не сохраненные изменения, Вы уверенны что хотите выйти?", preferredStyle: .alert)
        let exitAction = UIAlertAction(title: "Выход", style: .destructive) { (action) in
            self.dismiss(animated: true, completion: nil)
        }
        alert.addAction(exitAction)
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    private func selectFile() {
        let importMenu = UIDocumentPickerViewController(documentTypes: [String("public.data")], in: .import)
        importMenu.delegate = self
        importMenu.modalPresentationStyle = .formSheet
        
        present(importMenu, animated: true, completion: nil)
    }
    
    private func selectImg() {
        let imagePicer = UIImagePickerController()
        imagePicer.delegate = self
        imagePicer.sourceType = .savedPhotosAlbum
        present(imagePicer, animated: true)
    }
    
    private func showUploadView() {
        if uploadingView == nil {
            let frame = CGRect(x: 0, y: 0, width: 150, height: 150)
            uploadingView = UploadUIView(frame: frame)
            uploadingView.center = self.view.center
            
            view.addSubview(uploadingView)
        } else {
            removeUploadView()
        }
    }
    
    private func removeUploadView() {
        if uploadingView != nil {
            uploadingView.removeFromSuperview()
        }
    }
    
}

//MARK: - UIDocumentPickerDelegate
extension UploadFileTableViewController: UIDocumentPickerDelegate {
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        if let url = urls.first {
            self.controller.selectUploadFile(urlFile: url)
            self.controller.controlUploadButtonEnabled(uploadPath: dirrectoryUploadLabel.text, fileName: fileNameLabel.text, dataUpload: fileData)
        }
    }
}

//MARK: - UIImagePickerControllerDelegate
extension UploadFileTableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            if let name = info[UIImagePickerController.InfoKey.imageURL] as? URL {
                self.controller.selectUploadPhoto(image: image, name: name.lastPathComponent)
            }
            dismiss(animated: true, completion: nil)
            controller.controlUploadButtonEnabled(uploadPath: dirrectoryUploadLabel.text, fileName: fileNameLabel.text, dataUpload: fileData)
        }
    }
}

//MARK: - UploadFileDelegate
extension UploadFileTableViewController: UploadFileDelegate {
    
    func setUploadingPath(controller: UploadFileController, path: [FileDirectoryModel]) {
        uploadPathModel = path
    }
    
    
    func exportButtonIsEnabled(controller: UploadFileController, isEnabled: Bool) {
        uploadButton.isEnabled = isEnabled
    }
    
    
    func uploadIsStart(controller: UploadFileController) {
        self.showUploadView()
        self.uploadButton.isEnabled = false
    }
    
    func uploadIsFinish(controller: UploadFileController) {
        UIView.animate(withDuration: 0.3, animations: {
            self.uploadingView.transform = .init(scaleX: 0.5, y: 0.5)
            self.uploadingView.alpha = 0.5
        }) { (_) in
            self.removeUploadView()
            
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func uploadFileIsSelected(selectFileName: String, fileName: String, fileType: String, dataFile: Data) {
        isHaveChanging = true
        fileNameLabel.text = fileName
        stateSelectFile.text = selectFileName
        self.fileType = fileType
        self.fileData = dataFile
    }
    
    func showError(errorMess: String, controller: UploadFileController) {
        
        let alert = UIAlertController(title: "Ошибка!", message: "Не удалось выгрузить файл.", preferredStyle: .alert)
        let action = UIAlertAction(title: "Ок", style:  .default) { (_) in
            self.removeUploadView()
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}

//MARK: - UITextFieldDelegate
extension UploadFileTableViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        isHaveChanging = true
        controller.controlUploadButtonEnabled(uploadPath: dirrectoryUploadLabel.text, fileName: fileNameLabel.text, dataUpload: fileData)
        if textField == fileNameLabel {
            if fileNameLabel.text?.last == "." || fileNameLabel.text?.last == "/" {
                fileNameLabel.text?.removeLast()
            }
        }
    }
}

//MARK: - UITextViewDelegate
extension UploadFileTableViewController: UITextViewDelegate {
    func textViewDidChangeSelection(_ textView: UITextView) {
        isHaveChanging = true
    }
}

//MARK: - UploadFileTableViewController
extension UploadFileTableViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if let path = uploadPathModel {
            return path.count
        } else {
            return 1
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = Title5LabelUILabel()
        label.numberOfLines = 3
        label.text = uploadPathModel[row].path
        label.frame = CGRect(x: 0, y: 0, width: self.view.frame.width , height: 70)
        label.textAlignment = .center
        return label
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 70
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.row = row
    }
}
