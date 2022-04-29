//
//  File.swift
//  StockTickers
//
//  Created by mac on 28/04/2022.
//

import Foundation
import Combine
import Alamofire

protocol NewsFeedService {
    func fetchNewsFeed() -> AnyPublisher<DataResponse<NewsFeed, AFError>, Never>
}

class NewsFeedAPI: NewsFeedService {
    private let url: URL
    
    init(url: URL) {
        self.url = url
    }
    
    func fetchNewsFeed() -> AnyPublisher<DataResponse<NewsFeed, AFError>, Never> {
        return AF.request(url, method: .get)
            .validate()
            .publishDecodable(type: NewsFeed.self)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
