//
//  MyFavoriteViewController.swift
//  CryptoCoin
//
//  Created by 권현석 on 2/26/24.
//

import UIKit

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
        let input = MyFavoriteViewModel.Input()
        
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
    }
}
