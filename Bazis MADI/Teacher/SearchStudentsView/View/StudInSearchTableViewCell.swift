//
//  StudInSearchTableViewCell.swift
//  Bazis MADI
//
//  Created by Всеволод Андрющенко on 24.04.2020.
//  Copyright © 2020 Всеволод Андрющенко. All rights reserved.
//

import UIKit

class StudInSearchTableViewCell: UITableViewCell {
    
    @IBOutlet weak var groupLabel: Title7LabelUILabel!
    @IBOutlet weak var icoLabel: UserIcoUILabel!
    @IBOutlet weak var fullNameLabel: Title5LabelUILabel!
    
    public var student: StudentModel! {
        didSet {
            setup()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    private func setup() {
        guard let stud = student else { return }
        fullNameLabel.text = stud.name
        
        let buff = stud.name.split(separator: " ")
        icoLabel.text = String(buff[0].first!) + String(buff[1].first!)
        
        groupLabel.text = stud.group
    }
}
