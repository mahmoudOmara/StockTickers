//
//  NewsFeed.swift
//  StockTickers
//
//  Created by mac on 28/04/2022.
//

import Foundation

struct NewsFeed {
	let articles: [Article]
}

extension NewsFeed: Decodable {}
