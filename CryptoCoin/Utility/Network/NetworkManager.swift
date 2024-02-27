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
                .responseDecodable(of: [CoinChartResponseModel].self) { response in
                    switch response.result {
                    case .success(let value):
                        print(value)
                        if  let coinData = value.first,
                            let imageURL = URL(string: coinData.image),
                            let updateDate = coinData.lastUpdated.toDate() {
                            let result = CoinChartEntity(
                                id: coinData.id,
                                symbol: coinData.symbol,
                                name: coinData.name,
                                image: imageURL,
                                currentPrice: coinData.currentPrice.convertToDecimal(),
                                high24H: coinData.high24H.decimal(),
                                low24H: coinData.low24H.decimal(),
                                priceChangePercentage24H: coinData.priceChangePercentage24H.convertToPercentage(),
                                ath: coinData.ath.decimal(),
                                atl: coinData.atl.decimal(),
                                lastUpdated: updateDate.toString(format: "M/dd HH:mm:ss") + " 업데이트",
                                oneWeekPriceRecord: coinData.sparklineIn7D.price
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
    
    static func getFavoriteCoinArr(query: FavoriteCoinsRequestModel) -> Observable<[FavoriteCoinEntity]> {
        
        return Observable<[FavoriteCoinEntity]>.create { favoriteCoinArr in
            API.session.request(CryptoCoinListTarget.favoriteCoins(query))
                .validate(statusCode: 200...299)
                .responseDecodable(of: [FavoriteCoinInfoResponseModel].self) { response in
                    switch response.result {
                    case .success(let value):
                        let result = value.map {
                            FavoriteCoinEntity(
                                id: $0.id,
                                currency: $0.symbol,
                                name: $0.name,
                                image: $0.image,
                                currentPrice: $0.currentPrice.convertToDecimal(),
                                priceChangePercentage24H: $0.priceChangePercentage24H.convertToPercentage()
                            )
                        }
                        favoriteCoinArr.onNext(result)
                        
                    case .failure(let error):
                        favoriteCoinArr.onError(error)
                    }
                }
            return Disposables.create()
        }
    }
}

