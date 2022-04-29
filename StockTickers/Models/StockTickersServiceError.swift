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

extension StockTickersServiceError: CustomStringConvertible {
    public var description: String {
        switch self {
        case .CSVReadError(message: let message):
            return message
        case .others(message: let message):
            return message
        }
    }
}
