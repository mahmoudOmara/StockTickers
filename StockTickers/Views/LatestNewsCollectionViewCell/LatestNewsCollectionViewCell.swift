//
//  LatestNewsCollectionViewCell.swift
//  StockTickers
//
//  Created by mac on 29/04/2022.
//

import UIKit
import Combine

class LatestNewsCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var newsImageView: UIImageView!
    
    private var viewModel: NewsItemViewModel?
    private var cancellableSet: Set<AnyCancellable> = []

    func configure(with viewModel: NewsItemViewModel) {
        self.viewModel = viewModel
        viewModel
            .$title
            .sink { [weak self] in
                self?.titleLabel.text = $0
            }
            .store(in: &cancellableSet)
        viewModel
            .$image
            .sink { [weak self] in
                self?.newsImageView.image = $0
            }
            .store(in: &cancellableSet)
    }
}

extension LatestNewsCollectionViewCell {
    static let reuseIdentifier = String(describing: LatestNewsCollectionViewCell.self)

    static func nib() -> UINib {
        return UINib(nibName: String(describing: LatestNewsCollectionViewCell.self), bundle: nil)
    }
}
