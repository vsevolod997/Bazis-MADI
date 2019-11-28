//
//  Title2LabelUILabel.swift
//  Bazis MADI
//
//  Created by Всеволод Андрющенко on 27.11.2019.
//  Copyright © 2019 Всеволод Андрющенко. All rights reserved.
//

import UIKit

class Title2LabelUILabel: UILabel {

     override init(frame: CGRect) {
           super.init(frame: frame)
           setup()
       }
       
       
       required init?(coder: NSCoder) {
           super.init(coder: coder)
           setup()
       }
       
       fileprivate func setup(){
           font = UIFont(name: "Arial", size: 12)
           textColor = UIColor(#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1))
       }

}
