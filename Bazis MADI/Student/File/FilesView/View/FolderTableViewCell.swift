//
//  FolderTableViewCell.swift
//  Bazis MADI
//
//  Created by Всеволод Андрющенко on 19.03.2020.
//  Copyright © 2020 Всеволод Андрющенко. All rights reserved.
//

import UIKit

class FolderTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: Title5LabelUILabel!
    @IBOutlet weak var countLabel: Title3LabelUILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
