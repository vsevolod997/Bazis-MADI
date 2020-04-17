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
        setupData()
        addGestue()
    }
    
    private func setupView() {
        title = "Студент"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:SystemColor.whiteColor]
        navigationController?.navigationBar.tintColor = SystemColor.whiteColor
        navigationController?.navigationBar.barTintColor = SystemColor.blueColor
        
        let img = UIImage(named: "backButton")
        let backButton = UIBarButtonItem(image: img , style: .done, target: self, action: #selector(backButtonPress) )
        navigationItem.leftBarButtonItem = backButton
    }
    
    private func addGestue() {
        let gestue = UISwipeGestureRecognizer(target: self, action: #selector(backButtonPress))
        gestue.direction = .right
        self.view.addGestureRecognizer(gestue)
    }

    @objc func backButtonPress() {
         navigationController?.popViewController(animated: true)
    }
    
    private func setupData() {
        if let student = studentInfo {
            let buff = student.name.split(separator: " ")
            icoLabel.text = String(buff[0].first!) + String(buff[1].first!)
            fullNameLabel.text = student.name
            groupLabel.text = student.group
        }
    }
    
    @IBAction func sentMessageButtonPress(_ sender: Any) {
        
    }
    
    private func showUspevView() {
        //uspev
        let sb = UIStoryboard(name: "Teacher", bundle: nil)
        guard let vc = sb.instantiateViewController(withIdentifier: "uspev") as? StudentUspevTableViewController else { return }
        vc.studentInfo = self.studentInfo
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func showPortfolioView() {
        let sb = UIStoryboard(name: "Teacher", bundle: nil)
        guard let vc = sb.instantiateViewController(withIdentifier: "portfolio") as? StudentPortfolioTableViewController else { return }
        vc.studentInfo = self.studentInfo
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func showFileView() {
        
    }
}

//MARK: - DataSours\Delegate
extension StudentInfoTableViewController {
    
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 && indexPath.section == 2 {
            showUspevView()
        }
        if indexPath.row == 1 && indexPath.section == 2 {
            showPortfolioView()
        }
        if indexPath.row == 2 && indexPath.section == 2 {
            showFileView()
        }
    }
}




