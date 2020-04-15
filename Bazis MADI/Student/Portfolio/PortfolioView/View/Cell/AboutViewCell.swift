//
//  AboutViewCell.swift
//  Bazis MADI
//
//  Created by Всеволод Андрющенко on 03.03.2020.
//  Copyright © 2020 Всеволод Андрющенко. All rights reserved.
//

import UIKit

class AboutViewCell: UITableViewCell {

    @IBOutlet weak var aboutText: UITextView!
    
    public var about: String! {
        didSet {
            if about == "" {
                aboutText.text = "не установлено"
            }else {
                aboutText.text = about
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
