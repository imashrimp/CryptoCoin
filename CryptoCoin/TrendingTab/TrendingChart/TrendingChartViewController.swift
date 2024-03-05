//
//  TrendingChartViewController.swift
//  CryptoCoin
//
//  Created by 권현석 on 2/29/24.
//

import UIKit
import RxSwift
import RxCocoa
import DGCharts

final class TrendingChartViewController: BaseViewController {
    
    private let baseView = CoinChartView()
    private let viewModel: CoinChartViewModel
    
    init(viewModel: CoinChartViewModel) {
        self.viewModel = viewModel
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
        
        let coinData = PublishRelay<(AlertPresentEnum, String)>()
        
        let input = CoinChartViewModel.Input(likeButtonTapped: baseView.likeNavigationBarButton.rx.tap,
                                             alertActionTapped: coinData)
        
        viewModel.transform(input: input)
        
        let output = viewModel.output
        
        output
            .saveButtonState
            .bind(with: self) { owner, value in
                let image = value ? UIImage(systemName: ImageAsset.starFill.name) : UIImage(systemName: ImageAsset.star.name)
                owner.baseView.likeNavigationBarButton.image = image
            }
            .disposed(by: disposeBag)
        
        output
            .coinChartData
            .bind(with: self) { owner, value in
                
                let plusOrMinus = value.priceChangePercentage24H.prefix(1)
                
                if plusOrMinus == "-" {
                    owner.baseView.priceChangePercentLabel.textColor = UIColor(hexCode: ColorHexCode.blue.colorCode)
                    owner.baseView.priceChangePercentLabel.text = value.priceChangePercentage24H
                } else {
                    owner.baseView.priceChangePercentLabel.textColor = UIColor(hexCode: ColorHexCode.red.colorCode)
                    owner.baseView.priceChangePercentLabel.text = "+" + value.priceChangePercentage24H
                }
                
                owner.baseView.logoImageView.kf.setImage(with: value.image)
                owner.baseView.coinTitleLabel.text = value.name
                owner.baseView.currentPriceLabel.text = value.currentPrice
                owner.baseView.highPriceComponent.priceLabel.text = value.high24H
                owner.baseView.lowPriceComponent.priceLabel.text = value.low24H
                owner.baseView.highestPriceComponent.priceLabel.text = value.ath
                owner.baseView.lowestPriceComponent.priceLabel.text = value.atl
                owner.baseView.updateDateLabel.text = value.lastUpdated
                var lineDataEntries: [ChartDataEntry] = []
                
                for i in 0..<value.oneWeekPriceRecord.count {
                    let lineDataEntry = ChartDataEntry(x: Double(i), y: value.oneWeekPriceRecord[i])
                    lineDataEntries.append(lineDataEntry)
                }
                
                let lineChartDataSet = LineChartDataSet(entries: lineDataEntries)
                lineChartDataSet.drawCirclesEnabled = false
                lineChartDataSet.colors = [UIColor(hexCode: ColorHexCode.purple.colorCode)]
                let gradientColors = [UIColor(hexCode: ColorHexCode.purple.colorCode).cgColor, UIColor.clear.cgColor]
                let colorLocations:[CGFloat] = [1.0, 0.0]
                guard let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(),
                                                colors: gradientColors as CFArray,
                                                locations: colorLocations) else {return }
                lineChartDataSet.fill = LinearGradientFill(gradient: gradient, angle: 90)
                lineChartDataSet.drawFilledEnabled = true
                let lineChartData = LineChartData(dataSet: lineChartDataSet)
                
                owner.baseView.lineChart.data = lineChartData 
            }
            .disposed(by: disposeBag)
        
        output
            .priceChangePercentLabelTextColor
            .bind(with: self) { owner, value in
                let textColor = value ? UIColor(hexCode: ColorHexCode.red.colorCode) : UIColor(hexCode: ColorHexCode.blue.colorCode)
                owner.baseView.priceChangePercentLabel.textColor = textColor
            }
            .disposed(by: disposeBag)
        
        output
            .presentAlert
            .bind(with: self) { owner, value in
                switch value.0 {
                case .saveAlert:
                    owner.alert(
                        title: "코인을 즐겨찾기에 저장하시겠습니까?",
                        rightButtonTitle: "저장",
                        rightButtonHandler: { _ in
                            coinData.accept((AlertPresentEnum.saveAlert, value.1))
                        },
                        defaultButtonTitle: "취소")
                case .deleteAlert:
                    owner.alert(
                        title: "코인을 즐겨찾기에서 삭제하시겠습니까?",
                        rightButtonTitle: "삭제",
                        rightButtonStyle: .destructive,
                        rightButtonHandler: { _ in
                            coinData.accept((AlertPresentEnum.deleteAlert, value.1))
                        },
                        defaultButtonTitle: "취소")
                case .overLimit:
                    owner.alert(
                        title: "코인 즐겨찾기는 최대 10개까지 가능합니다",
                        rightButtonTitle: "확인",
                        rightButtonStyle: .default)
                }
            }
            .disposed(by: disposeBag)
    }
    
    override func configure() {
        self.navigationController?.navigationBar.tintColor = UIColor(hexCode: ColorHexCode.purple.colorCode)
        self.navigationItem.rightBarButtonItem = baseView.likeNavigationBarButton
    }
}
