//
//  UserTitleUILabel.swift
//  Bazis MADI
//
//  Created by Всеволод Андрющенко on 11.01.2020.
//  Copyright © 2020 Всеволод Андрющенко. All rights reserved.
//

import UIKit

class UserTitleUILabel: UILabel {

   override init(frame: CGRect) {
         super.init(frame: frame)
         setup()
     }
     
     required init?(coder: NSCoder) {
         super.init(coder: coder)
         setup()
     }
     
    fileprivate func setup() {
        font = .boldSystemFont(ofSize: 36)
        textColor = SystemColor.whiteColor
        backgroundColor = SystemColor.blueColor
        textAlignment = .center
        layer.masksToBounds = true
        
        layer.cornerRadius = 10
    }

}
