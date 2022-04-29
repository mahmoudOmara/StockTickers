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
    
    enum Section: String {
      case stockTickers = "Stocks"
      case latestNews = "Latest News"
      case remainingNews = "More News"
    }
    
    enum Item: Hashable {
        case stockTicker(StockTickerViewModel)
        case latestNews(NewsItemViewModel)
        case remainigNews(NewsItemViewModel)
    }

    var dataSource: UICollectionViewDiffableDataSource<Section, Item>! = nil
    
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
        collectionView.register(LatestNewsCollectionViewCell.nib(), forCellWithReuseIdentifier: LatestNewsCollectionViewCell.reuseIdentifier)
        collectionView.register(NewsCollectionViewCell.nib(), forCellWithReuseIdentifier: NewsCollectionViewCell.reuseIdentifier)
        collectionView.register(HeaderViewCollectionReusableView.nib(), forSupplementaryViewOfKind: HeaderViewCollectionReusableView.sectionHeaderElementKind, withReuseIdentifier: HeaderViewCollectionReusableView.reuseIdentifier)
        self.collectionView = collectionView
    }
    
    private func generateLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, _) -> NSCollectionLayoutSection? in
            return [
                self.generateStockTickersLayout(),
                self.generateLatestNewsLayout(),
                self.generateRemainingLayout()
            ] [sectionIndex]
        }
        return layout
    }
    
    private func generateStockTickersLayout() -> NSCollectionLayoutSection {
        return NSCollectionLayoutSection(group: NSCollectionLayoutGroup(layoutSize: NSCollectionLayoutSize(widthDimension: .absolute(10), heightDimension: .absolute(10))))
    }
    
    private func generateLatestNewsLayout() -> NSCollectionLayoutSection {
        return NSCollectionLayoutSection(group: NSCollectionLayoutGroup(layoutSize: NSCollectionLayoutSize(widthDimension: .absolute(10), heightDimension: .absolute(10))))
    }
    
    private func generateRemainingLayout() -> NSCollectionLayoutSection {
        return NSCollectionLayoutSection(group: NSCollectionLayoutGroup(layoutSize: NSCollectionLayoutSize(widthDimension: .absolute(10), heightDimension: .absolute(10))))
    }
}
