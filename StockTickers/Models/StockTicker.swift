//
//  Ticker.swift
//  StockTickers
//
//  Created by mac on 29/04/2022.
//

import Foundation

struct StockTicker: Identifiable {
    let id = UUID()
    var stockSymbol: String
    var price: String
}

extension StockTicker: Codable {
    enum CodingKeys: String, CodingKey {
        case stockSymbol = "STOCK"
        case price = "PRICE"
    }
}
