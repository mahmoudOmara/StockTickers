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
        lhs.stockTicker.stockSymbol == rhs.stockTicker.stockSymbol
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(stockTicker.stockSymbol)
    }
}
