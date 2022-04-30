//
//  NewsItemViewModel.swift
//  StockTickers
//
//  Created by mac on 29/04/2022.
//

import Foundation
import UIKit.UIImage

class NewsItemViewModel {
    
    private let newsItem: Article
    
    @Published var title: String = ""
    @Published var description: String = ""
    @Published var image: UIImage? = nil
    @Published var date: String = ""
    
    static private let serverDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        return dateFormatter
    }()
    
    static private let clientDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        return dateFormatter
    }()
    
    init(newsItem: Article) {
        self.newsItem = newsItem
        self.title = newsItem.title ?? ""
        self.description = newsItem.description ?? ""
        DispatchQueue.global().async { [weak self] in
            if let imageURL = URL(string: newsItem.imageURL ?? ""),
               let imageData = try? Data(contentsOf: imageURL) {
                DispatchQueue.main.async {
                    self?.image = UIImage(data: imageData)
                }
            }
        }
        
        if let date = NewsItemViewModel.serverDateFormatter.date(from: newsItem.date ?? "") {
            self.date = NewsItemViewModel.clientDateFormatter.string(from: date)
        }
        
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
