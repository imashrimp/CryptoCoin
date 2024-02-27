//
//  CoinChartViewController.swift
//  CryptoCoin
//
//  Created by 권현석 on 2/26/24.
//

import UIKit
import Kingfisher
import DGCharts

final class CoinChartViewController: BaseViewController {
    
    private let viewModel: CoinCharViewModel
    private let baseView = CoinChartView()
    
    init(viewModel: CoinCharViewModel) {
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
        let input = CoinCharViewModel.Input()
        
        viewModel.transform(input: input)
        
        let output = viewModel.output
        
        output
            .coinChartData
            .bind(with: self) { owner, value in
                owner.baseView.logoImageView.kf.setImage(with: value.image)
                owner.baseView.coinTitleLabel.text = value.name
                owner.baseView.currentPriceLabel.text = value.currentPrice
                owner.baseView.priceChangePercentLabel.text = value.priceChangePercentage24H
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
    }
}
