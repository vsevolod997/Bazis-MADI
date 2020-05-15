//
//  SelectReviewFIleTableViewCell.swift
//  Bazis MADI
//
//  Created by Всеволод Андрющенко on 05.05.2020.
//  Copyright © 2020 Всеволод Андрющенко. All rights reserved.
//

import UIKit

class SelectReviewFileTableViewCell: UITableViewCell {
    
    @IBOutlet weak var TypeImage: UIImageView!
    @IBOutlet weak var NameLabel: Title5LabelUILabel!
    @IBOutlet weak var PathLabel: UILabel!
    @IBOutlet weak var selectFileIndicatorView: SelectionUIView!
    
    var fileData: FileToShowModel! {
        didSet {
            TypeImage.image = fileData.typeIMG
            NameLabel.text = fileData.name
            PathLabel.text = fileData.path
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            selectFileIndicatorView.selectStyle()
        } else {
            selectFileIndicatorView.deSelectStyle()
        }
    }
}
