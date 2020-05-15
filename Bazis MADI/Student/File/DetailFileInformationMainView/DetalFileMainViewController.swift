//
//  DetalFileMainViewController.swift
//  Bazis MADI
//
//  Created by Всеволод Андрющенко on 31.03.2020.
//  Copyright © 2020 Всеволод Андрющенко. All rights reserved.
//

import UIKit

//MARK:- Родительский контроллер для просмотра информации о файле
class DetalFileMainViewController: UIViewController {

    var reviewView: DetailFileReviewTableViewController!
    
    var detailInfo: DetalFileInfoTableViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configueDetailView()
    }
    
    var fileData: FileToShowModel!
    
    var indexFile: Int!
    
    //окно подробной иформации
    private func configueDetailView() {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = sb.instantiateViewController(identifier: "fileDetal") as? DetalFileInfoTableViewController else { return }
        vc.fileData = self.fileData
        vc.indexFile = self.indexFile
        vc.delegate = self
        view.addSubview(vc.view)
        addChild(vc)
        detailInfo = vc
    }
    
    private func configueReviewView(review: [ReviewModel]) {
        if reviewView == nil {
            let sb = UIStoryboard(name: "Main", bundle: nil)
            guard let vc = sb.instantiateViewController(identifier: "fileReview") as? DetailFileReviewTableViewController else { return }
            view.insertSubview(vc.view, at: 0)
            vc.delegate = self
            vc.fileReview = review
            addChild(vc)
            reviewView = vc
        }
    }
    
    private func showReviewView() {
        UIView.animate(withDuration: 0.3) {
            self.detailInfo.view.transform = .init(translationX: -self.view.frame.width , y: 0)
        }
    }
    
    private func closeReviewView() {
        UIView.animate(withDuration: 0.3) {
            self.detailInfo.view.transform = .init(translationX: 0 , y: 0)
        }
    }
}
 
extension DetalFileMainViewController: ShowReviewDelegate {
    func showReviewDelegate(fileReview: [ReviewModel]) {
        configueReviewView(review: fileReview)
        showReviewView()
    }
}

extension DetalFileMainViewController: FileReviewDelegate {
    func closeFileReview() {
        closeReviewView()
    }
}
