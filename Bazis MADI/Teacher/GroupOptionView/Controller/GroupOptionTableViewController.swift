//
//  GroupOptionTableViewController.swift
//  Bazis MADI
//
//  Created by Всеволод Андрющенко on 25.02.2020.
//  Copyright © 2020 Всеволод Андрющенко. All rights reserved.
//

import UIKit

class GroupOptionTableViewController: UITableViewController {
    

    var groupName: String! {
        didSet {
            title = groupName
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()

    }

    
    //MARK: - Настройки окна
    private func setupView() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor:SystemColor.blueColor]
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:SystemColor.whiteColor]
        navigationController?.navigationBar.tintColor = SystemColor.blueTextColor
        navigationController?.navigationBar.barTintColor = SystemColor.blueColor
    }
    
}

extension GroupOptionTableViewController {
    //MARK: - обработка нажатия на строку
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath)
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 25
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 25
    }
    
    
}
