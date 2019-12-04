//
//  HomeTableVIewControllerTableViewController.swift
//  Bazis MADI
//
//  Created by Всеволод Андрющенко on 27.11.2019.
//  Copyright © 2019 Всеволод Андрющенко. All rights reserved.
//

import UIKit

class HomeTableVIewControllerTableViewController: UITableViewController {

    @IBOutlet weak var userFullNameLabel: Title1LabelUILabel!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var grupLabel: Title2LabelUILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userLabel.layer.masksToBounds = true
        userLabel.layer.cornerRadius = 15
        
        self.title = "Личный кабинет"
        
        setData()
    }

    private func setData(){
        guard let user = UserLogin.userNow.user else { return }
        userFullNameLabel.text = user.user_fio
        grupLabel.text = user.user_group
        
        let data = user.user_fio.split(separator: " ")
        userLabel.text = String(data[0].first!) + "" + String(data[1].first!)
    }
    
    //MARK: - setup Table View
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
