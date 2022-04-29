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
    func fetchNewsFeed() -> AnyPublisher<Result<[StockTicker], StockTickersServiceError>, Never>
}

class StockTickersAPI: StockTickersService {
    
    private let url: URL
    
    init(url: URL) {
        self.url = url
    }
    
    func fetchNewsFeed() -> AnyPublisher<Result<[StockTicker], StockTickersServiceError>, Never> {
        
        let result = PassthroughSubject<Result<[StockTicker], StockTickersServiceError>, Never>()
        
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            do {
                let stocksCSV = try CSV(url: self.url)
                
                let allRows = stocksCSV.namedRows
                
                let data = try JSONSerialization.data(withJSONObject: allRows, options: .prettyPrinted)
                
                let decoder = JSONDecoder()
                
                let allStockTickers = try decoder.decode([StockTicker].self, from: data)
                let currentStockTickers = Dictionary(grouping: allStockTickers, by: \.stockSymbol)
                    .compactMap { (_, value) in
                        value.randomElement()
                    }
                result.send(.success(currentStockTickers))
                result.send(completion: .finished)
            } catch {
                result.send(.failure(self.stockTickersServiceError(of: error)))
                result.send(completion: .finished)
            }
        }
        
        return result
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    private func stockTickersServiceError(of error: Error) -> StockTickersServiceError {
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
