//
//  LatestNewsCollectionViewCell.swift
//  StockTickers
//
//  Created by mac on 29/04/2022.
//

import UIKit

class LatestNewsCollectionViewCell: UICollectionViewCell {

    private var viewModel: NewsItemViewModel?
    
    func configure(with viewModel: NewsItemViewModel) {
        self.viewModel = viewModel
    }
}

extension LatestNewsCollectionViewCell {
    static let reuseIdentifier = String(describing: LatestNewsCollectionViewCell.self)

    static func nib() -> UINib {
        return UINib(nibName: String(describing: LatestNewsCollectionViewCell.self), bundle: nil)
    }
}
