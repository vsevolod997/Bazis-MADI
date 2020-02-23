//
//  RaspisanieModelInfoByTeacher.swift
//  Bazis MADI
//
//  Created by Всеволод Андрющенко on 21.02.2020.
//  Copyright © 2020 Всеволод Андрющенко. All rights reserved.
//

import Foundation

class RaspisanieModelInfoByTeacher {
    
    var dayTitle: String
    var classesData: [DailyRaspisanieTeacher]
    
    init(dayTitle: String, classesData:[DailyRaspisanieTeacher]) {
        self.dayTitle = dayTitle
        self.classesData = classesData
    }
    
    class func getDayliClasses(raspisanie: RaspisanieModelTeacher?) ->[RaspisanieModelInfoByTeacher] {
        var raspisanieByDay: [RaspisanieModelInfoByTeacher] = []
        
        if let raspisanieData = raspisanie {
            if let monday = raspisanieData.result?.monday {
                let classes = RaspisanieModelInfoByTeacher(dayTitle: "Понедельник", classesData: monday )
                raspisanieByDay.append(classes)
            }
            if let tuesday = raspisanieData.result?.tuesday {
                let classes = RaspisanieModelInfoByTeacher(dayTitle: "Вторник", classesData: tuesday )
                               raspisanieByDay.append(classes)
            }
            if let wednesday = raspisanieData.result?.wednesday {
                let classes = RaspisanieModelInfoByTeacher(dayTitle: "Среда", classesData: wednesday )
                               raspisanieByDay.append(classes)
            }
            if let thursday = raspisanieData.result?.thursday {
                let classes = RaspisanieModelInfoByTeacher(dayTitle: "Четверг", classesData: thursday )
                               raspisanieByDay.append(classes)
            }
            if let friday = raspisanieData.result?.friday {
                let classes = RaspisanieModelInfoByTeacher(dayTitle: "Пятница", classesData: friday )
                               raspisanieByDay.append(classes)
            }
            if let saturday = raspisanieData.result?.saturday {
                let classes = RaspisanieModelInfoByTeacher(dayTitle: "Суббота", classesData: saturday )
                               raspisanieByDay.append(classes)
            }
            return raspisanieByDay
        } else {
            return raspisanieByDay
        }
    }
}
