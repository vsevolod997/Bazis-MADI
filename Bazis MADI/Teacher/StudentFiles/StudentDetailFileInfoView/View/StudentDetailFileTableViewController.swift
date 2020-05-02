//
//  StudentDetailViewTableViewController.swift
//  Bazis MADI
//
//  Created by Всеволод Андрющенко on 26.04.2020.
//  Copyright © 2020 Всеволод Андрющенко. All rights reserved.
//

import UIKit

class StudentDetailFileTableViewController: UITableViewController {
    
    @IBOutlet weak var fileNameLabel: Title6LabelUILabel!
    @IBOutlet weak var reviewLabel: Title7LabelUILabel!
    
    @IBOutlet weak var fileImage: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
   
    @IBOutlet weak var textField: InfoTextViewUITextView!
    @IBOutlet weak var cancelButton: InputButton1UIButton!
    @IBOutlet weak var loadFileButton: UIButton!
    @IBOutlet weak var donloadProgress: UIProgressView!
    @IBOutlet weak var reviewAddDellButton: AddDellUIButton!
    
    private var isDonloadingFile = false
    private var isHaveReview = false
    
   
    
    public var fileData: FileToShowModel!
    public var student: StudentModel!
    
    private var fileDesc: DescModel!
    
    weak var delegate: ShowReviewDelegate!
    
    private var controller = StudFileDetailController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        controller.delegate = self
        setData()
        addGestue()
        addReviewGestue()
    }
    
    private func addGestue() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapGestue(_:)))
        view.addGestureRecognizer(tap)
    }
    
    //MARK: - просмотр файла
    private func addReviewGestue() {
        let tapNameReview = UITapGestureRecognizer(target: self, action: #selector(showDetalReviewInfo))
        reviewLabel.addGestureRecognizer(tapNameReview)
    }
    
    @objc func showDetalReviewInfo() {
        UIView.animate(withDuration: 0.2, animations: {
            self.reviewLabel.transform = .init(scaleX: 1.2, y: 1.2)
        }, completion: { _ in
            UIView.animate(withDuration: 0.2) {
                self.reviewLabel.transform = .init(scaleX: 1.0, y: 1.0)
            }
        })
    }
    
    @objc func tapGestue(_ gestue: UIGestureRecognizer) {
        view.endEditing(true)
    }
    
    
    private func showReviewFileInfo() {
        let sb = UIStoryboard(name: "Teacher", bundle: nil)
        let vc = sb.instantiateViewController(identifier: "file")
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func setData() {
        if let file = fileData {
            fileNameLabel.text = file.name
            fileImage.image = file.typeIMG
            dateLabel.text = file.date
            controller.loadDesc(fileName: file.name, studentIdc: student.idc)
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
            request.httpBody = "&p=\(fileData.name)&uic=\(student.idc)".data(using: .utf8)
            
            let task = session.downloadTask(with: request)
            task.resume()
        } else {
            let documentsPath = FileManager.default.urls(for: .documentDirectory, in:.userDomainMask)[0]
            let destinationURL = documentsPath.appendingPathComponent(fileData.name)
            let activityViewController = UIActivityViewController(activityItems: [destinationURL] , applicationActivities: nil)
            self.present(activityViewController, animated: true, completion: nil)
        }
    }
    
    
    @IBAction func addDellButtonPress(_ sender: Any) {
        if isHaveReview {
            deliteReview()
        } else {
            print("add")
        }
    }
    
    //удаление рецензии
    private func deliteReview() {
        let action = UIAlertController(title: "Внимание!", message: "Вы хотите удалить рецензию?", preferredStyle: .alert)
        let dell = UIAlertAction(title: "Удалить", style: .destructive) { _ in
            self.controller.deleteReview(fileName: self.fileData.name, studentIdc: self.student.idc)
        }
        action.addAction(dell)
        
        let cancel = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        action.addAction(cancel)
    
        present(action,animated: true)
    }
    
    @IBAction func cancelButtonPress(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

//MARK: - InfoFileDelegate
extension StudentDetailFileTableViewController: StudInfoFileDelegate {
    
    func removeReview(controler: StudFileDetailController) {
        reviewAddDellButton.setAddStyle()
        isHaveReview = false
        reviewLabel.text = "Рецензия отсутствует"
        reviewLabel.textColor = .label
        reviewLabel.isEnabled = false
    }
    
    
    func controlHavingReview(isHaveReview: Bool, revieName: String, controller: StudFileDetailController) {
        self.isHaveReview = isHaveReview
        
        if isHaveReview {
            reviewLabel.text = revieName
            reviewLabel.textColor = .link
            reviewLabel.isEnabled = true
            reviewAddDellButton.setDellStyle()
        }
    }
    
    
    func loadDescFile(fileDesc: DescModel, controller: StudFileDetailController) {
        self.fileDesc = fileDesc
        self.textField.text = fileDesc.text
    }
    
    func showError(errorMess: String, controller: StudFileDetailController) {
        reviewAddDellButton.isEnabled = false
        reviewLabel.isEnabled = false
        let alertController = UIAlertController(title: "Внимание", message: errorMess, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(alertAction)
        present(alertController, animated: true)
    }
}

//MARK: - URLSessionDownloadDelegate
extension StudentDetailFileTableViewController: URLSessionDownloadDelegate {
    
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
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        
        let procentLoad = Float(totalBytesWritten)/Float(totalBytesExpectedToWrite)
        
        DispatchQueue.main.async {
            self.donloadProgress.progress = procentLoad
        }
    }
    
}
