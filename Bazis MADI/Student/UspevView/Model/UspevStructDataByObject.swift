//
//  UspevStructDataByObject.swift
//  Bazis MADI
//
//  Created by Всеволод Андрющенко on 29.01.2020.
//  Copyright © 2020 Всеволод Андрющенко. All rights reserved.
//

import Foundation

//MARK: - по предмету
class UspevStructDataByObject {
    var isShow: Bool
    var objectData: String
    var semInfo: [UspevModel]
    
    init (semInfo:[UspevModel], objectData: String) {
        self.objectData = objectData
        self.isShow = false
        self.semInfo = semInfo
    }
    
    //MARK:- функция конвертации полученных данных (UspevModel) в UspevStructDataByObject
    class func modelToDataSem(uspevModel:[UspevModel]) ->[UspevStructDataByObject] {
        var uspevReturnData:[UspevStructDataByObject] = []
        
        let uspevDict = Dictionary(grouping: uspevModel, by: { $0.disc})
        let uspevDictSort = uspevDict.sorted(by: {$0.0 < $1.0})
        for res in uspevDictSort {
            let result = UspevStructDataByObject(semInfo: res.value, objectData: res.key)
            uspevReturnData.append(result)
        }
        return uspevReturnData
    }
}
