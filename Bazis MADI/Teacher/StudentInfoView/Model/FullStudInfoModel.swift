//
//  FullStudInfoModel.swift
//  Bazis MADI
//
//  Created by Всеволод Андрющенко on 01.06.2020.
//  Copyright © 2020 Всеволод Андрющенко. All rights reserved.
//

import Foundation

struct FullStudInfoModel {
    
    var nameStudent: String
    var lineModel: [OrderLineModel] = []
    
    static func convertJson(json: Any) -> FullStudInfoModel {
        
        let datas = json as! Dictionary<String, Any>
        var elem: [OrderLineModel] = []
        var title: String = ""
        for str in datas {
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
        let infoStud = FullStudInfoModel(nameStudent: title, lineModel: sortedBuff)
        return infoStud
    }
}
