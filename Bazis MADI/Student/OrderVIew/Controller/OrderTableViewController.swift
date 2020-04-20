//
//  PricazTableViewController.swift
//  Bazis MADI
//
//  Created by Всеволод Андрющенко on 18.04.2020.
//  Copyright © 2020 Всеволод Андрющенко. All rights reserved.
//

import UIKit


class OrderTableViewController: UITableViewController {

    private let notificationReload = Notification.Name("reloadData")
    
    private var orders: [[OrderModel]] = []
    private var errorVC: ErrorViewUIView!
    private var isLoad: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addNotificationCenter()
        loadOrderData()
        setupView()
        addGestue()
    }

    
    private func addNotificationCenter() {
        NotificationCenter.default.addObserver(self, selector: #selector(onNotification(notification:)), name: notificationReload, object: nil)
    }
    
    //notification
    @objc func onNotification(notification: Notification) {
        removeErrorView()
        loadOrderData()
    }
    
    private func addGestue() {
        let gestue = UISwipeGestureRecognizer(target: self, action: #selector(backButtonPress))
        gestue.direction = .right
        self.view.addGestureRecognizer(gestue)
    }
    
    private func loadOrderData() {
        OrderHttpService.getStudentOrder { (error, orders) in
            if error != nil {
                DispatchQueue.main.async {
                    self.showErrorView()
                }
            } else {
                if let orderData = orders {
                    DispatchQueue.main.async {
                        self.orders = orderData
                        self.isLoad = true
                        print(orderData)
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
    
    
    //MARK: - Настройки окна
    private func setupView() {
        title = "Приказы"
        
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:SystemColor.whiteColor]
        navigationController?.navigationBar.tintColor = SystemColor.whiteColor
        navigationController?.navigationBar.barTintColor = SystemColor.blueColor
        
        let img = UIImage(named: "backButton")
        let backButton = UIBarButtonItem(image: img , style: .done, target: self, action: #selector(backButtonPress) )
        navigationItem.leftBarButtonItem = backButton
    }
    
    @objc func backButtonPress() {
        navigationController?.popViewController(animated: true)
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
extension OrderTableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        if isLoad {
            return orders.count
        } else {
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isLoad {
            return orders[section].count
        } else {
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isLoad {
            let cell = tableView.dequeueReusableCell(withIdentifier: "partOrder", for: indexPath)
            cell.textLabel?.text = orders[indexPath.section][indexPath.row].lineTitle
            cell.detailTextLabel?.text = orders[indexPath.section][indexPath.row].lineData as! String
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "loadOrdCell", for: indexPath)
            return cell
        }
    }
    
}
