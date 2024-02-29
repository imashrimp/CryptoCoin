//
//  NetworkManager.swift
//  CryptoCoin
//
//  Created by 권현석 on 2/26/24.
//

import Foundation
import RxSwift

struct NetworkManager {
    
    static func getTrendingCoinList() -> Observable<[TrendEntity]> {
        
        return Observable<[TrendEntity]>.create { trendData in
            API.session.request(CryptoCoinListTarget.trending)
                .validate(statusCode: 200...299)
                .responseDecodable(of: TrendingCoinResponseModel.self) { response in
                    switch response.result {
                    case .success(let value):

                        let trendCoinArr = value.coins.map {
                            PresentItemEntity(
                                id: $0.item.id,
                                name: $0.item.name,
                                currency: $0.item.symbol,
                                thumbnail: $0.item.thumb,
                                price: $0.item.data.price,
                                priceChangePercent24H: $0.item.data.priceChangePercentage24H["krw"]?.convertToPercentage() ?? "0.0%"
                            )
                        }
                        
                        let trendCoinPresentData = TrendEntity(
                            sectionTitle: "Top 15 Coin",
                            data: trendCoinArr
                        )
                        
                        let trendNFTArr = value.nfts.map {
                            PresentItemEntity(
                                id: $0.id,
                                name: $0.name,
                                currency: $0.symbol,
                                thumbnail: $0.thumb,
                                price: $0.data.floorPrice,
                                priceChangePercent24H: $0.data.floorPriceInUsd24HPercentageChange.convertToPercent()
                            )
                        }
                        
                        let trendNFTPresentData = TrendEntity(
                            sectionTitle: "Top 7 NFT",
                            data: trendNFTArr
                        )
                        
                        let result: [TrendEntity] = [trendCoinPresentData, trendNFTPresentData]

                        trendData.onNext(result)
                    case .failure(let error):
                        trendData.onError(error)
                    }
                }
            return Disposables.create()
        }
    }
    
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
                                high24H: coinData.high24H.convertToDecimal(),
                                low24H: coinData.low24H.convertToDecimal(),
                                priceChangePercentage24H: coinData.priceChangePercentage24H.convertToPercentage(),
                                ath: coinData.ath.convertToDecimal(),
                                atl: coinData.atl.convertToDecimal(),
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
    
    static func getFavoriteCoinArr(query: FavoriteCoinsRequestModel) -> Observable<[PresentItemEntity]> {
        
        return Observable<[PresentItemEntity]>.create { favoriteCoinArr in
            API.session.request(CryptoCoinListTarget.favoriteCoins(query))
                .validate(statusCode: 200...299)
                .responseDecodable(of: [FavoriteCoinInfoResponseModel].self) { response in
                    switch response.result {
                    case .success(let value):
                        let result = value.map {
                            PresentItemEntity(
                                id: $0.id,
                                name: $0.name,
                                currency: $0.symbol,
                                thumbnail: $0.image,
                                price: $0.currentPrice.convertToDecimal(),
                                priceChangePercent24H: $0.priceChangePercentage24H.convertToPercentage()
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

