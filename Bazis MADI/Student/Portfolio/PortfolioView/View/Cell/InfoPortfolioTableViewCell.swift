//
//  InfoPortfolioTableViewCell.swift
//  Bazis MADI
//
//  Created by Всеволод Андрющенко on 03.03.2020.
//  Copyright © 2020 Всеволод Андрющенко. All rights reserved.
//

import UIKit

class InfoPortfolioTableViewCell: UITableViewCell {

    @IBOutlet weak var dolzLabel: Title2LabelUILabel!
    
    @IBOutlet weak var zpLabel: Title2LabelUILabel!
    
    public var portfolioData: PortfolioModel! {
        didSet {
            if portfolioData.wpost == "" {
                dolzLabel.text = "не определено"
            } else {
                dolzLabel.text = portfolioData.wpost
            }
            
            if portfolioData.wprice == "" {
                zpLabel.text = "не определено"
            } else {
                zpLabel.text = portfolioData.wprice
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
