//
//  PortfolioInfoEditTableViewController.swift
//  Bazis MADI
//
//  Created by Всеволод Андрющенко on 15.03.2020.
//  Copyright © 2020 Всеволод Андрющенко. All rights reserved.
//

import UIKit
//MARK: - окно изменеия общей информации
class PortfolioInfoEditTableViewController: UITableViewController {
    
    public var saveCloser: ((PortfolioModel?) -> ())?
    
    @IBOutlet weak var saveButton: DoneButtonUIButton!
    
    @IBOutlet weak var postField: UITextField!
    @IBOutlet weak var infoAbout: UITextView!
    @IBOutlet weak var payField: UITextField!
    
    public var allInformation: PortfolioModel!
    private var changedInformation: PortfolioModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        saveButton.isEnabled = false
        setUserDate()
        addGestue()
    }
    
    //MARK: - установка данных
    private func setUserDate() {
        if let allInfo = allInformation {
            postField.text = allInfo.wpost
            infoAbout.text = allInfo.ldata
            payField.text = allInfo.wprice
        }
    }
    
    
    //MARK:- считывание новых данных
    private func getUserData() -> PortfolioModel? {
        var  buffModel = allInformation
        
        let post = postField.text
        buffModel?.wpost = post
        
        let info = infoAbout.text
        buffModel?.ldata = info
        
        let price = payField.text
        buffModel?.wprice = price
        
        return buffModel
    }
    
    private func addGestue() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapGestue(_:)))
        view.addGestureRecognizer(tap)
    }
    
    @objc func tapGestue(_ gestue: UIGestureRecognizer) {
        view.endEditing(true)
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
    
    
    //MARK: - сравнение данных пользовтаеля с получанной версией
    private func controlChangedData() -> Bool {
        changedInformation = getUserData()
        
        if allInformation != changedInformation {
            return true
        } else {
            return false
        }
    }
    
    
    //MARK: -  доступность кнпки сохранения
    private func controlSaveButtonEnabled() {
        
        if controlChangedData() {
            saveButton.isEnabled = true
        } else {
            saveButton.isEnabled = false
        }
    }
    
    @IBAction func saveButtonPress(_ sender: Any) {
        saveCloser?(changedInformation)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelButtonPress(_ sender: Any) {
        
        if controlChangedData() {
            showExitAlert()
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
    
}

//MARK: - UITextFieldDelegate
extension PortfolioInfoEditTableViewController: UITextFieldDelegate {
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
         controlSaveButtonEnabled()
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
    }
}

extension PortfolioInfoEditTableViewController: UITextViewDelegate {
    func textViewDidChangeSelection(_ textView: UITextView) {
        controlSaveButtonEnabled()
    }
}
