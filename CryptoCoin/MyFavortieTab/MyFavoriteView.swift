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
        view.register(FavoriteCollectionViewCell.self,
                      forCellWithReuseIdentifier: FavoriteCollectionViewCell.id)
        return view
    }()
    
    private func favoriteCoinCollectionViewFlowlayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        
        let itemSpacing: CGFloat = 20
        
        ///컬렉션 뷰의 너비에서 컬렉션 셀이 컬렉션 뷰셀의 양 옆으로부터 이격된 거리 만큼 빼주고, 각 열의 갯수 -1의 수를 아이템 간격에 곱한 수를 빼줌
        let width = UIScreen.main.bounds.width /*- 16 - (itemSpacing * 2)*/ - (itemSpacing * 3)
        let itemWidth = width / 2
        
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        layout.scrollDirection = .vertical
        
        layout.minimumLineSpacing = itemSpacing //행이 line
        layout.minimumInteritemSpacing = itemSpacing//좌우 item간 간격 의미
        
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
