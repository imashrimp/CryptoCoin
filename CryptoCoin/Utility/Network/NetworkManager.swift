//
//  NetworkManager.swift
//  CryptoCoin
//
//  Created by 권현석 on 2/26/24.
//

import Foundation
import RxSwift

struct NetworkManager {
    
    static func getSearchedCoinList(query: CoinSearchRequestModel) -> Observable<[SearchedCoinEntity]> {
        
        return Observable<[SearchedCoinEntity]>.create { coinList in
            API.session.request(CryptoCoinListTarget.search(query))
                .validate(statusCode: 200...299)
                .responseDecodable(of: CoinSearchResponseModel.self) { response in
                    switch response.result {
                    case .success(let value):
                        let result = value.coins
                            .map { SearchedCoinEntity(id: $0.id,
                                                      name: $0.name,
                                                      currencyUnit: $0.symbol,
                                                      logo: $0.large) }
                        coinList.onNext(result)
                    case .failure(let error):
                        //TODO: 에러핸들링 수정 필요
                        coinList.onError(error)
                    }
                }
            
            return Disposables.create()
        }
    }
    
    static func getCoinChartInfo(query: CoinChartRequestModel) -> Observable<CoinChartEntity> {
        
        return Observable<CoinChartEntity>.create { coinChartInfo in
            API.session.request(CryptoCoinListTarget.coinChart(query))
                .validate(statusCode: 200...299)
                .responseDecodable(of: CoinChartResponseModel.self) { response in
                    switch response.result {
                    case .success(let value):
                        //TODO: 여기서 데이터 정제 다시하기
                        if let imageURL = URL(string: value.image) {
                            let result = CoinChartEntity(
                                id: value.id,
                                symbol: value.symbol,
                                name: value.name,
                                image: imageURL,
                                currentPrice: value.currentPrice,
                                high24H: value.high24H,
                                low24H: value.low24H,
                                priceChangePercentage24H: value.priceChangePercentage24H,
                                ath: value.ath,
                                atl: value.atl,
                                lastUpdated: value.lastUpdated,
                                oneWeekPriceRecord: value.sparklineIn7D.price
                            )
                            coinChartInfo.onNext(result)
                        }
                    case .failure(let error):
                        coinChartInfo.onError(error)
                    }
                    
                }
            return Disposables.create()
        }
    }
}
