//
//  BaseTableViewCell.swift
//  CryptoCoin
//
//  Created by 권현석 on 2/26/24.
//

import UIKit
import RxSwift

class BaseTableViewCell: UITableViewCell {
    
    let disposeBag = DisposeBag()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
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
