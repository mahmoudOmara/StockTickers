//
//  Article.swift
//  StockTickers
//
//  Created by mac on 28/04/2022.
//

import Foundation

struct Article: Identifiable {
    let id = UUID()
	let title: String?
	let description: String?
	let imageURL: String?
	let date: String?
}

extension Article: Decodable {
    enum CodingKeys: String, CodingKey {
        case title, description, imageURL = "urlToImage", date = "publishedAt"
    }
}
