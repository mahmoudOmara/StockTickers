//
//  NewsFeedViewModel.swift
//  StockTickers
//
//  Created by mac on 29/04/2022.
//

import Foundation
import Combine

class NewsFeedViewModel {

    @Published var newsFeed = [Article]()
    @Published var newsFeedLoadingError = ""

    private let stockTickersService: StockTickersService
    private let newsFeedService: NewsFeedService

    private var cancellableSet: Set<AnyCancellable> = []

    init(stockTickersService: StockTickersService, newsFeedService: NewsFeedService) {
        self.stockTickersService = stockTickersService
        self.newsFeedService = newsFeedService
    }
    
    func viewLoaded() {
        getNewsFeed()
    }
    
    private func getNewsFeed() {
        self.newsFeedService
            .fetchNewsFeed()
            .sink {  response in
                if let error = response.error {
                    self.newsFeedLoadingError = error.localizedDescription
                } else {
                    self.newsFeed = response.value?.articles ?? []
                }
            }
            .store(in: &cancellableSet)
    }
}
