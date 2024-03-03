//
//  SearchCoinViewModel.swift
//  CryptoCoin
//
//  Created by 권현석 on 2/26/24.
//

import Foundation
import RxSwift
import RxCocoa

final class SearchCoinViewModel {
    
    private let coinSearchRepository = CoinRepository()
    private let disposeBag = DisposeBag()
    
    let output = Output()
    
    struct Input {
        let searchWord: ControlProperty<String>
        let searchButtonTapped: ControlEvent<Void>
        let likeButtonTapped: PublishRelay<SearchedCoinEntity>
        let alertActionTapped: PublishRelay<(AlertPresentEnum, SearchedCoinEntity)>
        let cellDidSelected: ControlEvent<SearchedCoinEntity>
        let updateFavoriteCoinList: PublishRelay<Void>
    }
    
    struct Output {
        let searchedCoinList = BehaviorSubject<[SearchedCoinEntity]>(value: [])
        let searchKeyword = BehaviorRelay<String>(value: "")
        let transitionToCoinChartView = PublishSubject<String>()
        let likeButtonTappedCoin = PublishSubject<Void>()
        let presentAlert = PublishRelay<(AlertPresentEnum, SearchedCoinEntity)>()
        let savedCoinIds = BehaviorRelay<[String]>(value: [])
        let updateSavedCoinlist = BehaviorRelay<Void?>(value: nil)
    }
    
    struct entityModel {
        let data: [SearchedCoinEntity]
        let stringtext: String
    }
    
    func transform(input: Input) {
        
        let searchKeyword = BehaviorRelay(value: "")
        let networkResult = PublishRelay<[SearchedCoinEntity]>()
        input.searchButtonTapped
            .withLatestFrom(input.searchWord)
            .distinctUntilChanged()
            .map{
                searchKeyword.accept($0)
                return CoinSearchRequestModel(query: $0)
            }
            .flatMap { NetworkManager.getSearchedCoinList(query: $0) }
            .bind(with: self) { owner, value in
                
                guard let savedCoinList = owner.coinSearchRepository?.readSavedCryptoCoinList() else { return }
                let coinIds = savedCoinList.map { $0.coinID }
                
                owner.output.savedCoinIds.accept(coinIds)
                networkResult.accept(value)
            }
            .disposed(by: disposeBag)
        
        
        searchKeyword.bind(with: self) { owner, value in
            owner.output.searchKeyword.accept(value)
        }
        .disposed(by: disposeBag)
        
        networkResult.bind(with: self) { owner, value in
            owner.output.searchedCoinList.onNext(value)
        }
        .disposed(by: disposeBag)
        
        input
            .likeButtonTapped
            .bind(with: self) { owner, value in
                guard let saveState = owner.coinSearchRepository?.checkCoinSaveState(coinId: value.id),
                      let savedCoinCount = owner.coinSearchRepository?.readSavedCryptoCoinList().count else { return }
                
                if saveState {
                    owner.output.presentAlert.accept((AlertPresentEnum.deleteAlert, value))
                } else {
                    if savedCoinCount < 10 {
                        owner.output.presentAlert.accept((AlertPresentEnum.saveAlert, value))
                    } else {
                        owner.output.presentAlert.accept((AlertPresentEnum.overLimit, value))
                    }
                }
            }
            .disposed(by: disposeBag)
        
        input
            .alertActionTapped
            .bind(with: self) { owner, value in
                switch value.0 {
                case .saveAlert:
                    owner.coinSearchRepository?.saveCryptoCoin(id: value.1.id)
                    owner.output.likeButtonTappedCoin.onNext(())
                    NotificationCenter.default.post(name: NSNotification.Name(NotificationName.searchViewNoti.rawValue),
                                                    object: nil)
                case .deleteAlert:
                    owner.coinSearchRepository?.deleteCryptoCoin(id: value.1.id)
                    owner.output.likeButtonTappedCoin.onNext(())
                    NotificationCenter.default.post(name: NSNotification.Name(NotificationName.searchViewNoti.rawValue),
                                                    object: nil)
                case .overLimit:
                    return
                }
            }
            .disposed(by: disposeBag)
        
        input
            .cellDidSelected
            .bind(with: self) { owner, coinData in
                owner.output.transitionToCoinChartView.onNext(coinData.id)
            }
            .disposed(by: disposeBag)
        
        input
            .updateFavoriteCoinList
            .bind(with: self) { owner, _ in
                guard let savedCoinArr = owner.coinSearchRepository?.readSavedCryptoCoinList() else { return }
                let coinIds = savedCoinArr.map{ $0.coinID }
                owner.output.savedCoinIds.accept(coinIds)
                owner.output.updateSavedCoinlist.accept(())
            }
            .disposed(by: disposeBag)
    }
    
}
