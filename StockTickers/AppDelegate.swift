//
//  AppDelegate.swift
//  StockTickers
//
//  Created by mac on 28/04/2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        let newsService = NewsFeedAPI(url: URL(string: "https://saurav.tech/NewsAPI/everything/cnn.json")!)
        let tickersService = StockTickersAPI(url: URL(string: "https://raw.githubusercontent.com/dsancov/TestData/main/stocks.csv")!)
        let viewModel = NewsFeedViewModel(stockTickersService: tickersService, newsFeedService: newsService)
        
        let initialViewController = NewsFeedViewController(viewModel: viewModel)
        
        let navigationController = UINavigationController(rootViewController: initialViewController)
        
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        return true
    }
}

