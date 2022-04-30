//
//  NewsCollectionViewCell.swift
//  StockTickers
//
//  Created by mac on 29/04/2022.
//

import UIKit
import Combine

class NewsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var newsImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
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
        
        viewModel
            .$description
            .sink { [weak self] in
                self?.descriptionLabel.text = $0
            }
            .store(in: &cancellableSet)
        
        viewModel
            .$date
            .sink { [weak self] in
                self?.dateLabel.text = $0
            }
            .store(in: &cancellableSet)
    }
}

extension NewsCollectionViewCell {
    static let reuseIdentifier = String(describing: NewsCollectionViewCell.self)

    static func nib() -> UINib {
        return UINib(nibName: String(describing: NewsCollectionViewCell.self), bundle: nil)
    }
}
