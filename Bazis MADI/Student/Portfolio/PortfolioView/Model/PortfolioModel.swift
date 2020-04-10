//
//  PortfolioModel.swift
//  Bazis MADI
//
//  Created by Всеволод Андрющенко on 03.03.2020.
//  Copyright © 2020 Всеволод Андрющенко. All rights reserved.
//

import Foundation

struct PortfolioModel: Decodable, Equatable, Encodable {
    
    var ldata: String?
    var wpost: String? // zp
    var wprice: String?
    var educ: [[String?]]
    var work: [[String?]]
}

struct PortfolioToSent: Codable {
    var save = "1"
    var ldata: String?
    var wpost: String?
    var wprice: String?
    var educ: [Educ]
    var work: [Work]
    
}

struct Educ: Codable {
    var beg: String?
    var end: String?
    var vuz: String?
    var level: String?
    var spec: String?
    var prn: String?
}

struct Work: Codable {
    var beg: String?
    var end: String?
    var post: String?
    var firm: String?
    var napr: String?
    var town: String?
    var prn: String?
}

