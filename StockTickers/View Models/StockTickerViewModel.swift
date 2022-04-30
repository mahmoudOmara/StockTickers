//
//  StockTickerViewModel.swift
//  StockTickers
//
//  Created by mac on 29/04/2022.
//

import Foundation

class StockTickerViewModel {
    
    private let stockTicker: StockTicker
    
    @Published var stockSymbol: String = ""
    @Published var price: String = ""
    @Published var isPositivePrice: Bool = true

    static private let currencyFormatter: NumberFormatter = {
      let formatter = NumberFormatter()
      formatter.numberStyle = .currency
      formatter.positiveFormat = "#.## ¤"
      formatter.negativeFormat = "-#.## ¤"
      formatter.currencySymbol = "USD"
      return formatter
    }()
    
    init(stockTicker: StockTicker) {
        self.stockTicker = stockTicker
        self.stockSymbol = stockTicker.stockSymbol
        self.price = StockTickerViewModel.currencyFormatter.string(from: NSNumber.init(value: Double(stockTicker.price) ?? 0)) ?? ""
        self.isPositivePrice = (Double(stockTicker.price) ?? 0) >= 0
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
