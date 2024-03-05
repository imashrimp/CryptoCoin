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
    
    var coinItemDidSelect: ((String) -> Void)?
    
    private let cellTitleLabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 20, weight: .heavy)
        return view
    }()
    
    private let favoriteCollectionView = {
        let view = UICollectionView(frame: .zero,
                                    collectionViewLayout: trendFavoriteCollectionViewFlowLayout())
        view.register(TrendingFavoriteCollectionViewCell.self,
                      forCellWithReuseIdentifier: TrendingFavoriteCollectionViewCell.id)
        view.showsHorizontalScrollIndicator = false
        return view
    }()
    
    func showContents(data: TrendEntity) {
        
        cellTitleLabel.text = data.sectionTitle
        
        Observable<[PresentItemEntity]>.just(data.data)
            .bind(to: favoriteCollectionView
                .rx
                .items(cellIdentifier: TrendingFavoriteCollectionViewCell.id,
                       cellType: TrendingFavoriteCollectionViewCell.self)) { (item, element, cell) in
                cell.showContents(data: element)
            }
                       .disposed(by: disposeBag)
        
        favoriteCollectionView
            .rx
            .modelSelected(PresentItemEntity.self)
            .bind(with: self) { owner, value in
                owner.coinItemDidSelect?(value.id)
            }
            .disposed(by: disposeBag)
    }
    
    override func configure() {
        super.configure()
        
        [
            cellTitleLabel,
            favoriteCollectionView
        ].forEach { contentView.addSubview($0) }
        
    }
    
    override func setConstraints() {
        
        cellTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
        
        favoriteCollectionView.snp.makeConstraints {
            $0.top.equalTo(cellTitleLabel.snp.bottom).offset(8)
            $0.horizontalEdges.bottom.equalToSuperview()
            $0.height.equalTo(170)
        }
    }
    
    override func prepareForReuse() {
        favoriteCollectionView.reloadData()
        disposeBag = DisposeBag()
    }
    
}
