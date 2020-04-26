//
//  SearchStudentsTableViewController.swift
//  Bazis MADI
//
//  Created by Всеволод Андрющенко on 23.04.2020.
//  Copyright © 2020 Всеволод Андрющенко. All rights reserved.
//

import UIKit

//MARK: - "состояние файла"
enum LoadStatus {
    case loading, loadGroup, loadStud, notFound, wait
}

//MARK: - как сделать
class SearchStudentsTableViewController: UITableViewController {
    
    private let notificationReload = Notification.Name("reloadData")
    
    private var errorVC: ErrorViewUIView!
    
    private var isSearchGroup = true // true - group, false - student by fio
    private var studentList: [StudentModel] = []
    private var activStudent: [StudentModel] = []
    private var oldStudent: [StudentModel] = []
    
    private let searchController = UISearchController() // строка поиска
    
    private var status: LoadStatus = .wait
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavBar()
        addGestue()
        addNotificationCenter()
    }
    
    
    //MARK: - настройка внешнего вида navBar
    private func setupNavBar() {
        
        title = "Все студенты"
        
        searchController.delegate = self
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Поиск..."
        searchController.searchBar.setValue("Отмена", forKey: "cancelButtonText")
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.automaticallyShowsScopeBar = true
        searchController.hidesNavigationBarDuringPresentation = false
        
        searchController.searchBar.scopeButtonTitles = ["Группа", "Студент"]
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
            field.tintColor = SystemColor.blueColor
        }
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:SystemColor.whiteColor]
        navigationController?.navigationBar.tintColor = SystemColor.whiteColor
        navigationController?.navigationBar.barTintColor = SystemColor.blueColor
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor:SystemColor.blueColor]
        
        let img = UIImage(named: "backButton")
        let backButton = UIBarButtonItem(image: img , style: .done, target: self, action: #selector(backButtonPress) )
        navigationItem.leftBarButtonItem = backButton
    }
    
    // изменение типа представления
    @objc func selectSortedType(segment: UISegmentedControl) {
        switch segment.selectedSegmentIndex {
        case 0:
            isSearchGroup = true
        case 1:
            isSearchGroup = false
        default:
            return
        }
        status = .wait
        oldStudent = []
        activStudent = []
        studentList = []
        updateSearchResults(for: searchController)
    }
    
    
    private func addGestue() {
        let gestue = UISwipeGestureRecognizer(target: self, action: #selector(backButtonPress))
        gestue.direction = .right
        
        self.view.addGestureRecognizer(gestue)
    }
    
    // MARK: - нажатие "назад"
    @objc func backButtonPress() {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    //reloadViewNotification
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
    
    
    // MARK: - поиск по названию группы
    private func searchGroup(group: String) {
        status = .loading
        tableView.reloadData()
        SearchStudentHttpService.searchStudentInGroup(groupName: group) { (error, result) in
            if error != nil {
                DispatchQueue.main.async {
                    self.showErrorView()
                }
            } else {
                DispatchQueue.main.async {
                    if let student = result {
                        if student.count == 0 {
                            self.status = .notFound
                            self.studentList = student
                            self.tableView.reloadData()
                        } else {
                            self.status = .loadGroup
                            self.studentList = student
                            self.tableView.reloadData()
                        }
                    }
                }
            }
        }
    }
    
    
    //MARK: -  поиск по ФИО
    private func searchStudent(fio: String) {
        status = .loading
        tableView.reloadData()
        SearchStudentHttpService.searchStudent(fio: fio) { (error, result) in
            if error != nil {
                DispatchQueue.main.async {
                    self.showErrorView()
                }
            } else {
                DispatchQueue.main.async {
                    if let student = result {
                        if student.count == 0 {
                            self.status = .notFound
                            self.activStudent = student.filter { (student) -> Bool in
                                student.status == "учащийся"
                            }
                            self.oldStudent = student.filter { (student) -> Bool in
                                student.status == "выпускник"
                            }
                            self.tableView.reloadData()
                        } else {
                            self.status = .loadStud
                            self.activStudent = student.filter { (student) -> Bool in
                                student.status == "учащийся"
                            }
                            self.oldStudent = student.filter { (student) -> Bool in
                                student.status == "выпускник"
                            }
                            self.tableView.reloadData()
                        }
                    }
                }
            }
        }
    }
}


// MARK: - Table view data source
extension SearchStudentsTableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        switch status {
        case .loadStud:
            return 2
        default:
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch status {
        case .wait:
            return 0
        case .loading:
            return 1
        case .loadGroup:
            return studentList.count
        case .loadStud:
            if section == 0 {
                return activStudent.count
            } else {
                return oldStudent.count
            }
        case .notFound:
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch status {
        case .loading:
            let cell = tableView.dequeueReusableCell(withIdentifier: "loadStud", for: indexPath)
            return cell
        case .loadGroup:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "studentCell", for: indexPath) as? SudentInGroupTableViewCell else { return UITableViewCell() }
            cell.student = studentList[indexPath.row]
            return cell
        case .loadStud:
            if indexPath.section == 0 {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "studentSearchCell", for: indexPath) as? StudInSearchTableViewCell else { return UITableViewCell() }
                cell.student = activStudent[indexPath.row]
                return cell
            } else {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "studentSearchCell", for: indexPath) as? StudInSearchTableViewCell else { return UITableViewCell() }
                cell.student = oldStudent[indexPath.row]
                return cell
            }
        case .notFound:
            let cell = tableView.dequeueReusableCell(withIdentifier: "notFoundStud", for: indexPath)
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "notFoundStud", for: indexPath)
            return cell
        }
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if status == .loadStud {
            return 80
        } else {
            return 70
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        switch status {
        case .loadGroup:
            if studentList.count > 0 {
                return "Результат поиска"
            } else {
                return nil
            }
        case .loadStud:
            switch section {
            case 0:
                if activStudent.count > 0 {
                    return "Результат поиска"
                } else {
                    return nil
                }
            case 1:
                if oldStudent.count > 0 {
                    return "Выпускники"
                } else {
                    return nil
                }
            default:
                return nil
            }
            
        default:
            return nil
            
        }
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == tableView {
            searchController.searchBar.endEditing(true)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if status == .loadGroup {
            let sb = UIStoryboard(name: "Teacher", bundle: nil)
            guard let vc = sb.instantiateViewController(withIdentifier: "studentInfo") as? StudentInfoTableViewController else { return }
            vc.studentInfo = studentList[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
        }
        if status == .loadStud {
            let sb = UIStoryboard(name: "Teacher", bundle: nil)
            guard let vc = sb.instantiateViewController(withIdentifier: "studentInfo") as? StudentInfoTableViewController else { return }
            if indexPath.section == 0 {
                vc.studentInfo = activStudent[indexPath.row]
            } else {
                vc.studentInfo = oldStudent[indexPath.row]
            }
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}

extension SearchStudentsTableViewController: UISearchControllerDelegate, UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchStr = searchController.searchBar.text else { return }
        if searchStr.count > 2 {
            if isSearchGroup {
                searchGroup(group: searchStr)
            } else {
                searchStudent(fio: searchStr)
            }
        } else {
            status = .wait
        }
    }
    
}
