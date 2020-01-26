//
//  UspevTableViewController.swift
//  Bazis MADI
//
//  Created by Всеволод Андрющенко on 20.01.2020.
//  Copyright © 2020 Всеволод Андрющенко. All rights reserved.
//

import UIKit

class UspevTableViewController: UITableViewController {
    
    var uspevList:[UspevStructData] = []
    var cellList:[IndexPath] = []
    
    
    var isShow: Bool = true
    
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
                        self.uspevList = UspevStructData.modelToDataSem(uspevModel: uspev)
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
    
    //MARK: - настройка внешнего вида таблицы
    private func setupView() {
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:SystemColor.whiteColor]
        navigationController?.navigationBar.barTintColor = SystemColor.blueColor
        self.title = "Успеваемость"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor:SystemColor.blueColor ]
        
        let leftButton = UIBarButtonItem(title: "Назад", style: .done, target: self, action: #selector(backButtonPress))
        leftButton.tintColor = SystemColor.grayColor
        self.navigationItem.leftBarButtonItem = leftButton
    }
    
    @objc func backButtonPress() {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - нажатие на кнопку развертывания/свертывания секции 
    @objc func sectionsState(_ button: UIButton) {
        
        let generator = UIImpactFeedbackGenerator(style: .rigid)
        generator.impactOccurred()
        
        let section = button.tag
        var indexPath = [IndexPath]()
        
        for row in uspevList[section].dataSem.indices  {
            let iPath = IndexPath(row: row, section: section)
            indexPath.append(iPath)
        }
        
        let isShow = uspevList[section].isShow
        uspevList[section].isShow = !isShow
        
        if isShow {
            tableView.deleteRows(at: indexPath, with: .fade)
            UIView.animate(withDuration: 0.1) {
                button.imageView?.transform = .init(rotationAngle: CGFloat(Double.pi))
            }
        }else {
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
        return uspevList.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if uspevList[section].isShow{
            return uspevList[section].dataSem.count
        } else {
            return 0
        }
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! UspevTableViewCell
        cell.unameLabel.text = uspevList[indexPath.section].dataSem[indexPath.row].disc
        cell.typeLabel.text = uspevList[indexPath.section].dataSem[indexPath.row].vid
        
        if let ocenka = uspevList[indexPath.section].dataSem[indexPath.row].ocenka {
            if ocenka == "+" {
                cell.markLabel.text = "Оценка: " + "Зачтено"
            } else if ocenka == "" {
                cell.markLabel.text = "Оценка: Нет"
            } else {
                cell.markLabel.text = "Оценка: " + ocenka
            }
        } else {
            cell.markLabel.text = "Оценка: Нет"
        }
        
        if let hour = uspevList[indexPath.section].dataSem[indexPath.row].hour {
            if hour == "" {
                cell.hourLabel.text = "Часы: -"
            } else {
                cell.hourLabel.text = "Часы: " + hour
            }
        } else {
            cell.hourLabel.text = "Часы: -"
        }
        
        if let date = uspevList[indexPath.section].dataSem[indexPath.row].date {
            if date == "" {
                cell.dateLabel.text = "Дата: -"
            } else {
                cell.dateLabel.text = "Дата: " + date
            }
        } else {
            cell.dateLabel.text = "Дата: -"
        }
        
        cell.teamLabel.text = uspevList[indexPath.section].dataSem[indexPath.row].tema
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if cellList.contains(indexPath) {
            return 185
        } else {
            return 105
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
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
        titleButton.setTitle( "Семестр №\(section + 1)", for: .normal)
        titleButton.tag = section
        titleButton.imageView?.transform = .init(rotationAngle: CGFloat(Double.pi))
        titleButton.addTarget(self, action: #selector(sectionsState(_:)), for: .touchUpInside)
        
        view.addSubview(titleButton)
        
        return view
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50)
        view.backgroundColor = SystemColor.whiteTextFill
        
        let button = UIButton()
        button.frame = CGRect(x: 0, y: 10, width: self.view.frame.width , height: 50)
        let textColor = SystemColor.blueTextColor
        button.contentVerticalAlignment = .center
        button.contentHorizontalAlignment = .center
        button.setTitleColor(textColor, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 40)
        button.setTitle( ". . .", for: .normal)
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
            guard let cell = tableView.cellForRow(at: indexPath) as? UspevTableViewCell else { return }
            
            cell.showFull(isShow: false)
        } else {
            cellList.append(indexPath)
            tableView.reloadRows(at: [indexPath], with: .fade)
            guard let cell = tableView.cellForRow(at: indexPath) as? UspevTableViewCell else { return }
            
            cell.showFull(isShow: true)
        }
    }
}
