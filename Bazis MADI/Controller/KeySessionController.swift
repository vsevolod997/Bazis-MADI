//
//  SessionKeyModel.swift
//  Bazis MADI
//
//  Created by Всеволод Андрющенко on 04.12.2019.
//  Copyright © 2019 Всеволод Андрющенко. All rights reserved.
//

import Foundation

class KeySessionController {
    
    let defaults = UserDefaults.standard
    
    func setSessionKey(response: URLResponse?) {
        if let resp = response {
            let httpResponse = resp as! HTTPURLResponse
            let field = httpResponse.allHeaderFields["Set-Cookie"]
            if let cookie = field as? String {
                let string = cookie.split(separator: ";")
                defaults.set(String(string[0]), forKey: "key")
                print(string[0])
            }
        }
    }
    func getSessionKey() -> String?{
        return defaults.string(forKey: "key")
    }
}
