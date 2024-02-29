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
        
        let input = MyFavoriteViewModel.Input(coinDidSelected: baseView.favoriteCoinCollectionView.rx.modelSelected(FavoriteCoinEntity.self))
        
        favoriteCoinViewModel.transform(input: input)
        
        let output = favoriteCoinViewModel.output
        
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
                owner.navigationController?.pushViewController(FavoriteCoinChartViewController(viewModel: FavoriteCoinChartViewModel(coinID: value)),
                                                               animated: true)
            }
            .disposed(by: disposeBag)
    }
}
