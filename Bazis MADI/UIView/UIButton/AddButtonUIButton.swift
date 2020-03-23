//
//  AddButtonUIButton.swift
//  Bazis MADI
//
//  Created by Всеволод Андрющенко on 22.03.2020.
//  Copyright © 2020 Всеволод Андрющенко. All rights reserved.
//

import UIKit

class AddButtonUIButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupStyle()
        
    }
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupStyle()
    }
    
    private func setupStyle() {
        //self.backgroundColor = SystemColor.blueColor
        
        let image = UIImage(named: "addB")
        setImage(image, for: .normal)
        
        layer.shadowColor = SystemColor.shadowColor.cgColor
        layer.shadowRadius = 5
        layer.shadowOffset = CGSize(width: 0.5, height: 0.5)
        layer.shadowOpacity = 0.6
    }
    
    //MARK:- анимация показывания кнопки
    func oppenButton(){
        UIView.animate(withDuration: 0.5) {
            self.alpha = 1.0
            self.frame.origin.y = self.frame.origin.y - 150
            self.transform = CGAffineTransform(scaleX: 1, y: 1)
        }
    }
    
    // MARK:- анимация свертывания кнопки
    func closeButton(){
        UIView.animate(withDuration: 0.5) {
            self.alpha = 0.5
            self.frame.origin.y = self.frame.origin.y + 150
            self.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        }
    }
    
    override var isHighlighted: Bool {
        didSet {
            if isHighlighted {
                transform = .init(scaleX: 0.8, y: 0.8)
            } else {
                transform = .init(scaleX: 1, y: 1)
            }
        }
    }
    
}
