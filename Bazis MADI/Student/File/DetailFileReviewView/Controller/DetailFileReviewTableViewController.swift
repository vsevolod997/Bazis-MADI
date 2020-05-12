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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addGestue()
    }

    private func addGestue() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(backGestue))
        view.addGestureRecognizer(tap)
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
        return 10
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "reviewCell", for: indexPath) as? ReviewTableViewCell else { return UITableViewCell() }
        cell.teacherNameLabel.text = fileReview[0].own
        cell.reviewNameLabel.text = fileReview[0].link
        //cell.indexFile = indexPath.row
        cell.clouserDownload = {
            print(indexPath.row)
        }

        return cell
    }
}
