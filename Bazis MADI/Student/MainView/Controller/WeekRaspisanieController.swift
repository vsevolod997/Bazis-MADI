//
//  WeakRaspisanieController.swift
//  Bazis MADI
//
//  Created by Всеволод Андрющенко on 23.12.2019.
//  Copyright © 2019 Всеволод Андрющенко. All rights reserved.
//

import UIKit

//MARK: - текущий тип недели
enum Week: String {
    case next, now
}

class WeekRaspisanieController {
    //MARK: - выборка предметов по типу дня недели
    public func getOnlyChangedDayType (dayRasp: [DailyRaspisanie], typeWeak: Bool) -> [DailyRaspisanie]? {
        var result:[DailyRaspisanie]
        
        if typeWeak {
            result = dayRasp.filter( {$0.typeWeek == "Числитель" || $0.typeWeek == "Еженедельно"})
        } else {
            result = dayRasp.filter( {$0.typeWeek == "Знаменатель" || $0.typeWeek == "Еженедельно"})
        }
        return result
    }
    
    //MARK: - выборка предметов по типу дня недели для препода
    public func getOnlyChangedDayTypeTeacher (dayRasp: [DailyRaspisanieTeacher], typeWeak: Bool) -> [DailyRaspisanieTeacher]? {
        var result:[DailyRaspisanieTeacher]
        
        if typeWeak {
            result = dayRasp.filter( {$0.typeWeek == "Числитель" || $0.typeWeek == "Еженедельно"})
        } else {
            result = dayRasp.filter( {$0.typeWeek == "Знаменатель" || $0.typeWeek == "Еженедельно"})
        }
        return result
    }
    
    //MARK: - максимальное число предметов в день
    public func getMaxParInAllWeek(allRaspisanie: WeakRaspisanieTeacher) -> Int {
        var buffCountDay:[Int] = []
        
        if let monday = allRaspisanie.monday {
            if let a = getOnlyChangedDayTypeTeacher(dayRasp: monday, typeWeak: false)?.count {
                buffCountDay.append(a)
            }
            if let b = getOnlyChangedDayTypeTeacher(dayRasp: monday, typeWeak: true)?.count {
                buffCountDay.append(b)
            }
        }
        if let tuesday = allRaspisanie.tuesday {
            if let a = getOnlyChangedDayTypeTeacher(dayRasp: tuesday, typeWeak: false)?.count {
                buffCountDay.append(a)
            }
            if let b = getOnlyChangedDayTypeTeacher(dayRasp: tuesday, typeWeak: true)?.count {
                buffCountDay.append(b)
            }
        }
        if let wednesday = allRaspisanie.wednesday {
            if let a = getOnlyChangedDayTypeTeacher(dayRasp: wednesday, typeWeak: false)?.count {
                buffCountDay.append(a)
            }
            if let b = getOnlyChangedDayTypeTeacher(dayRasp: wednesday, typeWeak: true)?.count {
                buffCountDay.append(b)
            }
        }
        if let thursday = allRaspisanie.thursday {
            if let a = getOnlyChangedDayTypeTeacher(dayRasp: thursday, typeWeak: false)?.count {
                buffCountDay.append(a)
            }
            if let b = getOnlyChangedDayTypeTeacher(dayRasp: thursday, typeWeak: true)?.count {
                buffCountDay.append(b)
            }
        }
        if let friday = allRaspisanie.friday {
            if let a = getOnlyChangedDayTypeTeacher(dayRasp: friday, typeWeak: false)?.count {
                buffCountDay.append(a)
            }
            if let b = getOnlyChangedDayTypeTeacher(dayRasp: friday, typeWeak: true)?.count {
                buffCountDay.append(b)
            }
        }
        if let saturday = allRaspisanie.saturday {
            if let a = getOnlyChangedDayTypeTeacher(dayRasp: saturday, typeWeak: false)?.count {
                buffCountDay.append(a)
            }
            if let b = getOnlyChangedDayTypeTeacher(dayRasp: saturday, typeWeak: true)?.count {
                buffCountDay.append(b)
            }
        }
        if let max = buffCountDay.max() {
            return max
        } else {
            return 4
        }
    }
    
    //MARK: - возврат текущего дня недели
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
    
    public func getTodayInStr() -> String {
        let date = Date()
        let calendar = Calendar.current
        var weekday = calendar.component(.weekday, from: date)
        weekday -= 2
        
        if weekday < 0 {
            weekday = 0
        } 
        
        switch weekday {
        case 0:
            return "Пн."
        case 1:
            return "Вт."
        case 2:
            return "Ср."
        case 3:
            return "Чт."
        case 4:
            return "Пт."
        case 5:
            return "Сб."
        default:
            return "Не найдено!"
        }
        
    }
    
    //MARK: - получение массива из списка дней недели по дате
    public func getDateWeek(week: Week) -> [String] {
        var date: [Date] = []
        
        let today = getToday()
        var monday = Date()
        var tuesday = Date()
        var wednesday = Date()
        var thursday = Date()
        var friday = Date()
        var saturday = Date()
        
        if week == .now {
            if today > 0 {
                monday = Date.today().previous(.monday, considerToday: true)
            } else {
                monday = Date.today().next(.monday, considerToday: true)
            }
            
            if today > 1 {
                tuesday = Date.today().previous(.tuesday, considerToday: true)
            } else {
                tuesday = Date.today().next(.tuesday, considerToday: true)
            }
            
            if today > 2 {
                wednesday = Date.today().previous(.wednesday, considerToday: true)
            } else {
                wednesday = Date.today().next(.wednesday, considerToday: true)
            }
            
            if today > 3 {
                thursday = Date.today().previous(.thursday, considerToday: true)
            } else {
                thursday = Date.today().next(.thursday, considerToday: true)
            }
            
            if today > 4 {
                friday = Date.today().previous(.friday, considerToday: true)
            } else {
                friday = Date.today().next(.friday, considerToday: true)
            }
            
            if today > 5 {
                saturday = Date.today().previous(.saturday, considerToday: true)
            } else {
                saturday = Date.today().next(.saturday, considerToday: true)
            }
            
            date.append(contentsOf: [monday, tuesday, wednesday, thursday, friday, saturday])
        } else {
            
            if today < 0 {
                monday = Date.today().next(.monday).next(.monday)
            } else {
                monday = Date.today().next(.monday)
            }
            
            if today < 1 {
                tuesday = Date.today().next(.tuesday).next(.tuesday)
            } else {
                tuesday = Date.today().next(.tuesday)
            }
            
            if today < 2 {
                wednesday = Date.today().next(.wednesday).next(.wednesday)
            } else {
                wednesday = Date.today().next(.wednesday)
            }
            
            if today < 3 {
                thursday = Date.today().next(.thursday).next(.thursday)
            } else {
                thursday = Date.today().next(.thursday)
            }
            
            if today < 4 {
                friday = Date.today().next(.friday).next(.friday)
            } else {
                friday = Date.today().next(.friday)
            }
            
            if today < 5 {
                saturday = Date.today().next(.saturday).next(.saturday)
            } else {
                saturday = Date.today().next(.saturday)
            }
            
            date.append(contentsOf: [monday, tuesday, wednesday, thursday, friday, saturday])
        }
        
        var dateInString: [String] = []
        
        date.forEach { (date) in
            
            let formatter = DateFormatter()
            formatter.dateFormat = "dd.MM"
            let dateStr = formatter.string(from: date)
            let dateNowStr = formatter.string(from: Date.today())
            
            if dateStr == dateNowStr {
                if  !SystemDevice().isNormalDevice  {
                    dateInString.append("Сегодня")
                } else {
                    dateInString.append("Сегодня, " + dateStr)
                }
            } else {
                dateInString.append(dateStr)
            }
        }
        
        return dateInString
    }
}

//MARK: - расширение для получения даты каждого из дней по недели
extension Date {
    
    static func today() -> Date {
        return Date()
    }
    
    func next(_ weekday: Weekday, considerToday: Bool = false) -> Date {
        return get(.next,
                   weekday,
                   considerToday: considerToday)
    }
    
    func previous(_ weekday: Weekday, considerToday: Bool = false) -> Date {
        return get(.previous,
                   weekday,
                   considerToday: considerToday)
    }
    
    func get(_ direction: SearchDirection,
             _ weekDay: Weekday,
             considerToday consider: Bool = false) -> Date {
        
        let dayName = weekDay.rawValue
        
        let weekdaysName = getWeekDaysInEnglish().map { $0.lowercased() }
        
        assert(weekdaysName.contains(dayName), "weekday symbol should be in form \(weekdaysName)")
        
        let searchWeekdayIndex = weekdaysName.firstIndex(of: dayName)! + 1
        
        let calendar = Calendar(identifier: .gregorian)
        
        if consider && calendar.component(.weekday, from: self) == searchWeekdayIndex {
            return self
        }
        
        var nextDateComponent = calendar.dateComponents([.hour, .minute, .second], from: self)
        nextDateComponent.weekday = searchWeekdayIndex
        
        let date = calendar.nextDate(after: self,
                                     matching: nextDateComponent,
                                     matchingPolicy: .nextTime,
                                     direction: direction.calendarSearchDirection)
        
        return date!
    }
    
}

extension Date {
    func getWeekDaysInEnglish() -> [String] {
        var calendar = Calendar(identifier: .gregorian)
        calendar.locale = Locale(identifier: "en_US_POSIX")
        return calendar.weekdaySymbols
    }
    
    enum Weekday: String {
        case monday, tuesday, wednesday, thursday, friday, saturday, sunday
    }
    
    enum SearchDirection {
        case next
        case previous
        
        var calendarSearchDirection: Calendar.SearchDirection {
            switch self {
            case .next:
                return .forward
            case .previous:
                return .backward
            }
        }
    }
}
