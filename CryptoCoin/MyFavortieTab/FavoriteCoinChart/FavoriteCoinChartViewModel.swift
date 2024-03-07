//
//  FavoriteCoinCharViewModel.swift
//  CryptoCoin
//
//  Created by 권현석 on 2/27/24.
//

import Foundation
import RxSwift
import RxCocoa

final class FavoriteCoinChartViewModel {
    
    var updateFavoriteCoinList: (() -> Void)?
    
    private let repository = CoinRepository()
    private let disposeBag = DisposeBag()
    
    private let coinId = BehaviorRelay<String?>(value: nil)
    
    let output = Output()
    
    struct Input {
        let likeButtonTapped: ControlEvent<Void>
        let alertActionTapped: PublishRelay<(AlertPresentEnum, String)>
        let updateChartData: ControlEvent<Void>
    }
    
    struct Output {
        let coinChartData = PublishSubject<CoinChartEntity>()
        let saveButtonState = PublishRelay<Bool>()
        let priceChangePercentLabelTextColor = PublishSubject<Bool>()
        let presentAlert = PublishRelay<(AlertPresentEnum, String)>()
        let networkError = PublishSubject<String>()
        let networkState = PublishRelay<BackgroundViewState>()
    }
    
    init(coinID: String) {
        self.coinId.accept(coinID)
        
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
        coinId
            .compactMap { $0 }
            .filter { !$0.isEmpty }
            .map { return CoinChartRequestModel(vs_currency: "krw", ids: $0, sparkline: "true" ) }
            .flatMap { NetworkManager.getCoinChartInfo(query: $0) }
            .bind(with: self) { owner, value in
                switch value {
                case .success(let data):
                    guard let coinSaved = owner.repository?.checkCoinSaveState(coinId: data.id) else { return }
                    owner.output.saveButtonState.accept(coinSaved)
                    owner.output.coinChartData.onNext(data)
                    owner.output.networkState.accept(.connectedWithData)
                    
                    let plusOrMinus = data.priceChangePercentage24H.prefix(1)
                    
                    if plusOrMinus == "-" {
                        owner.output.priceChangePercentLabelTextColor.onNext(false)
                    } else {
                        owner.output.priceChangePercentLabelTextColor.onNext(true)
                    }
                case .failure(let error):
                    owner.output.networkError.onNext(error.description)
                }
            }
            .disposed(by: disposeBag)
        
        input
            .likeButtonTapped
            .withLatestFrom(coinId)
            .bind(with: self) { owner, coinId in
                guard let coinId,
                      let saveState = owner.repository?.checkCoinSaveState(coinId: coinId),
                      let savedCoinCount = owner.repository?.readSavedCryptoCoinList().count else { return }
                
                if saveState {
                    owner.output.presentAlert.accept((AlertPresentEnum.deleteAlert, coinId))
                } else {
                    if savedCoinCount < 10 {
                        owner.output.presentAlert.accept((AlertPresentEnum.saveAlert, coinId))
                    } else {
                        owner.output.presentAlert.accept((AlertPresentEnum.overLimit, coinId))
                    }
                }
            }
            .disposed(by: disposeBag)
        
        input
            .alertActionTapped
            .bind(with: self) { owner, value in
                switch value.0 {
                case .saveAlert:
                    owner.repository?.saveCryptoCoin(id: value.1)
                    owner.output.saveButtonState.accept(true)
                    owner.updateFavoriteCoinList?()
                    NotificationCenter.default.post(name: NSNotification.Name(NotificationName.favoriteChartViewNoti.rawValue),
                                                    object: self,
                                                    userInfo: ["coinId": value.1])
                case .deleteAlert:
                    owner.repository?.deleteCryptoCoin(id: value.1)
                    owner.output.saveButtonState.accept(false)
                    owner.updateFavoriteCoinList?()
                    NotificationCenter.default.post(name: NSNotification.Name(NotificationName.favoriteChartViewNoti.rawValue),
                                                    object: self,
                                                    userInfo: ["coinId": value.1])
                case .overLimit:
                    return
                }
            }
            .disposed(by: disposeBag)
        
        NetworkMonitor.shared.networkConnected
            .compactMap { $0 }
            .filter { $0 == false }
            .bind(with: self) { owner, _ in
                owner.output.networkState.accept(.networkDisconnect)
            }
            .disposed(by: disposeBag)
        
        input
            .updateChartData
            .withLatestFrom(coinId)
            .compactMap { $0 }
            .bind(with: self) { owner, value in
                owner.coinId.accept(value)
            }
            .disposed(by: disposeBag)
    }
    
    @objc private func updateCoinListNoti(_ notification: Notification) {
        guard let updatedCoinId = notification.userInfo?["coinId"] as? String,
              let coinIdOnScreen = coinId.value else { return }
        if updatedCoinId == coinIdOnScreen {
            coinId.accept(updatedCoinId)
        }
    }
}
