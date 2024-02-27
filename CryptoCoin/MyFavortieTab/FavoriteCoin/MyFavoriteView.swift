//
//  MyFavoriteView.swift
//  CryptoCoin
//
//  Created by 권현석 on 2/27/24.
//

import UIKit

final class MyFavoriteView: BaseView {
    
    let coinTitleLabel = {
        let view = UILabel()
        view.text = "Favorite Coin"
        view.font = .systemFont(ofSize: 38,
                                weight: .bold)
        return view
    }()
    
    lazy var favoriteCoinCollectionView = {
        let view = UICollectionView(frame: .zero,
                                    collectionViewLayout: favoriteCoinCollectionViewFlowlayout())
        view.showsVerticalScrollIndicator = false
        view.register(FavoriteCollectionViewCell.self,
                      forCellWithReuseIdentifier: FavoriteCollectionViewCell.id)
        return view
    }()
    
    private func favoriteCoinCollectionViewFlowlayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        
        let itemSpacing: CGFloat = 20
        
        let width = UIScreen.main.bounds.width - (itemSpacing * 3)
        let itemWidth = width / 2
        
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        layout.scrollDirection = .vertical
        
        layout.minimumLineSpacing = itemSpacing
        layout.minimumInteritemSpacing = itemSpacing
        layout.sectionInset = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
        
        return layout
    }
    
    override func configure() {
        super.configure()
        [
        coinTitleLabel,
        favoriteCoinCollectionView
        ].forEach { addSubview($0) }
    }
    
    override func setConstrinats() {
        coinTitleLabel.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview().inset(12)
        }
        
        favoriteCoinCollectionView.snp.makeConstraints {
            $0.top.equalTo(coinTitleLabel.snp.bottom).offset(12)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(safeAreaLayoutGuide)
        }
    }
}
