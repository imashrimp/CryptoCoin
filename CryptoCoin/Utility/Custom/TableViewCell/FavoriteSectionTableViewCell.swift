//
//  FavoriteSectionTableViewCell.swift
//  CryptoCoin
//
//  Created by 권현석 on 2/28/24.
//

import UIKit
import RxSwift
import RxCocoa

final class FavoriteSectionTableViewCell: BaseTableViewCell {
    
    private let favoriteCollectionView = {
        let view = UICollectionView(frame: .zero,
                                    collectionViewLayout: trendFavoriteCollectionViewFlowLayout())
        view.register(TrendingFavoriteCollectionViewCell.self,
                      forCellWithReuseIdentifier: TrendingFavoriteCollectionViewCell.id)
        view.showsHorizontalScrollIndicator = false
        return view
    }()
    
    func showContents(data: [PresentItemEntity]) {
        Observable<[PresentItemEntity]>.just(data)
            .bind(to: favoriteCollectionView
                .rx
                .items(cellIdentifier: TrendingFavoriteCollectionViewCell.id,
                       cellType: TrendingFavoriteCollectionViewCell.self)) { (item, element, cell) in
                cell.showContents(data: element)
            }
                       .disposed(by: disposeBag)
    }
    
    override func configure() {
        super.configure()
        
        [
            favoriteCollectionView
        ].forEach { contentView.addSubview($0) }
        
    }
    
    override func setConstraints() {
        favoriteCollectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalTo(170)
        }
    }
    
    override func prepareForReuse() {
        favoriteCollectionView.reloadData()
        disposeBag = DisposeBag()
    }
    
}
