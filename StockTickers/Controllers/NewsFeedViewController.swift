//
//  NewsFeedViewController.swift
//  StockTickers
//
//  Created by mac on 28/04/2022.
//

import UIKit

class NewsFeedViewController: UIViewController {

    private var collectionView: UICollectionView!

    
    private var viewModel: NewsFeedViewModel?
    
    convenience init(viewModel: NewsFeedViewModel) {
        self.init()
        self.viewModel = viewModel
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Stock Tickers"
        configureCollectionView()
    }

}


extension NewsFeedViewController {
    private func configureCollectionView() {
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: generateLayout())
        view.addSubview(collectionView)
        collectionView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        collectionView.backgroundColor = .systemBackground
        collectionView.register(StockTickerCollectionViewCell.nib(), forCellWithReuseIdentifier: StockTickerCollectionViewCell.reuseIdentifier)
        self.collectionView = collectionView
      }
    
    func generateLayout() -> UICollectionViewLayout {
      
      return UICollectionViewFlowLayout()
    }
}
