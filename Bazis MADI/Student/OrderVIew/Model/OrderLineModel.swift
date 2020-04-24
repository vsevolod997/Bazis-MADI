//
//  OrderModel.swift
//  Bazis MADI
//
//  Created by Всеволод Андрющенко on 18.04.2020.
//  Copyright © 2020 Всеволод Андрющенко. All rights reserved.
//

import Foundation

struct OrderLineModel {
    var lineTitle: String
    var lineData: Any
    
    init(key: String, value: Any) {
        lineTitle = key
        lineData = value
    }
}

