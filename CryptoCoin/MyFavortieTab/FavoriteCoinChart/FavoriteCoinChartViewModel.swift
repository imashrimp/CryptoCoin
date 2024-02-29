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
    
    private let coinId = BehaviorSubject<String?>(value: nil)
    
    let output = Output()
    
    struct Input {
        let likeButtonTapped: ControlEvent<Void>
        let alertActionTapped: PublishRelay<(AlertPresentEnum, String)>
    }
    
    struct Output {
        let coinChartData = PublishSubject<CoinChartEntity>()
        let saveButtonState = PublishRelay<Bool>()
        let priceChangePercentLabelTextColor = PublishSubject<Bool>()
        let presentAlert = PublishRelay<(AlertPresentEnum, String)>()
    }
    
    init(coinID: String) {
        self.coinId.onNext(coinID)
    }
    
    func transform(input: Input) {
        coinId
            .map{
                guard let coinId = $0 else { return "" }
                return coinId
            }
            .map { return CoinChartRequestModel(vs_currency: "krw", ids: $0, sparkline: "true" ) }
            .flatMap { NetworkManager.getCoinChartInfo(query: $0) }
            .bind(with: self) { owner, value in
                
                guard let coinSaved = owner.repository?.checkCoinSaveState(coinId: value.id) else { return }
                
                owner.output.saveButtonState.accept(coinSaved)
                owner.output.coinChartData.onNext(value)
                
                let plusOrMinus = value.priceChangePercentage24H.prefix(1)
                
                if plusOrMinus == "-" {
                    owner.output.priceChangePercentLabelTextColor.onNext(false)
                } else {
                    owner.output.priceChangePercentLabelTextColor.onNext(true)
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
                }            }
            .disposed(by: disposeBag)
        
        input
            .alertActionTapped
            .bind(with: self) { owner, value in
                switch value.0 {
                case .saveAlert:
                    owner.repository?.saveCryptoCoin(id: value.1)
                    owner.output.saveButtonState.accept(true)
                    owner.updateFavoriteCoinList?()
                case .deleteAlert:
                    owner.repository?.deleteCryptoCoin(id: value.1)
                    owner.output.saveButtonState.accept(false)
                    owner.updateFavoriteCoinList?()
                case .overLimit:
                    return
                }
            }
            .disposed(by: disposeBag)
    }
}
