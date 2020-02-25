//
//  RaspisanieGroupInfo.swift
//  Bazis MADI
//
//  Created by Всеволод Андрющенко on 24.02.2020.
//  Copyright © 2020 Всеволод Андрющенко. All rights reserved.
//

import Foundation

class RaspisanieGroupInfo {
    
     var dayTitle: String
     var classesData: [DailyRaspisanie]
     
     init(dayTitle: String, classesData:[DailyRaspisanie]) {
         self.dayTitle = dayTitle
         self.classesData = classesData
     }
     
     class func getDayliClasses(raspisanie: RaspisanieModel?) ->[RaspisanieGroupInfo] {
         var raspisanieByDay: [RaspisanieGroupInfo] = []
         
         if let raspisanieData = raspisanie {
             if let monday = raspisanieData.result?.monday {
                 let classes = RaspisanieGroupInfo(dayTitle: "Понедельник", classesData: monday )
                 raspisanieByDay.append(classes)
             }
             if let tuesday = raspisanieData.result?.tuesday {
                 let classes = RaspisanieGroupInfo(dayTitle: "Вторник", classesData: tuesday )
                                raspisanieByDay.append(classes)
             }
             if let wednesday = raspisanieData.result?.wednesday {
                 let classes = RaspisanieGroupInfo(dayTitle: "Среда", classesData: wednesday )
                                raspisanieByDay.append(classes)
             }
             if let thursday = raspisanieData.result?.thursday {
                 let classes = RaspisanieGroupInfo(dayTitle: "Четверг", classesData: thursday )
                                raspisanieByDay.append(classes)
             }
             if let friday = raspisanieData.result?.friday {
                 let classes = RaspisanieGroupInfo(dayTitle: "Пятница", classesData: friday )
                                raspisanieByDay.append(classes)
             }
             if let saturday = raspisanieData.result?.saturday {
                 let classes = RaspisanieGroupInfo(dayTitle: "Суббота", classesData: saturday )
                                raspisanieByDay.append(classes)
             }
             return raspisanieByDay
         } else {
             return raspisanieByDay
         }
     }
}
