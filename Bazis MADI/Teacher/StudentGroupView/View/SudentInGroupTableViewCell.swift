//
//  SudentInGroupTableViewCell.swift
//  Bazis MADI
//
//  Created by Всеволод Андрющенко on 10.04.2020.
//  Copyright © 2020 Всеволод Андрющенко. All rights reserved.
//

import UIKit

class SudentInGroupTableViewCell: UITableViewCell {

    @IBOutlet weak var icoLabel: UserIcoUILabel!
    @IBOutlet weak var nameLabel: Title5LabelUILabel!
    
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
        nameLabel.text = stud.name
        
        let buff = stud.name.split(separator: " ")
        icoLabel.text = String(buff[0].first!) + String(buff[1].first!)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
