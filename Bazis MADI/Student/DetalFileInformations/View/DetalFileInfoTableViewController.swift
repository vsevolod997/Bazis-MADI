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
    @IBOutlet weak var typeInfoSegmentControl: UISegmentedControl!
    @IBOutlet weak var fileImage: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var deliteButton: CancelButtonUIButton!
    @IBOutlet weak var saveButton: DoneButtonUIButton!
    @IBOutlet weak var saveDescButton: DoneButtonUIButton!
    @IBOutlet weak var textField: InfoTextViewUITextView!
    @IBOutlet weak var cancelButton: InputButton1UIButton!
    
    public var fileData: FileToShowModel!
    
    private var fileDesc: String!
    private var fileRef: String!
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setData()
        
        setupView()
    }
    
    fileprivate func setupView() {
        typeInfoSegmentControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: SystemColor.whiteColor], for: UIControl.State.selected)
        typeInfoSegmentControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: SystemColor.grayColor], for: UIControl.State.normal)
    }
    
    private func setData() {
        
        if let file = fileData {
            fileNameLabel.text = file.name
            fileImage.image = file.typeIMG
            dateLabel.text = file.date
            loadDescFile(fileName: file.name)
            
        }
    }
    
    private func loadDescFile(fileName: String) {
        DetailFileHttpService.getFileDesc(nameFile: fileName) { (err, descModel) in
            if err != nil {
                DispatchQueue.main.async {
                    self.fileDesc = "Не удалось загрузить данные"
                }
            } else {
                if let desc = descModel {
                    DispatchQueue.main.async {
                        self.fileDesc = desc.desc
                        self.textField.text = desc.desc
                    }
                }
            }
        }
    }
    
    @IBAction func selectTypeInfo(_ sender: Any) {
        
    }
    
    @IBAction func saveButtonPress(_ sender: Any) {
        print("Save")
    }
    
    @IBAction func deleteButtonPress(_ sender: Any) {
        print("Load")
    }
    
    @IBAction func saveDescButtonPress(_ sender: Any) {
        
    }
    
    @IBAction func cancelButtonPress(_ sender: Any) {
        
    }
}
