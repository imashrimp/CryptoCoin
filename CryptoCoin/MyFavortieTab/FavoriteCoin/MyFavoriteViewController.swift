//
//  MyFavoriteViewController.swift
//  CryptoCoin
//
//  Created by 권현석 on 2/26/24.
//

import UIKit
import RxSwift
import RxCocoa

final class MyFavoriteViewController: BaseViewController {
    
    private let baseView = MyFavoriteView()
    private let favoriteCoinViewModel: MyFavoriteViewModel
    
    init(favoriteCoinViewModel: MyFavoriteViewModel) {
        self.favoriteCoinViewModel = favoriteCoinViewModel
        super.init()
    }
    
    override func loadView() {
        self.view = baseView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    private func bind() {
        
        let updateFavoriteCoinList = PublishRelay<Void>()
        
        let input = MyFavoriteViewModel.Input(coinDidSelected: baseView.favoriteCoinCollectionView.rx.modelSelected(PresentItemEntity.self), 
                                              updateFavoriteCoinList: updateFavoriteCoinList)
        
        favoriteCoinViewModel.transform(input: input)
        
        let output = favoriteCoinViewModel.output
        
        output
            .backgroundViewState
            .bind(with: self) { owner, value in
                switch value {
                case .networkDisconnect:
                    owner.baseView.favoriteCoinCollectionView.backgroundView = BackgroundView(
                        message: "저장된 코인을 불러오지 못했습니다",
                        buttonHidden: false,
                        retrtyButtonTapped: {
                        }
                    )
                case .connectedWithoutData:
                    owner.baseView.favoriteCoinCollectionView.backgroundView = BackgroundView(
                        message: "저장된 코인이 없습니다"
                    )
                case .connectedWithData:
                    owner.baseView.favoriteCoinCollectionView.backgroundView = nil
                }
            }
            .disposed(by: disposeBag)
        
        output
            .favoriteCoinArr
            .bind(to: baseView
                .favoriteCoinCollectionView
                .rx
                .items(cellIdentifier: FavoriteCollectionViewCell.id,
                       cellType: FavoriteCollectionViewCell.self)) { (item, element, cell) in
                cell.showContents(data: element)
            }
                       .disposed(by: disposeBag)
        
        output
            .selectedCoinId
            .bind(with: self) { owner, value in
                let backButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
                owner.navigationItem.backBarButtonItem = backButtonItem
                
                let viewModel = FavoriteCoinChartViewModel(coinID: value)
                viewModel.updateFavoriteCoinList = {
                    updateFavoriteCoinList.accept(())
                }
                
                owner.navigationController?.pushViewController(FavoriteCoinChartViewController(viewModel: viewModel),
                                                               animated: true)
            }
            .disposed(by: disposeBag)
    }
}
