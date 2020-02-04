//
//  UspevModel.swift
//  Bazis MADI
//
//  Created by Всеволод Андрющенко on 21.01.2020.
//  Copyright © 2020 Всеволод Андрющенко. All rights reserved.
//

import Foundation


//MARK: - модель для парсинга json
struct UspevModel: Decodable, Hashable{
    var vid: String
    var disc: String
    var tema: String?
    var hour: String?
    var sem: String
    var date: String?
    var ocenka: String? 
}
