//
//  StudentGroupViewController.swift
//  Bazis MADI
//
//  Created by Всеволод Андрющенко on 10.04.2020.
//  Copyright © 2020 Всеволод Андрющенко. All rights reserved.
//

import UIKit

class StudentGroupViewController: UITableViewController {
    
    private let notificationReload = Notification.Name("reloadData")
    private var errorVC: ErrorViewUIView!
    
    public var nameGroup: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addNotificationCenter()
        setupView()
        addGestue()
    }
    
    private func setupView() {
        title = nameGroup
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
    
    private func addNotificationCenter() {
        NotificationCenter.default.addObserver(self, selector: #selector(onNotification(notification:)), name: notificationReload, object: nil)
    }
    
    //notification
    @objc func onNotification(notification: Notification) {
        
        removeErrorView()
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

}

// MARK: - Table view data source
extension StudentGroupViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "studentCell", for: indexPath) as? SudentInGroupTableViewCell else { return UITableViewCell() }
        cell.icoLabel.text = "АВ"
        cell.nameLabel.text = "Андрющенко Всеволод"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}
