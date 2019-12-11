//
//  TableRaspisanieUIView.swift
//  Bazis MADI
//
//  Created by Всеволод Андрющенко on 11.12.2019.
//  Copyright © 2019 Всеволод Андрющенко. All rights reserved.
//

import UIKit

protocol TableRaspisanieDataSource {
    func parameterViewDataCount(_ parameterView: TableRaspisanieUIView) -> Int
    
    func parameterViewTitle(_ parametrView: TableRaspisanieUIView,  indexPath: IndexPath) -> String
}

class TableRaspisanieUIView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public var raspisanieViewDataSource: TableRaspisanieDataSource? {
        didSet{
            setupView()
        }
    }
    
    private func setupView() {
        backgroundColor = .red
    }

}
