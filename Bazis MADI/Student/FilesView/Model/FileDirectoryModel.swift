//
//  FileDirectoryModel.swift
//  Bazis MADI
//
//  Created by Всеволод Андрющенко on 23.03.2020.
//  Copyright © 2020 Всеволод Андрющенко. All rights reserved.
//

import Foundation

struct FileDirectoryModel: Codable {
    var path: String
    var files: [FileModel]?
}

