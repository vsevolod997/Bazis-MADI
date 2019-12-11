//
//  File.swift
//  Bazis MADI
//
//  Created by Всеволод Андрющенко on 11.12.2019.
//  Copyright © 2019 Всеволод Андрющенко. All rights reserved.
//

import Foundation


struct Raspisanie: Decodable {
    var date: String
    var typeWeek: String
    var groupname: String
    var monday: [DaylyRaspisanie]
    var tuesday: [DaylyRaspisanie]
    var wednesday: [DaylyRaspisanie]
    var thursday: [DaylyRaspisanie]
    var friday: [DaylyRaspisanie]
    var saturday: [DaylyRaspisanie]
}

struct DaylyRaspisanie: Decodable {
    var time: String?
    var name: String
    var typeLesson: String?
    var typeWeek: String
    var room: String?
    var teacher: String?
}
