//
//  UspevTableViewController.swift
//  Bazis MADI
//
//  Created by Всеволод Андрющенко on 20.01.2020.
//  Copyright © 2020 Всеволод Андрющенко. All rights reserved.
//

import UIKit

class UspevTableViewController: UITableViewController {
    
    private var uspevListByObj:[UspevStructDataByObject] = []
    private var uspevListBySem:[UspevStructData] = []
    private var cellList:[IndexPath] = []
    private var allMarkList:[UspevModel] = []
    private var foundMarkList:[UspevModel] = []
    
    private var sectionsButtons: [UIButton] = []
    private let searchController = UISearchController() // строка поиска
    private let notificationReload = Notification.Name("reloadData")
    
    private var errorVC: ErrorViewUIView!
    
    //просмотр по семестрам или по предметам
    private var isSem: Bool = true
    // указатель активности поиска
    private var isSearchResult: Bool {
        guard let text = searchController.searchBar.text else { return true }
        return !text.isEmpty && searchController.isActive
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        setupDataUspev()
        addNotificationCenter()
    }
    
    //reloadViewNotification
    private func addNotificationCenter() {
        NotificationCenter.default.addObserver(self, selector: #selector(onNotification(notification:)), name: notificationReload, object: nil)
    }
    
    //notification
    @objc func onNotification(notification: Notification) {
        removeErrorView()
        setupDataUspev()
    }
    
    //MARK: - получение данных по предметам
    public func setupDataUspev() {
        HttpServiceUspev.getUserUspew() { (err, uspevModel) in
            if err != nil {
                DispatchQueue.main.async {
                     self.showErrorView()
                }
            } else {
                if let uspev = uspevModel {
                    self.allMarkList = uspev
                    DispatchQueue.main.async {
                        self.uspevListByObj = UspevStructDataByObject.modelToDataSem(uspevModel: uspev)
                        self.uspevListBySem = UspevStructData.modelToDataSem(uspevModel: uspev)
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
    
    // изменение типа представления
    @objc func selectSortedType(segment: UISegmentedControl) {
        switch segment.selectedSegmentIndex {
        case 0:
            isSem = true
        case 1:
            isSem = false
        default:
            return
        }
        cellList = []
        sectionsButtons = []
        tableView.reloadData()
    }
    
    //
    private func showErrorView() {
        errorVC = ErrorViewUIView(frame: self.view.frame)
        view.addSubview(errorVC)
    }
    
    private func removeErrorView() {
        if errorVC != nil {
            errorVC.removeFromSuperview()
        }
    }
        
    //MARK: - настройка внешнего вида navBar
    private func setupNavBar() {
        title = "Успеваемость"
        
        searchController.delegate = self
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Поиск..."
        searchController.searchBar.setValue("Отмена", forKey: "cancelButtonText")
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.automaticallyShowsScopeBar = true
        searchController.hidesNavigationBarDuringPresentation = false
        
        searchController.searchBar.scopeButtonTitles = ["Семестр", "Предмет"]
        searchController.searchBar.showsScopeBar = true
        
        //настройка segmet controll
        let scopeBar = searchController.searchBar.value(forKey: "scopeBar") as? UISegmentedControl
        if let segmentController = scopeBar {
            segmentController.selectedSegmentTintColor = SystemColor.blueColor
            segmentController.backgroundColor = .systemBackground
            segmentController.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: SystemColor.whiteColor], for: UIControl.State.selected)
            segmentController.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: SystemColor.grayColor], for: UIControl.State.normal)
            segmentController.addTarget(self, action: #selector(selectSortedType(segment:)), for: .valueChanged)
        }
        
        //настройка строки поиска
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).setTitleTextAttributes([NSAttributedString.Key.foregroundColor: SystemColor.redColor], for: .normal)
        let searchField = searchController.searchBar.value(forKey: "searchField") as? UITextField
        if let field = searchField {
            field.backgroundColor = .systemGroupedBackground
            field.layer.cornerRadius = 15.0
            //field.textColor = SystemColor.whiteColor
            field.tintColor = SystemColor.blueColor
        }
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:SystemColor.whiteColor]
        navigationController?.navigationBar.tintColor = SystemColor.whiteColor
        navigationController?.navigationBar.barTintColor = SystemColor.blueColor
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor:SystemColor.blueColor]
        

        //let leftButton = UIBarButtonItem(title: "Назад", style: .done, target: self, action: #selector(backButtonPress))
        let img = UIImage(named: "backButton")
        let backButton = UIBarButtonItem(image: img , style: .done, target: self, action: #selector(backButtonPress) )
        navigationItem.leftBarButtonItem = backButton
        
    }
    
    // MARK: - нажатие "назад"
    @objc func backButtonPress() {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - нажатие на кнопку развертывания/свертывания секции 
    @objc func sectionsState(_ button: UIButton) {
        
        let generator = UIImpactFeedbackGenerator(style: .rigid)
        generator.impactOccurred()
        
        cellList = []
        let section = button.tag
        var indexPath = [IndexPath]()
        var isShow: Bool
        
        let button = sectionsButtons[section] // кнопка по индексу 
        
        if isSem {
            for row in uspevListBySem[section].dataSem.indices  {
                let iPath = IndexPath(row: row, section: section)
                indexPath.append(iPath)
            }
            
            isShow = uspevListBySem[section].isShow
            uspevListBySem[section].isShow = !isShow
        } else {
            for row in uspevListByObj[section].semInfo.indices {
                let iPath = IndexPath(row: row, section: section)
                indexPath.append(iPath)
            }
            
            isShow = uspevListByObj[section].isShow
            uspevListByObj[section].isShow = !isShow
        }
        if isShow {
            tableView.deleteRows(at: indexPath, with: .fade)
            UIView.animate(withDuration: 0.1) {
                button.imageView?.transform = .init(rotationAngle: CGFloat(Double.pi))
            }
        } else {
            tableView.insertRows(at: indexPath, with: .fade)
            UIView.animate(withDuration: 0.1) {
                button.imageView?.transform = .init(rotationAngle: CGFloat(0.0))
            }
        }

    }
    
}

extension UspevTableViewController {
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        if isSearchResult {
            return 1
        } else {
            if isSem {
                return uspevListBySem.count
            } else {
                return uspevListByObj.count
            }
        }
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearchResult {
            return foundMarkList.count
        } else {
            if isSem {
                if uspevListBySem[section].isShow{
                    return uspevListBySem[section].dataSem.count
                } else {
                    return 0
                }
            } else {
                if uspevListByObj[section].isShow{
                    return uspevListByObj[section].semInfo.count
                } else {
                    return 0
                }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isSearchResult {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! UspevTableViewCell
            cell.data = foundMarkList[indexPath.row]
            
            return cell
        } else {
            if isSem {
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! UspevTableViewCell
                cell.data = uspevListBySem[indexPath.section].dataSem[indexPath.row]
                
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "cellByObj", for: indexPath) as! UspevByObjTableViewCell
                cell.data = uspevListByObj[indexPath.section].semInfo[indexPath.row]
                
                return cell
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if isSearchResult {
           if cellList.contains(indexPath) {
                return 160
            } else {
                return 112
            }
        } else {
            if isSem {
                if cellList.contains(indexPath) {
                    return 160
                } else {
                    return 114
                }
            } else {
                if cellList.contains(indexPath) {
                    return 110
                } else {
                    return 60
                }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if isSem {
            let view = UIView()
            view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 30)
            view.backgroundColor = SystemColor.blueColor
            
            let titleButton = UIButton()
            titleButton.frame = CGRect(x: 0, y: 0, width: 220, height: 30)
            let textColor = SystemColor.whiteColor
            titleButton.contentVerticalAlignment = .center
            titleButton.contentHorizontalAlignment = .left
            titleButton.setTitleColor(textColor, for: .normal)
            titleButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 22)
            titleButton.setImage(UIImage(named: "str")?.withRenderingMode(.alwaysTemplate), for: .normal)
            titleButton.imageView?.contentMode = .scaleAspectFit
            titleButton.imageEdgeInsets = UIEdgeInsets(top:0, left: -20, bottom: 0, right: -40)
            titleButton.titleEdgeInsets = UIEdgeInsets(top:0, left: -40, bottom: 0, right: 0)
            titleButton.tintColor = SystemColor.whiteColor
            titleButton.setTitle( "Семестр № \(section + 1)", for: .normal)
            titleButton.tag = section
            titleButton.imageView?.transform = .init(rotationAngle: CGFloat(Double.pi))
            titleButton.addTarget(self, action: #selector(sectionsState(_:)), for: .touchUpInside)
            
            sectionsButtons.append(titleButton)
            view.addSubview(titleButton)
            
            let sbTitle = TitleT1WLabelUILabel()
            let sb = String(format: "%.2f",uspevListBySem[section].sredMark)
            sbTitle.text = "сред: \(sb)"
                sbTitle.frame = CGRect(x: self.view.frame.width - 100, y: 0, width: 90, height: 30)
            view.addSubview(sbTitle)
            
            return view
            
        } else {
            let view = UIView()
            view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50)
            view.backgroundColor = SystemColor.blueColor
            
            let titleButton = UIButton()
            titleButton.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50)
            let textColor = SystemColor.whiteColor
            titleButton.contentVerticalAlignment = .center
            titleButton.contentHorizontalAlignment = .left
            titleButton.setTitleColor(textColor, for: .normal)
            titleButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
            titleButton.titleLabel?.numberOfLines = 2
            titleButton.setImage(UIImage(named: "str")?.withRenderingMode(.alwaysTemplate), for: .normal)
            titleButton.imageView?.contentMode = .scaleAspectFit
            titleButton.imageEdgeInsets = UIEdgeInsets(top: 10, left: -20, bottom: 10, right: -50)
            titleButton.titleEdgeInsets = UIEdgeInsets(top:0, left: -40, bottom: 0, right: 0)
            titleButton.tintColor = SystemColor.whiteColor
            titleButton.setTitle(uspevListByObj[section].objectData , for: .normal)
            titleButton.tag = section
            titleButton.imageView?.transform = .init(rotationAngle: CGFloat(Double.pi))
            titleButton.addTarget(self, action: #selector(sectionsState(_:)), for: .touchUpInside)
            
            sectionsButtons.append(titleButton)
            view.addSubview(titleButton)
            return view
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if isSearchResult {
            return 0
        } else {
            if isSem{
                return 30
            } else {
                return 50
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if isSearchResult {
            return 0
        } else {
            return 50
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50)
        view.backgroundColor = SystemColor.whiteTextFill
        view.alpha = 0.8
        
        let button = UIButton()
        button.frame = CGRect(x: 0, y: 0, width: self.view.frame.width , height: 50)
        let textColor = SystemColor.blueTextColor
        button.contentVerticalAlignment = .center
        button.contentHorizontalAlignment = .center
        button.setTitleColor(textColor, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 40)
        button.setTitle( ". . .", for: .normal)
        button.alpha = 0.8
        button.tag = section
        button.addTarget(self, action: #selector(sectionsState(_:)), for: .touchUpInside)
        
        view.addSubview(button)
        return view
    }
}

//MARK: - Table view Delegate
extension UspevTableViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if isSearchResult {
            if cellList.contains(indexPath) {
                cellList.remove(at: cellList.firstIndex(of: indexPath)!)
                tableView.reloadRows(at: [indexPath], with: .fade)
                guard let cell = tableView.cellForRow(at: indexPath) as? UspevTableViewCell else { return }
                cell.showFull(isShow: false)
            } else {
                cellList.append(indexPath)
                tableView.reloadRows(at: [indexPath], with: .fade)
                guard let cell = tableView.cellForRow(at: indexPath) as? UspevTableViewCell else { return }
                cell.showFull(isShow: true)
            }
            
        } else {
            
            if cellList.contains(indexPath) {
                cellList.remove(at: cellList.firstIndex(of: indexPath)!)
                tableView.reloadRows(at: [indexPath], with: .fade)
                if isSem {
                    guard let cell = tableView.cellForRow(at: indexPath) as? UspevTableViewCell else { return }
                    cell.showFull(isShow: false)
                } else {
                    guard let cell = tableView.cellForRow(at: indexPath) as? UspevByObjTableViewCell else { return }
                    cell.showFull(isShow: false)
                }
            } else {
                cellList.append(indexPath)
                tableView.reloadRows(at: [indexPath], with: .fade)
                if isSem{
                    guard let cell = tableView.cellForRow(at: indexPath) as? UspevTableViewCell else { return }
                    cell.showFull(isShow: true)
                } else {
                    guard let cell = tableView.cellForRow(at: indexPath) as? UspevByObjTableViewCell else { return }
                    cell.showFull(isShow: true)
                }
                
            }
        }
    }
}

// MARK: - UISearchControllerDelegate
extension UspevTableViewController: UISearchControllerDelegate {
    
    func presentSearchController(_ searchController: UISearchController) {
        cellList = []
        sectionsButtons = []
        navigationItem.titleView?.transform = .init(translationX: 0, y: -50)
    }
    
    func didDismissSearchController(_ searchController: UISearchController) {
        cellList = []
        sectionsButtons = []
        tableView.reloadData()
        navigationItem.titleView?.transform = .init(translationX: 0, y: 50)
    }
}

// MARK: - UISearchResultUpdate
extension UspevTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        cellList = []
        filterData(searchText: searchController.searchBar.text!)
        tableView.reloadData()
    }
    
    private func filterData(searchText: String) {
        foundMarkList = allMarkList.filter({ (uspev: UspevModel) -> Bool in
            return uspev.disc.lowercased().contains(searchText.lowercased()) })
    }
}


