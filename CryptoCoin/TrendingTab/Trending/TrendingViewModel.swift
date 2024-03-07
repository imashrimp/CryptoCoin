//
//  TrendingViewModel.swift
//  CryptoCoin
//
//  Created by 권현석 on 2/28/24.
//

import Foundation
import RxSwift
import RxCocoa

final class TrendingViewModel {
    
    private let disposeBag = DisposeBag()
    private let repository = CoinRepository()
    
    private let savedCoinArr = BehaviorSubject<[SavedCoinEntity]>(value: [])
    
    let output = Output()
    
    struct Input {
        let itemDidSelect: PublishRelay<(String)>
        let updateFavoriteCoinList: PublishRelay<Void>
        let retryButtonTapped: PublishRelay<Void>
    }
    
    struct Output {
        let favoriteAndTrendItems = PublishRelay<[[PresentItemEntity]]>()
        let tableViewBackgroundViewState = PublishRelay<BackgroundViewState>()
        let presentData = BehaviorRelay<[TrendEntity]>(value: [])
        let pushToChart = PublishRelay<String>()
        let networkError = PublishSubject<String>()
        let networkStatus = PublishRelay<NetworkStatusType>()
    }
    
    init(coinArr: [SavedCoinEntity]) {
        self.savedCoinArr.onNext(coinArr)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateCoinListNoti),
                                               name: NSNotification.Name(NotificationName.searchViewNoti.rawValue),
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateCoinListNoti),
                                               name: NSNotification.Name(NotificationName.favoriteChartViewNoti.rawValue),
                                               object: nil)
    }
    
    func transform(input: Input) {
        
        savedCoinArr
            .filter { $0.count >= 2 }
            .map { $0.map { $0.coinID}.joined(separator: ",") }
            .map { FavoriteCoinsRequestModel(vs_currency: "krw", ids: $0) }
            .flatMap { NetworkManager.getFavoriteCoinArr(query: $0) }
            .bind(with: self) { owner, savedCoins in
                switch savedCoins {
                case .success(let data):
                    var result = [
                        TrendEntity(sectionTitle: "My Favorite",
                                    data: data)
                    ]
                    let trendResult = NetworkManager.getTrendingCoinList().share()
                    trendResult
                        .bind(with: self) { owner, value in
                            switch value {
                            case .success(let data):
                                result.append(contentsOf: data)
                                owner.output.presentData.accept(result)
                            case .failure(let error):
                                owner.output.networkError.onNext(error.description)
                            }
                        }
                        .disposed(by: owner.disposeBag)
                    
                case .failure(let error):
                    owner.output.networkError.onNext(error.description)
                }
            }
            .disposed(by: disposeBag)
        
        
        savedCoinArr
            .filter { $0.count < 2 }
            .bind(with: self) { owner, _ in
                let trendResult = NetworkManager.getTrendingCoinList().share()
                trendResult
                    .bind(with: self) { owner, value in
                        switch value {
                        case .success(let data):
                            owner.output.presentData.accept(data)
                            if data.isEmpty {
                                owner.output.tableViewBackgroundViewState.accept(.connectedWithoutData)
                            } else {
                                owner.output.tableViewBackgroundViewState.accept(.connectedWithData)
                            }
                        case .failure(let error):
                            owner.output.networkError.onNext(error.description)
                        }
                    }
                    .disposed(by: owner.disposeBag)
            }
            .disposed(by: disposeBag)
        
        input
            .itemDidSelect
            .filter { !$0.isEmpty }
            .bind(with: self) { owner, coinId in
                owner.output.pushToChart.accept(coinId)
            }
            .disposed(by: disposeBag)
        
        input
            .updateFavoriteCoinList
            .bind(with: self) { owner, _ in
                guard let savedCoinList = owner.repository?.readSavedCryptoCoinList() else { return }
                owner.savedCoinArr.onNext(savedCoinList)
            }
            .disposed(by: disposeBag)
        
                NetworkMonitor.shared.networkConnected
                    .compactMap { $0 }
                    .filter { $0 == false }
                    .bind(with: self) { owner, value in
                        owner.output.presentData.accept([])
                        owner.output.tableViewBackgroundViewState.accept(.networkDisconnect)
                    }
                    .disposed(by: disposeBag)
        
        input
            .retryButtonTapped
            .bind(with: self) { owner, value in
                guard let savedCoins = owner.repository?.readSavedCryptoCoinList() else { return }
                owner.savedCoinArr.onNext(savedCoins)
            }
            .disposed(by: disposeBag)
    }
    
    @objc private func updateCoinListNoti() {
        guard let newCoinArr = repository?.readSavedCryptoCoinList() else { return }
        
        savedCoinArr.onNext(newCoinArr)
    }
}
