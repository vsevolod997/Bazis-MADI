//
//  DetalFileInfoTableViewController.swift
//  Bazis MADI
//
//  Created by Всеволод Андрющенко on 25.03.2020.
//  Copyright © 2020 Всеволод Андрющенко. All rights reserved.
//

import UIKit

class DetalFileInfoTableViewController: UITableViewController {
    
    @IBOutlet weak var fileNameLabel: Title6LabelUILabel!
    
    @IBOutlet weak var recCountLabel: CountLabelUILabel!
    @IBOutlet weak var fileImage: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var deliteButton: CancelButtonUIButton!
    
    @IBOutlet weak var saveDescButton: DoneButtonUIButton!
    @IBOutlet weak var textField: InfoTextViewUITextView!
    @IBOutlet weak var cancelButton: InputButton1UIButton!
    @IBOutlet weak var loadFileButton: UIButton!
    
    private var isSave = true
    
    public var indexFile: Int!
    public var fileData: FileToShowModel!
    
    private var fileDesc: DescModel!
    
    private var controller = FileDetalController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        controller.delegate = self
        setData()
        addGestue()
        setupView()
    }
    
    private func addGestue() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapGestue(_:)))
        view.addGestureRecognizer(tap)
    }
    
    @objc func tapGestue(_ gestue: UIGestureRecognizer) {
        view.endEditing(true)
    }
    
    private func setupView() {
        saveDescButton.isEnabled = false
    }
    
    private func setData() {
        if let file = fileData {
            fileNameLabel.text = file.name
            fileImage.image = file.typeIMG
            dateLabel.text = file.date
            controller.loadDesc(fileName: file.name)
        }
    }
    
    @IBAction func saveFileButtonPress(_ sender: Any) {
        print("saveButton")
    }
    
    @IBAction func deleteButtonPress(_ sender: Any) {
        let alert = UIAlertController(title: "Удаление!", message: "Вы уверенны, что хотите удалить \(fileData.name)?", preferredStyle: .alert)
        let deleteAction = UIAlertAction(title: "Удалить", style: .destructive) { (action) in
            self.controller.fileDelete(index: self.indexFile!, nameFile: self.fileData.name)
            self.dismiss(animated: true, completion: nil)
        }
        alert.addAction(deleteAction)
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    @IBAction func saveDescButtonPress(_ sender: Any) {
        guard let file = fileData else { return }
        controller.updateDesc(fileName:file.name, textDesc: textField.text)
    }
    
    @IBAction func cancelButtonPress(_ sender: Any) {
        if !isSave {
            let alert = UIAlertController(title: "Внимание!", message: "Присутствуют не сохраненные изменения, Вы уверенны что хотите выйти?", preferredStyle: .alert)
            let exitAction = UIAlertAction(title: "Выход", style: .destructive) { (action) in
                self.dismiss(animated: true, completion: nil)
            }
            alert.addAction(exitAction)
            let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
            alert.addAction(cancelAction)
            
            present(alert, animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    
    private func controlEnablebSaveButton() {
        if fileDesc.text != textField.text {
            isSave = false
            saveDescButton.isEnabled = true
        } else {
            isSave = true
            saveDescButton.isEnabled = false
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 2 && indexPath.section == 0 && fileDesc.ref.count > 0 {
            //showRefView
        }
        tableView.cellForRow(at: indexPath)?.isSelected = false
    }
}

//MARK: - InfoFileDelegate
extension DetalFileInfoTableViewController: InfoFileDelegate {
    func loadDescFile(fileDesc: DescModel, controller: FileDetalController) {
        self.fileDesc = fileDesc
        self.textField.text = fileDesc.text
        self.recCountLabel.text = String(fileDesc.ref.count)
    }
    
    func setNewDescFile(fileDiscString: String, controller: FileDetalController) {
        self.textField.text = fileDiscString
        self.fileDesc.text = fileDiscString
        dismiss(animated: true, completion: nil)
    }
    
    func showError(errorMess: String, controller: FileDetalController) {
        let alertController = UIAlertController(title: "", message: errorMess, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(alertAction)
        
        present(alertController, animated: true)
    }
}

//MARK: - UITextViewDelegate
extension DetalFileInfoTableViewController: UITextViewDelegate {
    func textViewDidChangeSelection(_ textView: UITextView) {
        controlEnablebSaveButton()
    }
}
