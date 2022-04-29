//
//  NewsFeedViewModel.swift
//  StockTickers
//
//  Created by mac on 29/04/2022.
//

import Foundation

class NewsFeedViewModel {
    
    let stockTickersService: StockTickersService
    let newsFeedService: NewsFeedService
    
    init(stockTickersService: StockTickersService, newsFeedService: NewsFeedService) {
        self.stockTickersService = stockTickersService
        self.newsFeedService = newsFeedService
    }
}
