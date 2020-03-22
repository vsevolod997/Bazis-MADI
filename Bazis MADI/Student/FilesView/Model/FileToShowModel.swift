//
//  FileToShowModel.swift
//  Bazis MADI
//
//  Created by Всеволод Андрющенко on 20.03.2020.
//  Copyright © 2020 Всеволод Андрющенко. All rights reserved.
//

import UIKit

//отображаемые данные
struct FileToShowModel {
    var name: String
    var date: String
    var path: String
    
    let type: TypeFile
    var typeIMG: UIImage
        
    init(nameL: String, date: String, path: String, type: TypeFile, image: UIImage) {
        self.name = nameL
        self.date = date
        self.path = path
        self.type = type
        self.typeIMG = image
    }
}
