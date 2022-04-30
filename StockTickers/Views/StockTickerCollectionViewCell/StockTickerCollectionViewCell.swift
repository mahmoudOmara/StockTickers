//
//  StockTickerCollectionViewCell.swift
//  StockTickers
//
//  Created by mac on 29/04/2022.
//

import UIKit
import Combine

class StockTickerCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var symbolLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    private var viewModel: StockTickerViewModel?
    private var cancellableSet: Set<AnyCancellable> = []

    func configure(with viewModel: StockTickerViewModel) {
        self.viewModel = viewModel
        viewModel
            .$stockSymbol
            .sink { [weak self] in
                self?.symbolLabel.text = $0
            }
            .store(in: &cancellableSet)
        
        viewModel
            .$price
            .sink { [weak self] in
                self?.priceLabel.text = $0
            }
            .store(in: &cancellableSet)
        
        viewModel
            .$isPositivePrice
            .sink { [weak self] in
                self?.priceLabel.textColor = $0 ? .systemGreen : .systemRed
            }
            .store(in: &cancellableSet)

    }
    
}

extension StockTickerCollectionViewCell {
    static let reuseIdentifier = String(describing: StockTickerCollectionViewCell.self)

    static func nib() -> UINib {
        return UINib(nibName: String(describing: StockTickerCollectionViewCell.self), bundle: nil)
    }
}
