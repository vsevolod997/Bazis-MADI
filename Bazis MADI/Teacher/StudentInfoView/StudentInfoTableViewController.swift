//
//  StudentInfoTableViewController.swift
//  Bazis MADI
//
//  Created by Всеволод Андрющенко on 13.04.2020.
//  Copyright © 2020 Всеволод Андрющенко. All rights reserved.
//

import UIKit

class StudentInfoTableViewController: UITableViewController {
    
    @IBOutlet weak var fullNameLabel: Title1LabelUILabel!
    @IBOutlet weak var icoLabel: UserTitleUILabel!
    
    @IBOutlet weak var groupLabel: Title7LabelUILabel!
    
    public var studentInfo: StudentModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    private func setupView() {
        if let student = studentInfo {
            let buff = student.name.split(separator: " ")
            icoLabel.text = String(buff[0].first!) + String(buff[1].first!)
            fullNameLabel.text = student.name
            groupLabel.text = student.group
        }
    }
     
    @IBAction func sentMessageButtonPress(_ sender: Any) {
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionView = UIView()
        let width = self.view.frame.width
        sectionView.frame = CGRect(x: 0, y: 0, width: width, height: 18)
        sectionView.backgroundColor = .clear
        
        return sectionView
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 25
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
}


