//
//  TVShowDayCollectionViewCell.swift
//  MoviesTest
//
//  Created by Jeferson Alvarenga on 10/05/21.
//  Copyright © 2021 Jeferson Alvarenga. All rights reserved.
//

import UIKit

class TVShowDayCollectionViewCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        viewCodeSetup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var lblDay: UILabel = {
        let lbl = UILabel()
        lbl.layer.borderColor = UIColor.white.cgColor
        lbl.layer.borderWidth = 1
        lbl.textAlignment = .center
        lbl.textColor = .white
        return lbl
    }()
}

extension TVShowDayCollectionViewCell: ViewCodeProtocol {
    func viewAddElements() {
        contentView.addSubview(lblDay)
    }
    
    func viewConstraintElements() {
        lblDay.snp.makeConstraints { (mkr) in
            mkr.edges.equalToSuperview()
        }
    }
}
