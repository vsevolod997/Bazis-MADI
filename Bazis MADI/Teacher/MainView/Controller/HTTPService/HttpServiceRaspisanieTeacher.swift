//
//  HttpServiceRaspisanieTeacher.swift
//  Bazis MADI
//
//  Created by Всеволод Андрющенко on 04.01.2020.
//  Copyright © 2020 Всеволод Андрющенко. All rights reserved.
//

import Foundation

class HttpServiceRaspisanieTeacher {
    
    //MARK: - получение списка расписания
    class func getRaspisData(teacherName: String, complition: @escaping(Error?, RaspisanieModelTeacher?) -> Void) {
        
        //let urlStr = "https://api.shastin.xyz/schedule.php?teacher=\(teacherName)"
        //let urlStr = "https://bazis.madi.ru/stud/schedule.php?teacher=\(teacherName)"
        let urlStr = "https://api.shastin.xyz/schedule.php?teacher=Юрчик П.Ф."
        guard let urlsStr =  urlStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        let url = URL(string: urlsStr)!
        let urlReqest = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: urlReqest) { (data, response, error) in
            if let err = error {
                complition(err, nil)
            } else {
                guard let datas = data else { return }
                do{
                    let dataEncode = try JSONDecoder().decode(RaspisanieModelTeacher.self, from: datas)
                    complition(nil, dataEncode)
                } catch let jsonError {
                    complition(jsonError, nil)
                }
            }
        }
        task.resume()
    }
}
