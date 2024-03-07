//
//  CoinChartView.swift
//  CryptoCoin
//
//  Created by 권현석 on 2/26/24.
//

import UIKit
import DGCharts

final class CoinChartView: BaseView {
    
    let likeNavigationBarButton = {
        let view = UIBarButtonItem(image: UIImage(systemName: ImageAsset.star.name),
                                   style: .plain,
                                   target: nil,
                                   action: nil)
        return view
    }()
    
    let logoImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    let coinTitleLabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 38,
                                weight: .bold)
        return view
    }()
    
    let currentPriceLabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 38,
                                weight: .bold)
        return view
    }()
    
    let priceChangePercentLabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 17, weight: .medium)
        return view
    }()
    
    let dayLabel = {
        let view = UILabel()
        view.text = "Today"
        view.textColor = UIColor(hexCode: ColorHexCode.gray.colorCode)
        view.font = .systemFont(ofSize: 17, weight: .medium)
        return view
    }()
    
    let priceInfoHorizontalStakView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.spacing = 20
        return view
    }()
    
    let highPriceStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 16
        return view
    }()
    
    let lowPriceStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 16
        return view
    }()
    
    let highPriceComponent = {
        let view = CoinChartPriceComponent()
        view.priceTypeTitleLabel.textColor = UIColor(hexCode: ColorHexCode.red.colorCode)
        view.priceTypeTitleLabel.font = .systemFont(ofSize: 17, weight: .medium)
        view.priceLabel.textColor = UIColor(hexCode: ColorHexCode.gray.colorCode)
        view.priceLabel.font = .systemFont(ofSize: 17, weight: .medium)
        view.priceTypeTitleLabel.text = "고가"
        return view
    }()
    
    let lowPriceComponent = {
        let view = CoinChartPriceComponent()
        view.priceTypeTitleLabel.textColor = UIColor(hexCode: ColorHexCode.blue.colorCode)
        view.priceTypeTitleLabel.font = .systemFont(ofSize: 17, weight: .medium)
        view.priceLabel.textColor = UIColor(hexCode: ColorHexCode.gray.colorCode)
        view.priceLabel.font = .systemFont(ofSize: 17, weight: .medium)
        view.priceTypeTitleLabel.text = "저가"
        return view
    }()
    
    let highestPriceComponent = {
        let view = CoinChartPriceComponent()
        view.priceTypeTitleLabel.textColor = UIColor(hexCode: ColorHexCode.red.colorCode)
        view.priceTypeTitleLabel.font = .systemFont(ofSize: 17, weight: .medium)
        view.priceLabel.textColor = UIColor(hexCode: ColorHexCode.gray.colorCode)
        view.priceLabel.font = .systemFont(ofSize: 17, weight: .medium)
        view.priceTypeTitleLabel.text = "신고점"
        return view
    }()
    
    let lowestPriceComponent = {
        let view = CoinChartPriceComponent()
        view.priceTypeTitleLabel.textColor = UIColor(hexCode: ColorHexCode.blue.colorCode)
        view.priceTypeTitleLabel.font = .systemFont(ofSize: 17, weight: .medium)
        view.priceLabel.textColor = UIColor(hexCode: ColorHexCode.gray.colorCode)
        view.priceLabel.font = .systemFont(ofSize: 17, weight: .medium)
        view.priceTypeTitleLabel.text = "신저점"
        return view
    }()
    
    let lineChart = {
        let view = LineChartView()
        view.noDataText = "데이터가 없습니다."
        view.noDataFont = .systemFont(ofSize: 20)
        view.legend.enabled = false
        view.rightAxis.enabled = false
        view.leftAxis.enabled = false
        view.xAxis.enabled = false
        view.borderLineWidth = 0
        view.backgroundColor = UIColor(hexCode: ColorHexCode.white.colorCode)
        return view
    }()
    
    let updateDateLabel = {
        let view = UILabel()
        view.text = "업데이트"
        view.textColor = UIColor(hexCode: ColorHexCode.gray.colorCode)
        view.font = .systemFont(ofSize: 15, weight: .medium)
        return view
    }()
    
    let badNetworkView = {
        let view = EmptyDataView(viewState: .networkDisconnect)
        view.isHidden = true
        return view
    }()
    
    override func configure() {
        super.configure()
        [
            logoImageView,
            coinTitleLabel,
            currentPriceLabel,
            priceChangePercentLabel,
            dayLabel,
            highPriceStackView,
            lowPriceStackView,
            lineChart,
            updateDateLabel,
            badNetworkView
        ].forEach { addSubview($0) }
        
        [
            highPriceComponent,
            highestPriceComponent,
        ].forEach { highPriceStackView.addArrangedSubview($0) }
        
        [
            lowPriceComponent,
            lowestPriceComponent
        ].forEach { lowPriceStackView.addArrangedSubview($0) }
    }
    
    override func setConstrinats() {
        logoImageView.snp.makeConstraints {
            $0.size.equalTo(40)
            $0.top.leading.equalTo(safeAreaLayoutGuide).offset(16)
        }
        
        coinTitleLabel.snp.makeConstraints {
            $0.centerY.equalTo(logoImageView)
            $0.leading.equalTo(logoImageView.snp.trailing).offset(8)
            $0.trailing.equalToSuperview().inset(16)
        }
        
        currentPriceLabel.snp.makeConstraints {
            $0.top.equalTo(logoImageView.snp.bottom).offset(24)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().inset(16)
        }
        
        priceChangePercentLabel.snp.makeConstraints {
            $0.top.equalTo(currentPriceLabel.snp.bottom).offset(12)
            $0.leading.equalToSuperview().offset(16)
        }
        
        dayLabel.snp.makeConstraints {
            $0.top.equalTo(priceChangePercentLabel)
            $0.leading.equalTo(priceChangePercentLabel.snp.trailing).offset(8)
            $0.trailing.lessThanOrEqualToSuperview().inset(16)
        }
        
        highPriceStackView.snp.makeConstraints {
            $0.top.equalTo(dayLabel.snp.bottom).offset(50)
            $0.leading.equalToSuperview().offset(16)
        }
        
        lowPriceStackView.snp.makeConstraints {
            $0.top.equalTo(highPriceStackView)
            $0.leading.equalTo(highPriceStackView.snp.trailing).offset(50)
            $0.trailing.lessThanOrEqualToSuperview().inset(16)
        }
        
        lineChart.snp.makeConstraints {
            $0.top.equalTo(highPriceStackView.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
        }
        
        updateDateLabel.snp.makeConstraints {
            $0.top.equalTo(lineChart.snp.bottom).offset(8)
            $0.trailing.equalToSuperview().inset(16)
            $0.bottom.equalTo(safeAreaLayoutGuide)
        }
        
        badNetworkView.snp.makeConstraints {
//            $0.edges.equalTo(safeAreaLayoutGuide)
            $0.edges.equalToSuperview()
        }
    }
}
