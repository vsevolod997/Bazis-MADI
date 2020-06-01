//
//  OrderModel.swift
//  Bazis MADI
//
//  Created by Всеволод Андрющенко on 22.04.2020.
//  Copyright © 2020 Всеволод Андрющенко. All rights reserved.
//

import Foundation

struct OrderModel {
    var title: String
    var lineModel: [OrderLineModel]
    
    static func convertJson(json: Any) -> [OrderModel] {
        var result: [OrderModel] = []
        
        let datas = json as! Array<Dictionary<String, Any>>
        for data in datas {
            var elem: [OrderLineModel] = []
            var title: String = ""
            for str in data {
                if str.key == "name" {
                    title = str.value as! String
                } else {
                    let line = OrderLineModel(key: str.key + ":", value: str.value)
                    elem.append(line)
                }
            }
            let sortedBuff = elem.sorted { (key1, key2) -> Bool in
                key1.lineTitle < key2.lineTitle
            }
            let oneOrder = OrderModel(title: title, lineModel: sortedBuff)
            result.append(oneOrder)
        }
        return result
    }
}
