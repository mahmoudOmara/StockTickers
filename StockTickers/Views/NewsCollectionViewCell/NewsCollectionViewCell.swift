//
//  NewsCollectionViewCell.swift
//  StockTickers
//
//  Created by mac on 29/04/2022.
//

import UIKit

class NewsCollectionViewCell: UICollectionViewCell {
    
}

extension NewsCollectionViewCell {
    static let reuseIdentifier = String(describing: NewsCollectionViewCell.self)

    static func nib() -> UINib {
        return UINib(nibName: String(describing: NewsCollectionViewCell.self), bundle: nil)
    }
}
