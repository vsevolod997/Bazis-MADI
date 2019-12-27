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
            result = dayRasp.filter( {$0.typeWeek == "Числитель"})
        } else {
            result = dayRasp.filter( {$0.typeWeek == "Знаменатель"})
        }
        return result
    }
}
