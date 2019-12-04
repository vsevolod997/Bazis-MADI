//
//  ErrorLabel.swift
//  Bazis MADI
//
//  Created by Всеволод Андрющенко on 01.12.2019.
//  Copyright © 2019 Всеволод Андрющенко. All rights reserved.
//

import UIKit

class ErrorLabel: UILabel {

    override init(frame: CGRect) {
           super.init(frame: frame)
           setup()
       }
       
       
    required init?(coder: NSCoder) {
           super.init(coder: coder)
           setup()
       }
       
    fileprivate func setup(){
           font = UIFont(name: "HelveticaNeue", size: 24)
           textColor = UIColor(#colorLiteral(red: 0.8422405124, green: 0.06856621057, blue: 0.08924295753, alpha: 1))
       }
    
    
}
