//
//  WeekRaspisanieTeacher.swift
//  Bazis MADI
//
//  Created by Всеволод Андрющенко on 04.01.2020.
//  Copyright © 2020 Всеволод Андрющенко. All rights reserved.
//

import Foundation

struct RaspisanieModelTeacher: Decodable {
    var status: Bool
    var date: String
    var typeWeek: String
    var result: WeakRaspisanieTeacher?
    var error: String?
}

struct WeakRaspisanieTeacher: Decodable {
    var monday: [DailyRaspisanieTeacher]?
    var tuesday: [DailyRaspisanieTeacher]?
    var wednesday: [DailyRaspisanieTeacher]?
    var thursday: [DailyRaspisanieTeacher]?
    var friday: [DailyRaspisanieTeacher]?
    var saturday: [DailyRaspisanieTeacher]?
}

struct DailyRaspisanieTeacher: Decodable {
    var time: String?
    var name: String
    var typeLesson: String?
    var typeWeek: String
    var room: String?
    var group: String?
}

