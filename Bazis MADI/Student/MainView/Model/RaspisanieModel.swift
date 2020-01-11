//
//  File.swift
//  Bazis MADI
//
//  Created by Всеволод Андрющенко on 11.12.2019.
//  Copyright © 2019 Всеволод Андрющенко. All rights reserved.
//

import Foundation

struct RaspisanieModel: Decodable {
    var status: Bool
    var date: String
    var typeWeek: String
    var result: WeakRaspisanie?
    var error: String?
}

struct WeakRaspisanie: Decodable {
    var monday: [DailyRaspisanie]
    var tuesday: [DailyRaspisanie]
    var wednesday: [DailyRaspisanie]
    var thursday: [DailyRaspisanie]
    var friday: [DailyRaspisanie]
    var saturday: [DailyRaspisanie]
}

struct DailyRaspisanie: Decodable {
    var time: String?
    var name: String
    var typeLesson: String?
    var typeWeek: String
    var room: String?
    var teacher: String?
}
