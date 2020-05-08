//
//  FileReviewMainViewController.swift
//  Bazis MADI
//
//  Created by Всеволод Андрющенко on 03.05.2020.
//  Copyright © 2020 Всеволод Андрющенко. All rights reserved.
//

import UIKit
import AVFoundation

class DetailStudentFileMainViewController: UIViewController {
    
    private var reviewView: UINavigationController!
    private var buttonView: UIView!
    private var selectedButton: CancellAddButton!
    private var detaileFileView: StudentDetailFileTableViewController!
    private var isSelectedFile = false //   флаг выбора файла
    private var nameReviewFile = ""
    private var isFullView = false // флаг полного открвтия окна выбора рецензии
    
    public var fileData: FileToShowModel!
    public var student: StudentModel!
    
    private var heigthValue: CGFloat = 0
    // коэффиуиент
    private let coefHeigth: CGFloat = 1.8
    
    private let contrller = DetailStudentMainController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurateDetailView()
        contrller.delegate = self
    }

    //окно деткльной информации о файле
    private func configurateDetailView() {
        let sb = UIStoryboard(name: "Teacher", bundle: nil)
        guard let vc = sb.instantiateViewController(identifier: "studentFileDetail") as? StudentDetailFileTableViewController else { return }
        detaileFileView = vc
        vc.fileData = self.fileData
        vc.student = self.student
        vc.mainDelegate = self
        view.addSubview(vc.view)
        addChild(vc)
    }
    
    // демонстрация окна выбора файла
    fileprivate func presentSelectReviewView() {
        configueSelectReviewView()
        
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseOut, animations: {
            self.reviewView.view.transform = .init(translationX: 0, y: self.view.frame.height / self.coefHeigth)
        }) { _ in
            self.createButtonView()
        }
    }
    
    private func configueSelectReviewView() {
        let sb = UIStoryboard(name: "Teacher", bundle: nil)
        guard let vc = sb.instantiateViewController(identifier: "fileReview") as? SelectReviewViewController else { return }
        vc.delegate = self
        
        let navController = UINavigationController(rootViewController: vc)
        view.insertSubview(navController.view, at: 1)
        navController.view.transform = .init(translationX: 0, y: self.view.frame.height)
        
        reviewView = navController
    }
    
    
    private func createButtonView() {
        let buttonView = UIView()
        buttonView.backgroundColor = SystemColor.colorFill
        buttonView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(buttonView)
        buttonView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        buttonView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        buttonView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height - view.frame.height / 9).isActive = true
        buttonView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        let addButton = CancellAddButton()
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.addTarget(self, action: #selector(buttonPress), for: .touchUpInside)
        buttonView.addSubview(addButton)
        
        addButton.leftAnchor.constraint(equalTo: buttonView.leftAnchor, constant: 20).isActive = true
        addButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
        addButton.rightAnchor.constraint(equalTo: buttonView.rightAnchor, constant: -20 ).isActive = true
        addButton.topAnchor.constraint(equalTo: buttonView.topAnchor, constant: 10).isActive = true
        
        self.buttonView = buttonView
        self.selectedButton = addButton
    }
    
    
    @objc func buttonPress() {
        if isSelectedFile {
            contrller.selectNewReiewFile(fileName: fileData.name, studentUIC: student.idc, reviewName: nameReviewFile)
        } else {
             closeFileSelectView()
        }
    }
    
    private func closeFileSelectView() {
        if reviewView != nil {
            UIView.animate(withDuration: 0.2, animations: {
                self.reviewView.view.transform = .init(translationX: 0, y: self.view.frame.height)
            }) { _ in
                self.buttonView.removeFromSuperview()
                self.reviewView.removeFromParent()
                self.detaileFileView.closeSelectRevievFileView()
                self.isFullView = false
                self.isSelectedFile = false
                self.nameReviewFile = ""
            }
        }
    }
    
    private func downScrollView() {
        self.isFullView = false
        
        UIView.animate(withDuration: 0.15, animations: {
            self.reviewView.view.transform = .init(translationX: 0, y: self.self.view.frame.height / self.coefHeigth)
        })
    }
    
    private func upScrollView() {
        self.isFullView = true
        
        UIView.animate(withDuration: 0.15, animations: {
             self.reviewView.view.transform = .init(translationX: 0, y: 0)
        })
    }
}

//MARK: - SelectReviewFileDelegate
extension DetailStudentFileMainViewController: SelectReviewFileDelegate {
    
    func finishScrollView(value: CGFloat, controller: UIViewController) {
        if isFullView {
            if value < -20 {
                downScrollView()
            }
        } else {
            if value >= 0 {
                upScrollView()
            }
        }
    }
    
    func scrollView(scrollValue: CGFloat, controller: UIViewController) {
        heigthValue = self.view.frame.height / coefHeigth - scrollValue
        print(scrollValue)
        if !isFullView {
            reviewView.view.transform = .init(translationX: 0, y: heigthValue)
        } else {
            if scrollValue < 0 {
                reviewView.view.transform = .init(translationX: 0, y: -scrollValue)
            } else {
                reviewView.view.transform = .init(translationX: 0, y: 0)
            }
        }
        
        //        heigthValue = self.view.frame.height / coefHeigth - scrollValue
        //        if !isFullView {
        //            reviewView.view.transform = .init(translationX: 0, y: heigthValue)
        //        } else {
        //            if scrollValue < 0 {
        //                reviewView.view.transform = .init(translationX: 0, y: heigthValue)
        //            }
        //        }
    }
    
    func selectView(fileSelected: FileToShowModel, controller: UIViewController) {
        isSelectedFile = true
        nameReviewFile = fileSelected.name
        selectedButton.setAddStyle()
    }
    
    func deselectView(controller: UIViewController) {
        isSelectedFile = false
        nameReviewFile = ""
        selectedButton.setCancellStyle()
    }
}

//MARK: - StudentFileDetailControllerDelegate
extension DetailStudentFileMainViewController: StudentFileDetailControllerDelegate {
    
    func showFileReviewView() {
        presentSelectReviewView()
    }
    
    func closeFileReviewView() {
        closeFileSelectView()
    }
}

// MARK: - DetailStudentMainControllerDelegate
extension DetailStudentFileMainViewController: DetailStudentMainControllerDelegate {
    
    func showErrorReviewAdd(errorMess: String, controller: DetailStudentMainController) {
        let alert = UIAlertController(title: "Ошибка!", message: errorMess, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ок", style: .default, handler: nil)
        alert.addAction(okAction)
        
        present(alert, animated: true)
    }
    
    func reviewUpload(controller: DetailStudentMainController) {
        detaileFileView.selectNewReview(nameFile: nameReviewFile)
        closeFileSelectView()
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.impactOccurred()
    }
}
