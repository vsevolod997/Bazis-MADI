//
//  ReviewTableViewCell.swift
//  Bazis MADI
//
//  Created by Всеволод Андрющенко on 12.05.2020.
//  Copyright © 2020 Всеволод Андрющенко. All rights reserved.
//

import UIKit

class ReviewTableViewCell: UITableViewCell {
    
    public var clouserDownload: (()->())?
    
    public var indexFile: Int!
    
    @IBOutlet weak var reviewNameLabel: Title5LabelUILabel!
    @IBOutlet weak var teacherNameLabel: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    
    @IBOutlet weak var downloadButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    @IBAction func downloadReviewButtonPress(_ sender: Any) {
        clouserDownload?()
    }
    
    public func updateDownloadProgres(loadProgress: Float) {
        progressBar.progress = loadProgress
    }
    
}
