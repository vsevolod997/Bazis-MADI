//
//  FileToShowController.swift
//  Bazis MADI
//
//  Created by Всеволод Андрющенко on 20.03.2020.
//  Copyright © 2020 Всеволод Андрющенко. All rights reserved.
//

import UIKit


enum TypeFile {
    case PDF, DOC, EXСEl, IMG, OTHER, PPT
}


class FileToShowModelController {
    private func selectTypeFile(name: String) -> TypeFile {
        guard let typeString = name.split(separator: ".").last  else { return .OTHER }
        switch typeString {
        case "doc":
            return .DOC
        case "docx":
            return .DOC
        case "png":
            return .IMG
        case "jpg":
            return .IMG
        case "xls":
            return .EXСEl
        case "xlsx":
            return .EXСEl
        case "xlsm":
            return .EXСEl
        case "pdf":
            return .PDF
        case "ppt":
            return .PPT
        case "pptx":
            return .PPT
        default:
            return .OTHER
        }
    }
    
    private func selectImgType(type: TypeFile)  -> UIImage? {
        var name: String
        
        switch type {
        case .PPT:
            name = "ppt"
        case .DOC:
            name = "doc"
        case .EXСEl:
            name = "excel"
        case .IMG:
            name = "img"
        case .PDF:
            name = "pdf"
        case .OTHER:
            name = "other"
        }
        
        return UIImage(named: name)
    }
    
    func setupShowFileToData(modelFile: [FileModel]) -> [FileToShowModel] {
        var resultMas:[FileToShowModel] = []
        modelFile.forEach { (model) in
            let type = self.selectTypeFile(name: model.file)
            let img = self.selectImgType(type: type)
            let elemToShow  = FileToShowModel(nameL: model.file, date: model.time, path: model.path, type: type, image: img!)
            resultMas.append(elemToShow)
        }
        
        
        return resultMas.sorted(by: {
            $0.date > $1.date
        })
    }
}


