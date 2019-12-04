//
//  UserModel.swift
//  Bazis MADI
//
//  Created by Всеволод Андрющенко on 29.11.2019.
//  Copyright © 2019 Всеволод Андрющенко. All rights reserved.
//

import Foundation

struct UserModel: Decodable {
    var user_uic: String
    var user_fio: String
    var user_doc: String
    var user_groupid: String
    var user_type: String
    var user_group: String
    var user_path: String
    var user_uid: String
    var user_lnk: String    
}

struct UserModelError: Decodable {
    var err: String
}
