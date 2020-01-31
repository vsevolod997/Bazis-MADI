//
//  UspevTableViewController.swift
//  Bazis MADI
//
//  Created by Всеволод Андрющенко on 20.01.2020.
//  Copyright © 2020 Всеволод Андрющенко. All rights reserved.
//

import UIKit

class UspevTableViewController: UITableViewController {
    
    var uspevListByObj:[UspevStructDataByObject] = []
    var uspevListBySem:[UspevStructData] = []
    var cellList:[IndexPath] = []
    
    //просмотр по семестрам или по предметам
    var isSem: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupDataUspev()
    }
    
    //MARK: - получение данных по предметам
    public func setupDataUspev() {
        HttpServiceUspev.getUserUspew() { (err, uspevModel) in
            if let error = err {
                
            } else {
                if let uspev = uspevModel {
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
        tableView.reloadData()
    }
    
    @objc func searchBarButton() {
        print("search")
    }
    
    //MARK: - настройка внешнего вида таблицы
    private func setupView() {
        
        let segmentControl = UISegmentedControl(items: ["Сем.", "Пред."])
        segmentControl.setWidth(100, forSegmentAt: 0)
        segmentControl.setWidth(100, forSegmentAt: 1)
        segmentControl.backgroundColor = SystemColor.whiteTextFill
        segmentControl.selectedSegmentIndex = 0
        segmentControl.selectedSegmentTintColor = SystemColor.blueColor
        segmentControl.addTarget(self, action: #selector(selectSortedType(segment:)), for: .valueChanged)
        
        self.navigationItem.titleView = segmentControl
        self.navigationItem.prompt = "Успеваемость"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:SystemColor.whiteColor]
        navigationController?.navigationBar.barTintColor = SystemColor.blueColor
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor:SystemColor.blueColor]

        let leftButton = UIBarButtonItem(title: "Назад", style: .done, target: self, action: #selector(backButtonPress))
        leftButton.tintColor = SystemColor.whiteColor
        self.navigationItem.leftBarButtonItem = leftButton
    }
    // MARK: - нажатие "назад"
    @objc func backButtonPress() {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - нажатие на кнопку развертывания/свертывания секции 
    @objc func sectionsState(_ button: UIButton) {
        
        let generator = UIImpactFeedbackGenerator(style: .rigid)
        generator.impactOccurred()
        
        let section = button.tag
        var indexPath = [IndexPath]()
        var isShow: Bool
        
        if isSem{
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
        if isSem {
            return uspevListBySem.count
        } else {
            return uspevListByObj.count
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
    
   //override func scrollViewDidScroll(_ scrollView: UIScrollView) {
   //    let offsetSize = UIApplication.shared.windows.filter{$0.isKeyWindow}.first?.safeAreaInsets.top ?? 0
   //    let offset = scrollView.contentOffset.y + offsetSize
   //
   //    self.navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0, -offset))
   //}
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if isSem {
            if cellList.contains(indexPath) {
                return 152
            } else {
                return 105
            }
        } else {
            if cellList.contains(indexPath) {
                return 105
            } else {
                return 55
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
            
            view.addSubview(titleButton)
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
            
            view.addSubview(titleButton)
            return view
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if isSem{
            return 30
        } else {
            return 50
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 50
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
