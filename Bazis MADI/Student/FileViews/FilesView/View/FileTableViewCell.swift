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
    @IBOutlet weak var DateLabel: Title2LabelUILabel!
    @IBOutlet weak var SizeLabel: UILabel!
    @IBOutlet weak var PathLabel: UILabel!
    
    var fileData: FileToShowModel! {
        didSet {
            TypeImage.image = fileData.typeIMG
            NameLabel.text = fileData.name
            DateLabel.text = fileData.date
            PathLabel.text = fileData.path
            SizeLabel.text = String(fileData.size) + " Кб."
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
