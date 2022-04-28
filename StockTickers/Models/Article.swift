//
//  Article.swift
//  StockTickers
//
//  Created by mac on 28/04/2022.
//

import Foundation

struct Article {
	let title : String
	let description : String
	let imageURL : String
	let date : Date
}

extension Article: Decodable {
    enum CodingKeys: String, CodingKey {
        case title, description, imageURL = "urlToImage", date = "publishedAt"
    }
}
