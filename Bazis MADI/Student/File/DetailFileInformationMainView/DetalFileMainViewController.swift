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

    private var reviewView: UINavigationController!
    private var detailInfo: DetalFileInfoTableViewController!
    
    private var buttonView: UIView!
    
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
            let navController = UINavigationController(rootViewController: vc)
            view.insertSubview(navController.view, at: 1)
            vc.delegate = self
            vc.fileReview = review
            //addChild(navController.view.frame)
            reviewView = navController
            reviewView.view.transform = .init(translationX: 0, y: self.view.frame.width)
        }
        
        createButtonView()
    }
    
    // кнопка выбора\отмены
    private func createButtonView() {
        let buttonView = UIView()
        buttonView.backgroundColor = SystemColor.colorFill
        buttonView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(buttonView)
        buttonView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        buttonView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        buttonView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height - view.frame.height / 9).isActive = true
        buttonView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        let cancellButton = InputButton1UIButton()
        cancellButton.setTitle("Закрыть", for: .normal)
        cancellButton.translatesAutoresizingMaskIntoConstraints = false
        cancellButton.addTarget(self, action: #selector(buttomPress), for: .touchUpInside)
        buttonView.addSubview(cancellButton)
        
        cancellButton.leftAnchor.constraint(equalTo: buttonView.leftAnchor, constant: 20).isActive = true
        cancellButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
        cancellButton.rightAnchor.constraint(equalTo: buttonView.rightAnchor, constant: -20 ).isActive = true
        cancellButton.topAnchor.constraint(equalTo: buttonView.topAnchor, constant: 10).isActive = true
        
        self.buttonView = buttonView
    }
    
    @objc func buttomPress() {
        closeFileReview()
    }
    
    // MARK: - Анимацяи открытия
    private func showReviewView() {
        isModalInPresentation = true
        UIView.animate(withDuration: 0.3) {
            self.reviewView.view.transform = .init(translationX: 0, y: self.view.frame.height * 0.3 )
        }
    }
    
    // MARK: - Анимация закрытия
    private func closeReviewView() {
        UIView.animate(withDuration: 0.3, animations: {
            self.reviewView.view.transform = .init(translationX: 0 , y: self.view.frame.height)
        }) { _ in
            self.isModalInPresentation = false
            self.buttonView.removeFromSuperview()
        }
    }
}
 
extension DetalFileMainViewController: ShowReviewDelegate {
    
    func setupModalClose(isHaveChanging: Bool) {
        isModalInPresentation = isHaveChanging
    }
    
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
