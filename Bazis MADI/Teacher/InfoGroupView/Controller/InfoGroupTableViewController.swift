//
//  InfoGroupTableViewController.swift
//  Bazis MADI
//
//  Created by Всеволод Андрющенко on 24.02.2020.
//  Copyright © 2020 Всеволод Андрющенко. All rights reserved.
//

import UIKit

class InfoGroupTableViewController: UITableViewController {

  private let weakController = WeekRaspisanieController()
  private var raspisanie: [RaspisanieGroupInfo] = []
  private var typeWeak: String!
  
  private var loadStatus: stateLoadData = .loading
  private let notificationReload = Notification.Name("reloadData")
  
  private var errorVC: ErrorViewUIView!
  
  private let weekController = WeekRaspisanieController()
  
  var groupName: String! {
      didSet {
          title = groupName
          getRaspisanie(groupName: groupName)
      }
  }

  override func viewDidLoad() {
      super.viewDidLoad()
      setupView()
      addNotificationCenter()
  }
  
  //reloadViewNotification
  private func addNotificationCenter() {
      NotificationCenter.default.addObserver(self, selector: #selector(onNotification(notification:)), name: notificationReload, object: nil)
  }
  
  //notification
  @objc func onNotification(notification: Notification) {
      removeErrorView()
      getRaspisanie(groupName: groupName)
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
  
  private func getRaspisanie(groupName: String) {
      
      HttpServiceRaspisanie.getRaspisanieData(groupName: groupName) { (error, model) in
          if error != nil {
              self.showErrorView()
          } else {
              if let classes = model {
                  DispatchQueue.main.async {
                      self.typeWeak = classes.typeWeek
                      self.raspisanie = RaspisanieGroupInfo.getDayliClasses(raspisanie: classes)
                      self.loadStatus = .load
                      self.tableView.reloadData()
                  }
              }
          }
      }
  }
  
  
  //MARK: - настройки окна стартовые
  private func setupView() {
      navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:SystemColor.whiteColor]
      navigationController?.navigationBar.barTintColor = SystemColor.blueColor
  }

}
