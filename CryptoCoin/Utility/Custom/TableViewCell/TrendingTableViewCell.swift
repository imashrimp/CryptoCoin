//
//  TrendingTableViewCell.swift
//  CryptoCoin
//
//  Created by 권현석 on 2/28/24.
//

import UIKit
import RxSwift
import RxCocoa

final class TrendingTableViewCell: BaseTableViewCell {
    
    var itemDidSelect: ((String) -> Void)?
    
    private let trendingCollectionView = {
        let view = UICollectionView(frame: .zero,
                                    collectionViewLayout: trendCollectionViewFlowLayout())
        view.register(TrendingCollectionViewCell.self,
                      forCellWithReuseIdentifier: TrendingCollectionViewCell.id)
        view.showsHorizontalScrollIndicator = false
        return view
    }()
    
    func showContens(data: [PresentItemEntity]) {
        Observable<[PresentItemEntity]>.just(data)
            .bind(to: trendingCollectionView
                .rx
                .items(cellIdentifier: TrendingCollectionViewCell.id,
                       cellType: TrendingCollectionViewCell.self)) { (item, element, cell) in
                cell.showContents(index: item, data: element)
            }
                       .disposed(by: disposeBag)
        
        
        trendingCollectionView
            .rx
            .modelSelected(PresentItemEntity.self)
            .bind(with: self) { owner, value in
                owner.itemDidSelect?(value.id)
            }
            .disposed(by: disposeBag)
        
    }
    
    override func configure() {
        super.configure()
        contentView.backgroundColor = UIColor(hexCode: ColorHexCode.lightBlue.colorCode)
        [
            trendingCollectionView
        ].forEach { contentView.addSubview($0) }
        
    }
    
    override func setConstraints() {
        trendingCollectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalTo(200)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        trendingCollectionView.reloadData()
        disposeBag = DisposeBag()
    }
}
