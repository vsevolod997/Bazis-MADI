//
//  MainViewController.swift
//  Bazis MADI
//
//  Created by Всеволод Андрющенко on 08.12.2019.
//  Copyright © 2019 Всеволод Андрющенко. All rights reserved.
//

import UIKit

class MainTableViewController: UITableViewController {

    @IBOutlet weak var raspisanieTable: TableRaspisanieUIView!
    @IBOutlet weak var changedView: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        raspisanieTable.raspisanieViewDataSource = self
        setupView()
        getDataRaspisanie()
    }
    
    
    private func getDataRaspisanie() {
        guard let userNow = UserLogin.userNow.user else { return }
        let group = String(userNow.user_group)
        print("1234")
        
        HttpServiceRaspisanie.getRaspisData(groupName: group) { (error, raspisanie) in
            print(raspisanie)
        }
    }
    
    
    private func setupView() {
        changedView.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: UIControl.State.selected)
        changedView.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.darkGray], for: UIControl.State.normal)
        
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.barTintColor = SystemColor.blueColor
    }
    
}

extension MainTableViewController: TableRaspisanieDataSource {
    
    func parameterViewDataCount(_ parameterView: TableRaspisanieUIView) -> Int {
        return 7
    }
    
    func parameterViewTitle(_ parametrView: TableRaspisanieUIView, indexPath: IndexPath) -> String {
        return "12345"
    }
    
}
