//
//  NewsFeedViewModel.swift
//  StockTickers
//
//  Created by mac on 29/04/2022.
//

import Foundation
import Combine

class NewsFeedViewModel {

    @Published var latestNewsFeedItemsViewModels = [NewsItemViewModel]()
    @Published var resetNewsFeedItemsViewModels = [NewsItemViewModel]()
    @Published var newsFeedLoadingError = ""

    @Published var stockTickersViewModels = [StockTickerViewModel]()
    @Published var stockTickersLoadingError = ""

    private let stockTickersService: StockTickersService
    private let newsFeedService: NewsFeedService

    private var cancellableSet: Set<AnyCancellable> = []

    init(stockTickersService: StockTickersService, newsFeedService: NewsFeedService) {
        self.stockTickersService = stockTickersService
        self.newsFeedService = newsFeedService
    }
    
    func viewLoaded() {
        getNewsFeed()
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            self?.getStockTickers()
        }
    }
    
    private func getStockTickers() {
        self.stockTickersService
            .fetchNewsFeed()
            .sink { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .failure(let error):
                    self.stockTickersLoadingError = error.description
                case .success(let tickers):
                    self.stockTickersViewModels = tickers
                        .map({ StockTickerViewModel(stockTicker: $0) })
                }
            }
            .store(in: &cancellableSet)
    }
    
    private func getNewsFeed() {
        self.newsFeedService
            .fetchNewsFeed()
            .sink {  [weak self] response in
                guard let self = self else { return }
                if let error = response.error {
                    self.newsFeedLoadingError = error.localizedDescription
                } else {
                    let viewModels = (response.value?.articles ?? [])
                        .map({ NewsItemViewModel(newsItem: $0) })
                    self.latestNewsFeedItemsViewModels = [NewsItemViewModel](viewModels.prefix(6))
                    self.resetNewsFeedItemsViewModels = [NewsItemViewModel](viewModels.dropFirst(6))
                }
            }
            .store(in: &cancellableSet)
    }
}
