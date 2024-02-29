//
//  UIView+Extension.swift
//  CryptoCoin
//
//  Created by 권현석 on 2/28/24.
//

import UIKit

extension UIView {
    static func trendFavoriteCollectionViewFlowLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        let itemSpace: CGFloat = 16
        let width = UIScreen.main.bounds.width / 2

        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: width, height: 156)
        layout.minimumInteritemSpacing = itemSpace
        layout.sectionInset = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
        
        return layout
    }
    
    static func trendCollectionViewFlowLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        let itemSpace: CGFloat = 8
        let width = UIScreen.main.bounds.width - (itemSpace * 10)
        
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: width, height: 50)
//        layout.minimumLineSpacing = itemSpace
//        layout.minimumInteritemSpacing = 16
        layout.sectionInset = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        
        return layout
    }
}
