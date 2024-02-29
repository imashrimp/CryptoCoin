//
//  TrendingCoinViewController.swift
//  CryptoCoin
//
//  Created by 권현석 on 2/26/24.
//

import UIKit
import RxSwift
import RxCocoa

final class TrendingCoinViewController: BaseViewController {

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
        baseView.trendingTableView.delegate = self
        baseView.trendingTableView.dataSource = self
        bind()
    }
    
    private func bind() {
        let input = TrendingViewModel.Input()
        
        viewModel.transform(input: input)
        
        let output = viewModel.output
        
        output
            .presentData
            .bind(with: self) { owner, _ in
                owner.baseView.trendingTableView.reloadData()
            }
            .disposed(by: disposeBag)
        
    }

}

extension TrendingCoinViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.output.presentData.value.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.output.presentData.value[section].sectionTitle
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if viewModel.output.presentData.value.count == 3 {
            if indexPath.section == 0 {
                guard 
                    let cell = tableView.dequeueReusableCell(withIdentifier: FavoriteSectionTableViewCell.id) as? FavoriteSectionTableViewCell else {
                    return UITableViewCell()
                }
                cell.showContents(data: viewModel.output.presentData.value[indexPath.row].data)
                return cell
            } else {
                guard
                    let cell = tableView.dequeueReusableCell(withIdentifier: TrendingTableViewCell.id) as? TrendingTableViewCell else { 
                    return UITableViewCell()
                }
                cell.showContens(data: viewModel.output.presentData.value[indexPath.section].data)
                return cell
            }
        } else if viewModel.output.presentData.value.count == 2 {
            guard 
                let cell = tableView.dequeueReusableCell(withIdentifier: TrendingTableViewCell.id) as? TrendingTableViewCell else {
                return UITableViewCell()
            }
            cell.showContens(data: viewModel.output.presentData.value[indexPath.section].data)
            return cell
        } else {
            return UITableViewCell()
        }
    }
}
