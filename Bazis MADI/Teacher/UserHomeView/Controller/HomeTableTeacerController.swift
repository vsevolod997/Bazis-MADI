//
//  HomeTableTeacerController.swift
//  Bazis MADI
//
//  Created by Всеволод Андрющенко on 08.01.2020.
//  Copyright © 2020 Всеволод Андрющенко. All rights reserved.
//

import UIKit

class HomeTableTeacerController: UITableViewController {

    @IBOutlet weak var userFullNameLabel: Title1LabelUILabel!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var typeLabel: Title2LabelUILabel!
    
    private let userLogin = UserDataController()
    private var closeVC: CloseViewUIView!
    private var errorVC: ErrorViewUIView!
    
    private let notificationReload = Notification.Name("reloadData")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setData()
        setupView()
        addNotificationCenter()
    }
    
    
    private func addNotificationCenter() {
        NotificationCenter.default.addObserver(self, selector: #selector(onNotification(notification:)), name: notificationReload, object: nil)
    }
    
    //notification
    @objc func onNotification(notification: Notification) {
        removeVC()
        removeErrorView()
        setData()
    }
    
    
    //MARK: - настройки окна стартовые
    private func setupView() {
        userLabel.layer.masksToBounds = true
        userLabel.layer.cornerRadius = 15
        
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: SystemColor.whiteColor]
        navigationController?.navigationBar.barTintColor = SystemColor.blueColor
         self.title = "Личный кабинет"
    }

    //MARK: - получение данных о текущем пользователе
    private func setData() {
        if let user = UserLogin.userNow.user { // сюда попадаем если прошли процедуру логина во вью
            userFullNameLabel.text = user.user_fio
            typeLabel.text = user.user_group
            
            let data = user.user_fio.split(separator: " ")
            userLabel.text = String(data[0].first!) + "" + String(data[1].first!)
        } else { // иначе показали окно загрузки загрузку,
            showVC()
            if let user = userLogin.getUserData() {
                HttpService.getUserAccount(login: user.login, password: user.password) { (err, model, modelErr) in // пробуем получили данные по текущему log pas
                    if let user = model { // !получили\\ заролнили поля пользователя
                        DispatchQueue.main.async {
                            self.userFullNameLabel.text = user.user_fio
                            self.typeLabel.text = user.user_group
                            
                            let data = user.user_fio.split(separator: " ")
                            self.userLabel.text = String(data[0].first!) + "" + String(data[1].first!)
                            self.removeVC()
                        }
                    } else { // !не получили \\выкинули на экран логина если log, pas не совпали
                        if modelErr != nil {
                            DispatchQueue.main.async {
                                self.removeVC()
                                self.showLoginView()
                            }
                        } else {
                            DispatchQueue.main.async {
                                self.removeVC()
                                self.showErrorView()
                            }
                        }
                    }
                }
            }
        }
    }
    
    private func showVC() {
        closeVC = CloseViewUIView(frame: self.view.bounds)
        view.addSubview(closeVC)
    }
    
    private func removeVC() {
        if closeVC != nil {
             closeVC.removeFromSuperview()
        }
    }
    
    
    private func showErrorView() {
        errorVC = ErrorViewUIView(frame: self.view.frame)
        view.addSubview(errorVC)
    }
    
    private func removeErrorView() {
        if errorVC != nil {
            errorVC.removeFromSuperview()
        }
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
        if indexPath.row == 0 && indexPath.section == 3 {
            exitUserButton()
        }
        if indexPath.row == 0 && indexPath.section == 1 {
            
        }
        if indexPath.row == 1 && indexPath.section == 1 {
            changedFileView()
        }
        if indexPath.row == 2 && indexPath.section == 1 {
            changedPasViewShow()
        }
    }
    
    private func changedStudentView() {
       
    }
    
    //MARK: - переход к окну смены пароля
    private func changedPasViewShow() {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = sb.instantiateViewController(identifier: "password") as? PasswordChangeViewController else { return }
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func changedFileView() {
        let sb = UIStoryboard(name: "Teacher", bundle: nil)
        guard let vc = sb.instantiateViewController(identifier: "file") as? TeacherFilesViewController else { return }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func exitUserButton() {
        let alertActions = UIAlertController(title: "Внимание!", message: "Вы хотите выйти из аккаунта?", preferredStyle: .alert)
        let actionYes = UIAlertAction(title: "Выход", style: .destructive) { (exit) in
            self.userLogin.clearUserData()
            self.showLoginView()
        }
        
        let actionNo = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        alertActions.addAction(actionNo)
        alertActions.addAction(actionYes)
        
        self.present(alertActions, animated: true)
    }
    
    private func showLoginView() {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(identifier: "login")
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
        
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.impactOccurred()
    }

}
