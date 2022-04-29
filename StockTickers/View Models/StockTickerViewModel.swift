//
//  StockTickerViewModel.swift
//  StockTickers
//
//  Created by mac on 29/04/2022.
//

import Foundation

class StockTickerViewModel {
    
    private let stockTicker: StockTicker
    
    init(stockTicker: StockTicker) {
        self.stockTicker = stockTicker
    }
}

extension StockTickerViewModel: Hashable {
    static func == (lhs: StockTickerViewModel, rhs: StockTickerViewModel) -> Bool {
        lhs.stockTicker.id == rhs.stockTicker.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(stockTicker.id)
    }
}
