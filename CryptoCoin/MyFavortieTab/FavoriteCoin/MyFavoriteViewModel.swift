//
//  MyFavoriteViewModel.swift
//  CryptoCoin
//
//  Created by 권현석 on 2/27/24.
//

import Foundation
import RxSwift
import RxCocoa

final class MyFavoriteViewModel {
    
    private let disposeBag = DisposeBag()
    private let repository = CoinRepository()
    
    private let savedCoinArr = BehaviorRelay<[SavedCoinEntity]>(value: [])
    
    let output = Output()
    
    struct Input {
        let coinDidSelected: ControlEvent<PresentItemEntity>
        let updateFavoriteCoinList: PublishRelay<Void>
    }
    
    struct Output {
        let favoriteCoinArr = PublishRelay<[PresentItemEntity]>()
        let selectedCoinId = PublishRelay<String>()
        let networkError = PublishSubject<String>()
    }
    
    init(coinArr: [SavedCoinEntity]) {
        self.savedCoinArr.accept(coinArr)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateCoinListNoti),
                                               name: NSNotification.Name(NotificationName.searchViewNoti.rawValue),
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateCoinListNoti),
                                               name: NSNotification.Name(NotificationName.chartviewNoti.rawValue),
                                               object: nil)
    }
    
    func transform(input: Input) {
        
        let coinID = BehaviorRelay<String?>(value: nil)
        
        savedCoinArr.bind { value in
            let coinIDs = value.map { $0.coinID }.joined(separator: ",")
            coinID.accept(coinIDs)
        }
        .disposed(by: disposeBag)
        
        coinID
            .map { 
                guard let coinIds = $0 else { return "" }
                return coinIds
            }
            .map { return FavoriteCoinsRequestModel(vs_currency: "krw", ids: $0) }
            .flatMap { NetworkManager.getFavoriteCoinArr(query: $0) }
            .bind(with: self) { owner, value in
                switch value {
                case .success(let data):
                    owner.output.favoriteCoinArr.accept(data)
                case .failure(let error):
                    owner.output.networkError.onNext(error.description)
                }
            }
            .disposed(by: disposeBag)
        
        input
            .coinDidSelected
            .bind(with: self) { owner, value in
                owner.output.selectedCoinId.accept(value.id)
            }
            .disposed(by: disposeBag)
        
        input
            .updateFavoriteCoinList
            .bind(with: self) { owner, _ in
                guard let savedCoinList = owner.repository?.readSavedCryptoCoinList() else { return }
                let coinIDs = savedCoinList.map { $0.coinID }.joined(separator: ",")
                coinID.accept(coinIDs)
            }
            .disposed(by: disposeBag)
    }
    
    @objc private func updateCoinListNoti() {
        guard let newCoinArr = repository?.readSavedCryptoCoinList() else { return }
        savedCoinArr.accept(newCoinArr)
    }
}
