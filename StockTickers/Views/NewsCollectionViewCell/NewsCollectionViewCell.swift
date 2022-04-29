//
//  NewsCollectionViewCell.swift
//  StockTickers
//
//  Created by mac on 29/04/2022.
//

import UIKit

class NewsCollectionViewCell: UICollectionViewCell {
    private var viewModel: NewsItemViewModel?
    
    func configure(with viewModel: NewsItemViewModel) {
        self.viewModel = viewModel
    }
}

extension NewsCollectionViewCell {
    static let reuseIdentifier = String(describing: NewsCollectionViewCell.self)

    static func nib() -> UINib {
        return UINib(nibName: String(describing: NewsCollectionViewCell.self), bundle: nil)
    }
}
