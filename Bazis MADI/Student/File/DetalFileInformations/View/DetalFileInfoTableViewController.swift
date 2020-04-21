//
//  DetalFileInfoTableViewController.swift
//  Bazis MADI
//
//  Created by Всеволод Андрющенко on 25.03.2020.
//  Copyright © 2020 Всеволод Андрющенко. All rights reserved.
//

import UIKit

//MARK: - ShowReviewDelegate
protocol ShowReviewDelegate: class {
    func showReviewDelegate(fileReview: [ReviewModel])
}

class DetalFileInfoTableViewController: UITableViewController {
    
    @IBOutlet weak var fileNameLabel: Title6LabelUILabel!
    
    @IBOutlet weak var recCountLabel: CountLabelUILabel!
    @IBOutlet weak var fileImage: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var deliteButton: CancelButtonUIButton!
    
    @IBOutlet weak var saveDescButton: DoneButtonUIButton!
    @IBOutlet weak var textField: InfoTextViewUITextView!
    @IBOutlet weak var cancelButton: InputButton1UIButton!
    @IBOutlet weak var loadFileButton: UIButton!
    @IBOutlet weak var donloadProgress: UIProgressView!
    
    private var isSave = true
    private var isDonloadingFile = false
    
    weak var delegate: ShowReviewDelegate!
    
    public var indexFile: Int!
    public var fileData: FileToShowModel!
    
    private var fileDesc: DescModel!
    
    private var controller = FileDetalController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        controller.delegate = self
        setData()
        addGestue()
        setupView()
    }
    
    private func addGestue() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapGestue(_:)))
        view.addGestureRecognizer(tap)
    }
    
    @objc func tapGestue(_ gestue: UIGestureRecognizer) {
        view.endEditing(true)
    }
    
    //show reviewView
    @IBAction func showReviewButtonPres(_ sender: Any) {
        delegate.showReviewDelegate(fileReview: fileDesc.ref as! [ReviewModel])
    }
    
    private func setupView() {
        saveDescButton.isEnabled = false
    }
    
    private func setData() {
        if let file = fileData {
            fileNameLabel.text = file.name
            fileImage.image = file.typeIMG
            dateLabel.text = file.date
            controller.loadDesc(fileName: file.name)
        }
    }
    
    //MARK: - сохрвнение файла
    @IBAction func saveFileButtonPress(_ sender: Any) {
        if !isDonloadingFile {
            
            isDonloadingFile = true
            let urlString = "https://bazis.madi.ru/stud/api/file/download"
            let fileURL = URL(string: urlString)
            let session = URLSession(configuration: .default, delegate: self, delegateQueue: OperationQueue())
            
            var request = URLRequest(url:fileURL!)
            request.httpMethod = "POST"
            request.httpBody = "&p=\(fileData.name)".data(using: .utf8)
            
            let task = session.downloadTask(with: request)
            task.resume()
            
        } else {
            
            let documentsPath = FileManager.default.urls(for: .documentDirectory, in:.userDomainMask)[0]
            let destinationURL = documentsPath.appendingPathComponent(fileData.name)
            let activityViewController = UIActivityViewController(activityItems: [destinationURL] , applicationActivities: nil)
            self.present(activityViewController, animated: true, completion: nil)
        }
    }
    
    @IBAction func deleteButtonPress(_ sender: Any) {
        let alert = UIAlertController(title: "Удаление!", message: "Вы уверенны, что хотите удалить \(fileData.name)?", preferredStyle: .alert)
        let deleteAction = UIAlertAction(title: "Удалить", style: .destructive) { (action) in
            self.controller.fileDelete(index: self.indexFile!, nameFile: self.fileData.name)
            self.dismiss(animated: true, completion: nil)
        }
        alert.addAction(deleteAction)
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    @IBAction func saveDescButtonPress(_ sender: Any) {
        guard let file = fileData else { return }
        controller.updateDesc(fileName:file.name, textDesc: textField.text)
    }
    
    @IBAction func cancelButtonPress(_ sender: Any) {
        if !isSave {
            let alert = UIAlertController(title: "Внимание!", message: "Присутствуют не сохраненные изменения, Вы уверенны что хотите выйти?", preferredStyle: .alert)
            let exitAction = UIAlertAction(title: "Выход", style: .destructive) { (action) in
                self.dismiss(animated: true, completion: nil)
            }
            alert.addAction(exitAction)
            let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
            alert.addAction(cancelAction)
            
            present(alert, animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    
    private func controlEnablebSaveButton() {
        if fileDesc.text != textField.text {
            isSave = false
            saveDescButton.isEnabled = true
        } else {
            isSave = true
            saveDescButton.isEnabled = false
        }
    }
}

//MARK: - InfoFileDelegate
extension DetalFileInfoTableViewController: InfoFileDelegate {
    
    func loadDescFile(fileDesc: DescModel, controller: FileDetalController) {
        self.fileDesc = fileDesc
        self.textField.text = fileDesc.text
        self.recCountLabel.text = String(fileDesc.ref.count)
    }
    
    func setNewDescFile(fileDiscString: String, controller: FileDetalController) {
        self.textField.text = fileDiscString
        self.fileDesc.text = fileDiscString
        dismiss(animated: true, completion: nil)
    }
    
    func showError(errorMess: String, controller: FileDetalController) {
        let alertController = UIAlertController(title: "", message: errorMess, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(alertAction)
        
        present(alertController, animated: true)
    }
}

//MARK: - UITextViewDelegate
extension DetalFileInfoTableViewController: UITextViewDelegate {
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        controlEnablebSaveButton()
    }
}

//MARK: - URLSessionDownloadDelegate
extension DetalFileInfoTableViewController: URLSessionDownloadDelegate {
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        let documentsPath = FileManager.default.urls(for: .documentDirectory, in:.userDomainMask)[0]
        
        let destinationURL = documentsPath.appendingPathComponent(fileData.name)
        try? FileManager.default.removeItem(at: destinationURL)
        do {
            try FileManager.default.copyItem(at: location, to: destinationURL)
            DispatchQueue.main.async {
                
                let activityViewController = UIActivityViewController(activityItems: [destinationURL] , applicationActivities: nil)
                self.present(activityViewController, animated: true, completion: nil)
            }
            
        } catch let error {
            print("Copy Error: \(error.localizedDescription)")
        }
        
        //isDonloadingFile = false
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        
        let procentLoad = Float(totalBytesWritten)/Float(totalBytesExpectedToWrite)
        
        DispatchQueue.main.async {
            self.donloadProgress.progress = procentLoad
        }
    }
    
}
