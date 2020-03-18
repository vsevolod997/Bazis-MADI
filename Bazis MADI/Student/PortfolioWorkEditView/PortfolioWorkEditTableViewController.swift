//
//  PortfolioWorkEditTableViewController.swift
//  Bazis MADI
//
//  Created by Всеволод Андрющенко on 12.03.2020.
//  Copyright © 2020 Всеволод Андрющенко. All rights reserved.
//

import UIKit

// MARK: - контроллер модального окна для редактирования или создании нового места работы
class PortfolioWorkEditTableViewController: UITableViewController {
    
    public var saveCloser: (([String?]) -> ())?
    public var deleteCloser: (() ->())?
    
    @IBOutlet weak var saveButton: DoneButtonUIButton!
    @IBOutlet weak var dateStartField: UITextField!
    @IBOutlet weak var dateEndField: UITextField!
    @IBOutlet weak var postField: UITextField!
    @IBOutlet weak var organizationField: UITextField!
    @IBOutlet weak var typeField: UITextField!
    @IBOutlet weak var cityField: UITextField!
    @IBOutlet weak var printSwitch: UISwitch!
    
    private var endDatePicker = UIDatePicker()
    private var startDatePicker = UIDatePicker()
    
    var dataWork: [String?]!
    
    private var newDataWork: [String?] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUserDate()
        setupStartPicker()
        setupEndPicker()
        addGestue()
        
        saveButton.isEnabled = false
    }
    
    
    //MARK: - установка данных
    private func setUserDate() {
        
        if let dataWork = dataWork {
            if let startData = dataWork[0] {
                dateStartField.text = startData
            }
            if let endData = dataWork[1] {
                dateEndField.text = endData
            }
            if let post = dataWork[2] {
                postField.text = post
            }
            if let organization = dataWork[3] {
                organizationField.text = organization
            }
            if let type = dataWork[4] {
                typeField.text = type
            }
            if let city = dataWork[5] {
                cityField.text = city
            }
            
            if let isPrint = dataWork[6] {
                if isPrint == "да" {
                    printSwitch.isOn = true
                } else {
                    printSwitch.isOn = false
                    self.dataWork[6] = "нет"
                }
            } else {
                printSwitch.isOn = false
                self.dataWork[6] = "нет"
            }
        }
    }
    
    
    //MARK:- считывание новых данных
    private func getUserData() -> [String?] {
        
        var localUserWorkData: [String?] = []
        
        let startData = dateStartField.text
        localUserWorkData.append(startData)
        
        let endData = dateEndField.text
        localUserWorkData.append(endData)
        
        let post = postField.text
        localUserWorkData.append(post)
        
        let organization = organizationField.text
        localUserWorkData.append(organization)
        
        let type = typeField.text
        localUserWorkData.append(type)
        
        let city = cityField.text
        localUserWorkData.append(city)
        
        if printSwitch.isOn {
            localUserWorkData.append("да")
        } else {
            localUserWorkData.append("нет")
        }
        
        return localUserWorkData
    }
    
    
    // стартовая дата
    private func setupStartPicker() {
        
        
        let locale = Locale.preferredLanguages.first
        startDatePicker.locale = Locale(identifier: locale!)
        startDatePicker.datePickerMode = .date
        
        let formated = DateFormatter()
        formated.dateFormat = "dd.MM.yyyy"
        
        if let date = dateStartField.text {
            guard let pickerDate = formated.date(from: date) else { return }
            startDatePicker.date = pickerDate
        }
       
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done , target: self, action: #selector(selectStartDate(_:)))
        let spacer = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        toolBar.setItems([doneButton, spacer], animated: true)
        dateStartField.inputView = startDatePicker
        dateStartField.inputAccessoryView = toolBar
    }
    
    // окончания
    private func setupEndPicker() {
        let locale = Locale.preferredLanguages.first
        endDatePicker.locale = Locale(identifier: locale!)
        endDatePicker.datePickerMode = .date
        
        let formated = DateFormatter()
        formated.dateFormat = "dd.MM.yyyy"
        
        if let date = dateEndField.text {
            guard let pickerDate = formated.date(from: date) else { return }
            endDatePicker.date = pickerDate
        }
        
        let toolBar = UIToolbar()
        toolBar.isTranslucent = true
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done , target: self, action: #selector(selectEndDate(_:)) )
        let spacer = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        toolBar.setItems([doneButton, spacer], animated: true)
        
        dateEndField.inputView = endDatePicker
        dateEndField.inputAccessoryView = toolBar
    }
    
    private func addGestue() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapGestue(_:)))
        view.addGestureRecognizer(tap)
    }
    
    @objc func tapGestue(_ gestue: UIGestureRecognizer) {
        view.endEditing(true)
    }
    
    @objc func selectEndDate(_ sender: UIDatePicker) {
        let formated = DateFormatter()
        formated.dateFormat = "dd.MM.yyyy"
        dateEndField.text = formated.string(from: endDatePicker.date)
        view.endEditing(true)
        
        controlSaveButtonEnabled()
    }
    
    @objc func selectStartDate(_ sender: UIDatePicker) {
        let formated = DateFormatter()
        formated.dateFormat = "dd.MM.yyyy"
        dateStartField.text = formated.string(from: startDatePicker.date)
        view.endEditing(true)
        
        controlSaveButtonEnabled()
    }
    
    //MARK: -  доступность кнпки сохранения
    private func controlSaveButtonEnabled() {
        //print(controlChangedData())
        if controlChangedData() {
            saveButton.isEnabled = true
        } else {
            saveButton.isEnabled = false
        }
    }
    
    //MARK: - сравнение данных пользовтаеля с получанной версией
    private func controlChangedData() -> Bool {
        newDataWork = getUserData()
        
        if newDataWork != dataWork {
            return true
        } else {
            return false
        }
    }
    
    @IBAction func saveButtonPress(_ sender: Any) {
        saveCloser?(newDataWork)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelButtonPress(_ sender: Any) {
        if !controlChangedData() {
            showExitAlert()
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func printSwitcherChanged(_ sender: Any) {
        controlSaveButtonEnabled()
    }
    
    @IBAction func DeleteButtonPress(_ sender: Any) {
        showDeleteAlert()
    }
    
    private func showDeleteAlert() {
        let alert = UIAlertController(title: "Удаление", message: "Вы уверенны, что хотите удалить данные о работе?", preferredStyle: .alert)
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
}
//MARK: - UITextFieldDelegate
extension PortfolioWorkEditTableViewController:  UITextFieldDelegate {
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        controlSaveButtonEnabled()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
}
