//
//  PortfolioEducationTableViewController.swift
//  Bazis MADI
//
//  Created by Всеволод Андрющенко on 14.03.2020.
//  Copyright © 2020 Всеволод Андрющенко. All rights reserved.
//

import UIKit
//MARK: - окно изменения данных о образовании
class PortfolioEducationTableViewController: UITableViewController {
    
    public var saveCloser: (([String?]) -> ())?
    public var deleteCloser: (() ->())?
    
    @IBOutlet weak var dateStartField: UITextField!
    @IBOutlet weak var dateEndField: UITextField!
    @IBOutlet weak var placeField: UITextField!
    @IBOutlet weak var specializationField: UITextField!
    @IBOutlet weak var printSwitch: UISwitch!
    @IBOutlet weak var saveButton: DoneButtonUIButton!
    
    @IBOutlet weak var levlButton: UIButton!
    
    var dataEduc: [String?]!
    
    private var newDataEduc: [String?]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUserDate()
        addGestue()
        
        saveButton.isEnabled = false
    }
    
    //MARK: - установка данных
    private func setUserDate() {
        
        if let educ = dataEduc {
            
            if let startData = educ[0] {
                dateStartField.text = startData
            }
            if let endData = educ[1] {
                dateEndField.text = endData
            }
            if let place = educ[2] {
                placeField.text = place
            }
            if let level = educ[3] {
                levlButton.setTitle(level, for: .normal)
            }
            if let spec = educ[4] {
                specializationField.text = spec
            }
            
            if let isPrint = educ[5] {
                if isPrint == "да" {
                    printSwitch.isOn = true
                } else {
                    printSwitch.isOn = false
                    dataEduc[5] = "нет"
                }
            } else {
                printSwitch.isOn = false
                dataEduc[5] = "нет"
            }
        }
    }
    
    
    //MARK:- считывание новых данных
    private func getUserData() -> [String?] {
        
        var localUserEducData: [String?] = []
        
        let startData = dateStartField.text
        localUserEducData.append(startData)
        
        let endData = dateEndField.text
        localUserEducData.append(endData)
        
        let place = placeField.text
        localUserEducData.append(place)
        
        let level = levlButton.title(for: .normal)
        localUserEducData.append(level)
        
        let spec = specializationField.text
        localUserEducData.append(spec)
        
        if printSwitch.isOn {
            localUserEducData.append("да")
        } else {
            localUserEducData.append("нет")
        }
        
        return localUserEducData
    }
    
    private func addGestue() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapGestue(_:)))
        view.addGestureRecognizer(tap)
    }
    
    @objc func tapGestue(_ gestue: UIGestureRecognizer) {
        view.endEditing(true)
    }
    
    
    //MARK: -  доступность кнпки сохранения
    private func controlSaveButtonEnabled() {
        if controlChangedData() {
            saveButton.isEnabled = true
        } else {
            saveButton.isEnabled = false
        }
    }
    
    //MARK: - сравнение данных пользовтаеля с получанной версией
    private func controlChangedData() -> Bool {
        newDataEduc = getUserData()
        print(newDataEduc == dataEduc)
        if newDataEduc != dataEduc {
            return true
        } else {
            return false
        }
    }
    
    @IBAction func saveButtonPress(_ sender: Any) {
        saveCloser?(newDataEduc)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func deleteButtonPress(_ sender: Any) {
        showDeleteAlert()
    }
    
    @IBAction func cancelButtonPress(_ sender: Any) {
        
        if controlChangedData() {
            showExitAlert()
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func printSwitchSelection(_ sender: Any) {
        controlSaveButtonEnabled()
    }
    
    @IBAction func levelButtonPress(_ sender: Any) {
        changeLevleEducationValue()
        controlSaveButtonEnabled()
    }
    
    private func showDeleteAlert() {
        let alert = UIAlertController(title: "Удаление", message: "Вы уверенны, что хотите удалить данные о обучении?", preferredStyle: .alert)
        let deleteAction = UIAlertAction(title: "Удалить", style: .destructive) { (action) in
            self.deleteCloser?()
            self.dismiss(animated: true, completion: nil)
        }
        alert.addAction(deleteAction)
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    private func showExitAlert() {
        let alert = UIAlertController(title: "Внимание!", message: "Присутствуют не сохраненные изменения, Вы уверенны что хотите выйти?", preferredStyle: .alert)
        let exitAction = UIAlertAction(title: "Выход", style: .destructive) { (action) in
            self.dismiss(animated: true, completion: nil)
        }
        alert.addAction(exitAction)
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    private func changeLevleEducationValue() {
        
        let action = UIAlertController(title: "Уровень образования" , message: nil, preferredStyle: .actionSheet)
        let actionBac = UIAlertAction(title: "Бакалавриат", style: .default) { (_) in
            self.levlButton.setTitle("Бакалавриат", for: .normal)
        }
        action.addAction(actionBac)
        
        let actionMag = UIAlertAction(title: "Магистратура", style: .default) { (_) in
            self.levlButton.setTitle("Магистратура", for: .normal)
        }
        action.addAction(actionMag)
        
        let actionSpec = UIAlertAction(title: "Специалитет", style: .default) { (_) in
            self.levlButton.setTitle("Специалитет", for: .normal)
        }
        action.addAction(actionSpec)
        
        let actionAsp = UIAlertAction(title: "Аспирантура", style: .default) { (_) in
            self.levlButton.setTitle("Аспирантура", for: .normal)
        }
        action.addAction(actionAsp)
        
        if let popoverController = action.popoverPresentationController {
            popoverController.sourceView = levlButton
        }
        present(action, animated: true)
        
    }
}

//MARK: - UITextFieldDelegate
extension PortfolioEducationTableViewController:  UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        controlSaveButtonEnabled()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
}




