//
//  NewsFeedViewModel.swift
//  StockTickers
//
//  Created by mac on 29/04/2022.
//

import Foundation

class NewsFeedViewModel<T: StockTickersService> {
    
    let stockTickersService: T
    let newsFeedService: NewsFeedService
    
    init(stockTickersService: T, newsFeedService: NewsFeedService) {
        self.stockTickersService = stockTickersService
        self.newsFeedService = newsFeedService
    }
}
