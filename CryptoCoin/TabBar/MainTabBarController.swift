//
//  MainTabBarController.swift
//  CryptoCoin
//
//  Created by 권현석 on 2/26/24.
//

import UIKit

final class MainTabBarController: UITabBarController, UITabBarControllerDelegate {

    private let viewModel = MainTabBarViewModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        self.tabBar.tintColor = UIColor(hexCode: ColorHexCode.purple.colorCode)
        self.tabBar.barTintColor = UIColor(hexCode: ColorHexCode.gray.colorCode)
        self.delegate = self
        
        let trendingVC = UINavigationController(rootViewController: TrendingCoinViewController())
        let coinSearchVC = UINavigationController(rootViewController: CoinSearchViewController(viewModel: SearchCoinViewModel()))
        let myFavoriteVC = UINavigationController(rootViewController: MyFavoriteViewController(favoriteCoinViewModel: MyFavoriteViewModel(coinArr: viewModel.output.savedCoinArr.value)))
        let myProfileVC = UINavigationController(rootViewController: MyProfileViewController())
        
        
        let trendingTabItem = UITabBarItem(title: "",
                                           image: UIImage(systemName: ImageAsset.chart.name),
                                           tag: 0)
        let searchTabItem = UITabBarItem(title: "",
                                         image: UIImage(systemName: ImageAsset.search.name),
                                         tag: 0)
        let myFavoriteTabItem = UITabBarItem(title: "",
                                             image: UIImage(systemName: ImageAsset.wallet.name),
                                             tag: 0)
        let myProfileTabItem = UITabBarItem(title: "",
                                            image: UIImage(systemName: ImageAsset.person.name),
                                            tag: 0)
        
        trendingVC.tabBarItem = trendingTabItem
        coinSearchVC.tabBarItem = searchTabItem
        myFavoriteVC.tabBarItem = myFavoriteTabItem
        myProfileVC.tabBarItem = myProfileTabItem
        
        
        
        self.viewControllers = [trendingVC,
                                coinSearchVC,
                                myFavoriteVC,
                                myProfileVC]
    }
}
