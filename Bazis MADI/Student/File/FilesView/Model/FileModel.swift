//
//  FileModel.swift
//  Bazis MADI
//
//  Created by Всеволод Андрющенко on 19.03.2020.
//  Copyright © 2020 Всеволод Андрющенко. All rights reserved.
//

import Foundation

struct FileModel: Codable {
    var file: String
    var path: String?
    var time: String
    var size: Int
}

