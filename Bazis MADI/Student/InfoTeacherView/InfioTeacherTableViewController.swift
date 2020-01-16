//
//  InfioTeacherTableViewController.swift
//  Bazis MADI
//
//  Created by Всеволод Андрющенко on 15.01.2020.
//  Copyright © 2020 Всеволод Андрющенко. All rights reserved.
//

import UIKit

class InfioTeacherTableViewController: UITableViewController {

    @IBOutlet weak var teacherRaspisanieView: DayliRaspisTeacerUIView!
    @IBOutlet weak var teacherNameLabel: Title1LabelUILabel!
    @IBOutlet weak var teacherLabel: UserTitleUILabel!
    
    var teacherName: String! 

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
        if let name = teacherName {
            teacherNameLabel.text = name
            let buff = name.split(separator: " ")
            teacherLabel.text = String(buff[0].first!) + "" + String(buff[1].first!)
        }

    }
    
    //MARK: - настройки окна стартовые
    private func setupView() {
        
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:SystemColor.whiteColor]
        navigationController?.navigationBar.barTintColor = SystemColor.blueColor
         self.title = "Детальная информация"
    }
}

extension InfioTeacherTableViewController {
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        switch section {
        case 0:
            let view = UIView()
            view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 20)
            view.backgroundColor = SystemColor.whiteColor
            let title = Title4LabelUILabel()
            title.text = "Преподаватель"
            title.frame = CGRect(x: 15, y: 0, width: self.view.frame.width, height: 30)
            view.addSubview(title)
            
            return view
        case 1:
            let view = UIView()
            view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 20)
            view.backgroundColor = SystemColor.whiteColor
            let title = Title4LabelUILabel()
            title.text = "Расписание"
            title.frame = CGRect(x: 15, y: 0, width: self.view.frame.width - 50, height: 30)
            view.addSubview(title)

            return view
            
        default:
            return UIView()
        }
    }
}
