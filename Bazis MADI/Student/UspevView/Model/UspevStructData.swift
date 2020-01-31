//
//  UspevStructData.swift
//  Bazis MADI
//
//  Created by Всеволод Андрющенко on 24.01.2020.
//  Copyright © 2020 Всеволод Андрющенко. All rights reserved.
//

import Foundation

//MARK: - класс для более удоьного отображения данных
class UspevStructData {
    var isShow: Bool
    var sem: Int
    var dataSem: [UspevModel]
    
    init (sem: Int, dataSem: [UspevModel]) {
        self.sem = sem
        self.isShow = false
        self.dataSem = dataSem
    }
    
    //MARK:- функция конвертации полученных данных (UspevModel) в UspevStructData
    class func modelToDataSem(uspevModel:[UspevModel]) ->[UspevStructData] {
        var uspevReturnData:[UspevStructData] = []
        
        let uspevDict = Dictionary(grouping: uspevModel, by: { $0.sem })
        var resultDict = uspevDict.map { (key: String, value: [UspevModel]) in
            return (Int(key)! - 1, value)
        }
        resultDict = resultDict.sorted(by: {$0.0 < $1.0})
        
        var count: Int = 0
        for res in resultDict {
            let results = UspevStructData(sem: count, dataSem: res.1.sorted(by: {$0.vid > $1.vid}) )
            uspevReturnData.append(results)
            count += 1
        }
        
        return uspevReturnData
    }
}
