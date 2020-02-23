//
//  InfioTableViewCell.swift
//  Bazis MADI
//
//  Created by Всеволод Андрющенко on 18.02.2020.
//  Copyright © 2020 Всеволод Андрющенко. All rights reserved.
//

import UIKit

class InfioTableViewCell: UITableViewCell {

    @IBOutlet weak var fullNameLabel: Title1LabelUILabel!
    @IBOutlet weak var fioLabel: UserTitleUILabel!
    
    var pressButton: (() ->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    var name: String? {
        didSet {
            if let nm = name  {
                fullNameLabel.text = nm
                let buff = nm.split(separator: " ")
                fioLabel.text = String(buff[0].first!) + String(buff[1].first!)
            }
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func sentMessButton(_ sender: Any) {
        pressButton?()
    }
    
}
