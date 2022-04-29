//
//  StockTickersServiceError.swift
//  StockTickers
//
//  Created by mac on 29/04/2022.
//

import Foundation

enum StockTickersServiceError: Error {
    case CSVReadError(message: String)
    case others(message: String)
}
