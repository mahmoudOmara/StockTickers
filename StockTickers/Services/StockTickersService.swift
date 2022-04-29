//
//  StockTickersService.swift
//  StockTickers
//
//  Created by mac on 29/04/2022.
//

import Foundation
import Combine
import SwiftCSV

protocol StockTickersService {
    associatedtype Error: Swift.Error
    func fetchNewsFeed() -> AnyPublisher<Result<[StockTicker], Error>, Never>
}

class StockTickersAPI: StockTickersService {
    
    enum Error: Swift.Error {
        case CSVReadError(message: String)
        case others(message: String)
        
        static func representation(of error: Swift.Error) -> Error {
            guard let readerError = error as? CSVParseError else {
                return .others(message: error.localizedDescription)
            }
            switch readerError {
            case .generic(message: let message):
                return .CSVReadError(message: message)
            case .quotation(message: let message):
                return .CSVReadError(message: message)
            }
        }
    }
    
    private let url: URL
    
    init(url: URL) {
        self.url = url
    }
    
    func fetchNewsFeed() -> AnyPublisher<Result<[StockTicker], Error>, Never> {
        do {
            
            let stocksCSV = try CSV(url: url)
            
            let allRows = stocksCSV.namedRows
            
            let data = try JSONSerialization.data(withJSONObject: allRows, options: .prettyPrinted)

            let decoder = JSONDecoder()
            
            let stockTickers = try decoder.decode([StockTicker].self, from: data)
            let stockTickersGrouped = Dictionary(grouping: stockTickers, by: \.stockSymbol)
            return stockTickersGrouped
                .compactMap { (_, value) in
                value.randomElement()
            }
                .publisher
                .collect()
                .map({
                    Result.success($0)
                })
                .eraseToAnyPublisher()
        } catch {
            return Result.Publisher(.failure(Error.representation(of: error))).eraseToAnyPublisher()
        }
        
    }
}
