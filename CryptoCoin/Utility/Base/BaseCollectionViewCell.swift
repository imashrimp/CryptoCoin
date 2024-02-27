//
//  BaseCollectionViewCell.swift
//  CryptoCoin
//
//  Created by 권현석 on 2/27/24.
//

import UIKit

class BaseCollectionViewCell: UICollectionViewCell {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        setConstraints()
    }
    
    func configure() {
        
    }
    
    func setConstraints() {
        
    }
    
    @available (*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
