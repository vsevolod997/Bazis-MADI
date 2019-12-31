//
//  WeakRaspisanieController.swift
//  Bazis MADI
//
//  Created by Всеволод Андрющенко on 23.12.2019.
//  Copyright © 2019 Всеволод Андрющенко. All rights reserved.
//

import Foundation

class WeakRaspisanieController {
    
    public func getOnlyChangedDayType (dayRasp: [DailyRaspisanie], typeWeak: Bool) -> [DailyRaspisanie]? {
        
        var result:[DailyRaspisanie]
        
        if typeWeak {
            result = dayRasp.filter( {$0.typeWeek == "Числитель" || $0.typeWeek == "Еженедельно"})
        } else {
            result = dayRasp.filter( {$0.typeWeek == "Знаменатель" || $0.typeWeek == "Еженедельно"})
        }
        return result
    }
    
    public func getToday() -> Int {
        let date = Date()
        let calendar = Calendar.current
        var weekday = calendar.component(.weekday, from: date)
        weekday -= 2
        
        if weekday < 0 {
            return 0
        } else {
             return weekday
        }
    }
}
