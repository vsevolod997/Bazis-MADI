//
//  FileTableViewCell.swift
//  Bazis MADI
//
//  Created by Всеволод Андрющенко on 20.03.2020.
//  Copyright © 2020 Всеволод Андрющенко. All rights reserved.
//

import UIKit

class FileTableViewCell: UITableViewCell {
    
    @IBOutlet weak var TypeImage: UIImageView!
    @IBOutlet weak var NameLabel: Title5LabelUILabel!
    @IBOutlet weak var dateLabel: Title2LabelUILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
