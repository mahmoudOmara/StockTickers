//
//  NewsItemViewModel.swift
//  StockTickers
//
//  Created by mac on 29/04/2022.
//

import Foundation

class NewsItemViewModel {
    
    private let newsItem: Article
    
    init(newsItem: Article) {
        self.newsItem = newsItem
    }
}

extension NewsItemViewModel: Hashable {
    static func == (lhs: NewsItemViewModel, rhs: NewsItemViewModel) -> Bool {
        lhs.newsItem.id == rhs.newsItem.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(newsItem.id)
    }
}
