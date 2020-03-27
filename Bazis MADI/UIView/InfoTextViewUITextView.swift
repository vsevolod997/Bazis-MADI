//
//  InfoTextViewUITextView.swift
//  Bazis MADI
//
//  Created by Всеволод Андрющенко on 25.03.2020.
//  Copyright © 2020 Всеволод Андрющенко. All rights reserved.
//

import UIKit

class InfoTextViewUITextView: UITextView {
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    private func setupView() {
        clipsToBounds = false
        layer.cornerRadius = 10
        backgroundColor = .systemFill
    }
}

