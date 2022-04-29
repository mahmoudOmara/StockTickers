//
//  StockTickerCollectionViewCell.swift
//  StockTickers
//
//  Created by mac on 29/04/2022.
//

import UIKit

class StockTickerCollectionViewCell: UICollectionViewCell {
    
    private var viewModel: StockTickerViewModel?
    
    func configure(with viewModel: StockTickerViewModel) {
        self.viewModel = viewModel
    }
    
}

extension StockTickerCollectionViewCell {
    static let reuseIdentifier = String(describing: StockTickerCollectionViewCell.self)

    static func nib() -> UINib {
        return UINib(nibName: String(describing: StockTickerCollectionViewCell.self), bundle: nil)
    }
}
