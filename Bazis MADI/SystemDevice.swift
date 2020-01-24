//
//  Device.swift
//  Bazis MADI
//
//  Created by Всеволод Андрющенко on 06.01.2020.
//  Copyright © 2020 Всеволод Андрющенко. All rights reserved.
//

import UIKit

//MARK: - класс для раьоты с назыанием модели уст - ва
class SystemDevice {
    
    //MARK: - проверка на текущее уст во 
    var isNormalDevice: Bool {
        //print(UIDevice.current.modelName)
        if  UIDevice.current.modelName ==  "iPhone6,1" || UIDevice.current.modelName == "iPhone6,2" || UIDevice.current.modelName == "iPhone8,4" || UIDevice.current.modelName == "iPhone7,2" || UIDevice.current.modelName == "iPhone8,1" || UIDevice.current.modelName == "iPhone9,1" || UIDevice.current.modelName == "iPhone9,3" || UIDevice.current.modelName ==  "iPhone10,1" || UIDevice.current.modelName == "iPhone10,4" {
            return false
        } else {
            return true
        }
    }
}


//MARK: - расширение для текстового получения названия модели
extension UIDevice {
    var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        return identifier
    }
}
