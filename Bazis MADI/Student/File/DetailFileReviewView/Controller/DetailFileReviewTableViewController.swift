//
//  DetailFileReviewTableViewController.swift
//  Bazis MADI
//
//  Created by Всеволод Андрющенко on 31.03.2020.
//  Copyright © 2020 Всеволод Андрющенко. All rights reserved.
//

import UIKit

// MARK: - FileReviewDelegate
protocol FileReviewDelegate: class {
    func closeFileReview()
}

class DetailFileReviewTableViewController: UITableViewController {
    
    weak var delegate: FileReviewDelegate!
    
    public var fileReview: [ReviewModel]!
    private var indexLoad: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addGestue()
    }
    
    private func addGestue() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(backGestue))
        view.addGestureRecognizer(tap)
    }
    
    private func downloadFile(nameFile: String) {
        let user = UserLogin.userNow.user.user_uic
        let urlString = "https://bazis.madi.ru/stud/api/file/download"
        let fileURL = URL(string: urlString)
        let session = URLSession(configuration: .default, delegate: self, delegateQueue: OperationQueue())
        
        var request = URLRequest(url:fileURL!)
        request.httpMethod = "POST"
        request.httpBody = "&p=\(nameFile)&uic=\(user)".data(using: .utf8)
        
        let task = session.downloadTask(with: request)
        task.resume()
    }
    
    @objc func backGestue() {
        delegate.closeFileReview()
    }
}

// MARK: - Table view data source
extension DetailFileReviewTableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fileReview.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "reviewCell", for: indexPath) as? ReviewTableViewCell else { return UITableViewCell() }
        cell.teacherNameLabel.text = fileReview[indexPath.row].own
        cell.reviewNameLabel.text = fileReview[indexPath.row].link
        
        cell.clouserDownload = {
            self.downloadFile(nameFile: self.fileReview[indexPath.row].link)
        }
        
        return cell
    }
}

extension DetailFileReviewTableViewController: URLSessionDelegate {
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        let documentsPath = FileManager.default.urls(for: .documentDirectory, in:.userDomainMask)[0]
        
        let destinationURL = documentsPath.appendingPathComponent(fileReview[indexLoad!].link)
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
        
        let indexPath = IndexPath(row: indexLoad!, section: 0)
        guard let cell = tableView.cellForRow(at: indexPath) as? ReviewTableViewCell else { return }
        DispatchQueue.main.async {
            cell.updateDownloadProgres(loadProgress: procentLoad)
        }
    }
    
}
