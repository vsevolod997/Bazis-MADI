//
//  PortfolioModel.swift
//  Bazis MADI
//
//  Created by Всеволод Андрющенко on 03.03.2020.
//  Copyright © 2020 Всеволод Андрющенко. All rights reserved.
//

import Foundation

struct PortfolioModel: Decodable {
    var ldata: String?
    var wpost: String? // zp
    var wprice: String?
    var educ: [[String?]]
    var work: [[String?]]
}
