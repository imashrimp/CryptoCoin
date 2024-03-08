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
    
    private let cellTitleLabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 20, weight: .heavy)
        return view
    }()
    
    private let trendingCollectionView = {
        let view = UICollectionView(frame: .zero,
                                    collectionViewLayout: trendCollectionViewFlowLayout())
        view.register(TrendingCollectionViewCell.self,
                      forCellWithReuseIdentifier: TrendingCollectionViewCell.id)
        view.showsHorizontalScrollIndicator = false
        view.decelerationRate = .fast
        return view
    }()
    
    func showContents(data: TrendEntity) {
        
        cellTitleLabel.text = data.sectionTitle
        
        Observable<[PresentItemEntity]>.just(data.data)
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
        trendingCollectionView.delegate = self
        
        contentView.backgroundColor = UIColor(hexCode: ColorHexCode.white.colorCode)
        [
            cellTitleLabel,
            trendingCollectionView
        ].forEach { contentView.addSubview($0) }
    }
    
    override func setConstraints() {
        cellTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
        
        trendingCollectionView.snp.makeConstraints {
            $0.top.equalTo(cellTitleLabel.snp.bottom).offset(8)
            $0.horizontalEdges.bottom.equalToSuperview()
            $0.height.equalTo(200)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        trendingCollectionView.reloadData()
        disposeBag = DisposeBag()
    }
    
}

extension TrendingTableViewCell: UICollectionViewDelegate {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        guard let layout = self.trendingCollectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        
        let cellWidthIncludingSpacing = layout.itemSize.width + layout.minimumLineSpacing
        
        let estimatedIndex = scrollView.contentOffset.x / cellWidthIncludingSpacing
        let index: Int
        if velocity.x > 0 {
            index = Int(ceil(estimatedIndex))
        } else if velocity.x < 0 {
            index = Int(floor(estimatedIndex))
        } else {
            index = Int(round(estimatedIndex))
        }
        
        targetContentOffset.pointee = CGPoint(x: CGFloat(index) * cellWidthIncludingSpacing, y: 0)
    }
}
