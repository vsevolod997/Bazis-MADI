//
//  OrderModel.swift
//  Bazis MADI
//
//  Created by Всеволод Андрющенко on 18.04.2020.
//  Copyright © 2020 Всеволод Андрющенко. All rights reserved.
//

import Foundation

struct OrderModel {
    var lineTitle: String
    var lineData: Any
    
    init(key: String, value: Any) {
        lineTitle = key
        lineData = value
    }
    
    static func convertJson(json: Any) -> [[OrderModel]] {
        
        var result: [[OrderModel]] = []
        let datas = json as! Array<Dictionary<String, Any>>
       
        for data in datas {
            var elem: [OrderModel] = []
            
            for str in  data {
                
                let line = OrderModel(key: str.key, value: str.value)
                elem.append(line)
            }
            result.append(elem)
        }
        print(result)
        return result
    }
}

