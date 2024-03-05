//
//  TrendingCoinViewController.swift
//  CryptoCoin
//
//  Created by 권현석 on 2/26/24.
//

import UIKit
import RxSwift
import RxCocoa

final class TrendingViewController: BaseViewController {
    
    private let itemDidSelect = PublishRelay<String>()
    
    private let baseView = TrendingView()
    private let viewModel: TrendingViewModel
    
    init(viewModel: TrendingViewModel) {
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
        
        let updateFavoriteCoinList = PublishRelay<Void>()
        
        let input = TrendingViewModel.Input(itemDidSelect: itemDidSelect,
                                            updateFavoriteCoinList: updateFavoriteCoinList)
        
        viewModel.transform(input: input)
        
        let output = viewModel.output
        
        output
            .presentData
            .bind(to: baseView.trendingTableView.rx.items) { (tableView, row, data) -> UITableViewCell in
                
                if data.sectionTitle == "My Favorite" {
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: FavoriteSectionTableViewCell.id) as? FavoriteSectionTableViewCell else {
                        return UITableViewCell()
                    }
                    cell.showContents(data: data)
                    cell.coinItemDidSelect = { [weak self] coinId in
                        self?.itemDidSelect.accept(coinId)
                    }
                    return cell
                } else {
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: TrendingTableViewCell.id) as? TrendingTableViewCell else {
                        return UITableViewCell()
                    }
                    
                    cell.showContents(data: data)
                    cell.itemDidSelect = { [weak self] coinId in
                        self?.itemDidSelect.accept(coinId)
                    }
                    return cell
                }
            }
            .disposed(by: disposeBag)
        
        output
            .pushToChart
            .bind(with: self) { owner, coinId in
                let backButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
                owner.navigationItem.backBarButtonItem = backButtonItem
                
                let viewModel = CoinChartViewModel(coinId: coinId)
                viewModel.updateFavoriteCoinList = {
                    updateFavoriteCoinList.accept(())
                }
                owner.navigationController?.pushViewController(TrendingChartViewController(viewModel: viewModel),
                                                               animated: true)
            }
            .disposed(by: disposeBag)
        
        output
            .networkError
            .bind(with: self) { owner, value in
                owner.alert(title: value,
                            rightButtonTitle: "확인")
            }
            .disposed(by: disposeBag)
        
        //        output
        //            .networkStatus
        //            .filter { $0 == false }
        //            .bind(with: self) { owner, _ in
        //                owner.alert( title: "네트워크 연결 상태가 불안합니다.\n앱 종료 후 다시 실행해주세요.",
        //                             rightButtonTitle: "확인",
        //                             rightButtonStyle: .default)
        //            }
        //            .disposed(by: disposeBag)
        
        output
            .networkStatus
            .filter { $0 == .disconnect }
            .bind(with: self) { owner, value in
                owner.alert( title: "네트워크 연결 상태가 불안합니다.\n앱 종료 후 다시 실행해주세요.",
                             rightButtonTitle: "확인",
                             rightButtonStyle: .default)
            }
            .disposed(by: disposeBag)
    }
}
