//
//  Device.swift
//  Bazis MADI
//
//  Created by Всеволод Андрющенко on 06.01.2020.
//  Copyright © 2020 Всеволод Андрющенко. All rights reserved.
//

import UIKit

//MARK: - название устройства
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
