//
//  FileReviewMainViewController.swift
//  Bazis MADI
//
//  Created by Всеволод Андрющенко on 03.05.2020.
//  Copyright © 2020 Всеволод Андрющенко. All rights reserved.
//

import UIKit

class DetailStudentFileMainViewController: UIViewController {
    
    private var fileView: UINavigationController!
    
    private var heigthValue: CGFloat = 200
    // константный отступ от каря экрана
    private let constHeigth: CGFloat = 200
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        
        configueFileView()
        createButtonView()
        addGestue()
    }
    
    private func addGestue() {
        let tapGestue = UITapGestureRecognizer(target: self, action: #selector(tap))
        self.view.addGestureRecognizer(tapGestue)
    }
    
    @objc func tap() {
        print("tap")
    }

    private func configueFileView() {
        
        let sb = UIStoryboard(name: "Teacher", bundle: nil)
        guard let vc = sb.instantiateViewController(identifier: "fileReview") as? SelectReviewViewController else { return }
        vc.delegate = self
        
        let navController = UINavigationController(rootViewController: vc)
        view.addSubview(navController.view)
        addChild(navController)
        navController.view.transform = .init(translationX: 0, y: constHeigth)
        
        fileView = navController
    }
    
    
    private func createButtonView() {
        let buttonView = UIView()
        buttonView.frame = CGRect(x:0.0 , y: self.view.frame.height - self.view.frame.height/10, width: self.view.frame.width, height: self.view.frame.height/10)
        buttonView.backgroundColor = SystemColor.colorFill
        
        let rectButton = CGRect(x: 10, y: 10, width: self.view.frame.width - 20, height: self.view.frame.height/10 - 20)
        let addButton = CancellAddButton(frame: rectButton)
        addButton.addTarget(self, action: #selector(buttonPress), for: .touchUpInside)
        buttonView.addSubview(addButton)
        
        self.view.addSubview(buttonView)
    }
    
    
    @objc func buttonPress() {
        closeFileSelectView()
    }
    
    private func closeFileSelectView() {
        UIView.animate(withDuration: 0.2, animations: {
            self.fileView.view.transform = .init(translationX: 0, y: (self.view.frame.height - self.heigthValue))
        }) { _ in
            self.fileView.removeFromParent()
            self.dismiss(animated: true, completion: nil)
        }
    }
}

//MARK: - SelectReviewFileDelegate
extension DetailStudentFileMainViewController: SelectReviewFileDelegate {
    
    func scrollView(scrollValue: CGFloat, controller: SelectReviewViewController) {
            heigthValue =  constHeigth - scrollValue
        if heigthValue > 0 {
            fileView.view.transform = .init(translationX: 0, y: heigthValue)
        } else {
            fileView.view.transform = .init(translationX: 0, y: 0)
        }
    }
}
