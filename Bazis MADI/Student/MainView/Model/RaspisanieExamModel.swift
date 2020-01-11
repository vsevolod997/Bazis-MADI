//
//  RaspisanieExamModel.swift
//  Bazis MADI
//
//  Created by Всеволод Андрющенко on 08.01.2020.
//  Copyright © 2020 Всеволод Андрющенко. All rights reserved.
//

import Foundation

struct RaspisanieExamModel: Decodable {
    var status: Bool
    var date: String
    var typeWeek: String
    var result:[Exam]?
    var error: String?
}

struct Exam: Decodable {
    var name: String
    var time: String
    var room: String
    var teacher: String?
}
