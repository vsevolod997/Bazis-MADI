//
//  HttpServiceRaspisanie.swift
//  Bazis MADI
//
//  Created by Всеволод Андрющенко on 11.12.2019.
//  Copyright © 2019 Всеволод Андрющенко. All rights reserved.
//

import Foundation

class HttpServiceRaspisanie {
    
    //MARK: - получение списка расписания
    class func getRaspisData(groupName: String, complition: @escaping(Error?, RaspisanieModel?) -> Void) {
        let urlStr = "https://bazis.madi.ru/stud/schedule.php?group=\(groupName)"
        guard let urlsStr =  urlStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        let url = URL(string: urlsStr)!
        let urlReqest = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: urlReqest) { (data, response, error) in
            if let err = error {
                complition(err, nil)
            } else {
                guard let datas = data else { return }
                do{
                    let dataEncode = try JSONDecoder().decode(RaspisanieModel.self, from: datas)
                    complition(nil, dataEncode)
                } catch let jsonError {
                    complition(jsonError, nil)
                }
            }
        }
        task.resume()
    }
}
