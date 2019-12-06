//
//  HomeTableVIewControllerTableViewController.swift
//  Bazis MADI
//
//  Created by Всеволод Андрющенко on 27.11.2019.
//  Copyright © 2019 Всеволод Андрющенко. All rights reserved.
//

import UIKit

class HomeTableViewController: UITableViewController {

    @IBOutlet weak var userFullNameLabel: Title1LabelUILabel!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var grupLabel: Title2LabelUILabel!
    
    var closeVC = CloseViewUIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userLabel.layer.masksToBounds = true
        userLabel.layer.cornerRadius = 15
        
        self.title = "Личный кабинет"
        
        setData()
    }

    private func setData(){
        if let user = UserLogin.userNow.user {
            userFullNameLabel.text = user.user_fio
            grupLabel.text = user.user_group
            
            let data = user.user_fio.split(separator: " ")
            userLabel.text = String(data[0].first!) + "" + String(data[1].first!)
        } else {
            showVC()
            let userLogin = UserDataController()
            if let user = userLogin.getUserData() {
                HttpService.getUserAccount(login: user.login, password: user.password) { (err, model, modelErr) in
                    if let user = model {
                        DispatchQueue.main.async {
                            self.userFullNameLabel.text = user.user_fio
                            self.grupLabel.text = user.user_group
                            
                            let data = user.user_fio.split(separator: " ")
                            self.userLabel.text = String(data[0].first!) + "" + String(data[1].first!)
                            self.removeVC()
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.removeVC()
                            self.exitUser()
                        }
                    }
                }
            }
        }
    }
    
    private func showVC() {
        closeVC = CloseViewUIView(frame: self.view.bounds)
        //closeVC.frame = view.bounds
        view.addSubview(closeVC)
    }
    
    private func removeVC() {
        closeVC.removeFromSuperview()
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
    
    //MARK: - нажатие на таблицу
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 && indexPath.section == 3{
           exitUser()
        }
        
    }
    
    private func exitUser(){
        let userDataController = UserDataController()
        userDataController.clearUserData()
        
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(identifier: "login")
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
}
