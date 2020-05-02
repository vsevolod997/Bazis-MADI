//
//  DetailModel.swift
//  Bazis MADI
//
//  Created by Всеволод Андрющенко on 27.03.2020.
//  Copyright © 2020 Всеволод Андрющенко. All rights reserved.
//

import Foundation

class DescModel: Decodable {
    var text: String?
    var ref: [ReviewModel]?
}

class ReviewModel: Decodable {
    var id: String
    var own: String
    var link: String
}
