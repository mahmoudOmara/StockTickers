//
//  NewsFeedViewController.swift
//  StockTickers
//
//  Created by mac on 28/04/2022.
//

import UIKit
import Combine

class NewsFeedViewController: UIViewController {

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
    
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Item>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Item>
    
    private var collectionView: UICollectionView!
    private var viewModel: NewsFeedViewModel?
    private lazy var dataSource = makeDataSource()
    
    private var stockTickersViewModels = [StockTickerViewModel]()
    private var latestNewsFeedItemsViewModels = [NewsItemViewModel]()
    private var resetNewsFeedItemsViewModels = [NewsItemViewModel]()
    
    private var cancellableSet: Set<AnyCancellable> = []
    
    convenience init(viewModel: NewsFeedViewModel) {
        self.init()
        self.viewModel = viewModel
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Stock Tickers"
        configureCollectionView()
        subscribePublishers()
        self.viewModel?.viewLoaded()
    }
    
    private func subscribePublishers() {
        self.viewModel?
            .$stockTickersViewModels
            .sink(receiveValue: { [weak self] in
                self?.stockTickersViewModels = $0
                self?.applySnapshotForCurrentState()
            })
            .store(in: &cancellableSet)
        
        self.viewModel?
            .$latestNewsFeedItemsViewModels
            .sink(receiveValue: { [weak self] in
                self?.latestNewsFeedItemsViewModels = $0
                self?.applySnapshotForCurrentState()
            })
            .store(in: &cancellableSet)
        
        self.viewModel?
            .$resetNewsFeedItemsViewModels
            .sink(receiveValue: { [weak self] in
                self?.resetNewsFeedItemsViewModels = $0
                self?.applySnapshotForCurrentState()
            })
            .store(in: &cancellableSet)
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
        let itemSize = NSCollectionLayoutSize(
          widthDimension: .fractionalWidth(1),
          heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
          widthDimension: .estimated(80),
          heightDimension: .estimated(50))
        let group = NSCollectionLayoutGroup.horizontal(
          layoutSize: groupSize,
          subitem: item,
          count: 1)
        
        let headerSize = NSCollectionLayoutSize(
          widthDimension: .fractionalWidth(1.0),
          heightDimension: .estimated(44))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
          layoutSize: headerSize,
          elementKind: HeaderViewCollectionReusableView.sectionHeaderElementKind,
          alignment: .top)

        let section = NSCollectionLayoutSection(group: group)
        
        section.boundarySupplementaryItems = [sectionHeader]
        section.orthogonalScrollingBehavior = .continuous

        return section
      }
    
    
    private func generateLatestNewsLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
          widthDimension: .fractionalWidth(1),
          heightDimension: .fractionalHeight(1)) //here
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupFractionalWidth = 0.475
        let groupFractionalHeight: Float = Float(2/3 * groupFractionalWidth)
        let groupSize = NSCollectionLayoutSize(
          widthDimension: .fractionalWidth(CGFloat(groupFractionalWidth)),
          heightDimension: .fractionalWidth(CGFloat(groupFractionalHeight)))
        let group = NSCollectionLayoutGroup.horizontal(
          layoutSize: groupSize,
          subitem: item,
          count: 1)
        

        let headerSize = NSCollectionLayoutSize(
          widthDimension: .fractionalWidth(1.0),
          heightDimension: .estimated(44))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
          layoutSize: headerSize,
          elementKind: HeaderViewCollectionReusableView.sectionHeaderElementKind,
          alignment: .top)

        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [sectionHeader]
        section.orthogonalScrollingBehavior = .groupPaging

        return section
      }
    
    private func generateRemainingLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
          widthDimension: NSCollectionLayoutDimension.fractionalWidth(1),
          heightDimension: NSCollectionLayoutDimension.absolute(280)
        )
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
          widthDimension: NSCollectionLayoutDimension.fractionalWidth(1),
          heightDimension: NSCollectionLayoutDimension.absolute(280)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
        let section = NSCollectionLayoutSection(group: group)
        
        // Supplementary header view setup
        let headerFooterSize = NSCollectionLayoutSize(
          widthDimension: .fractionalWidth(1.0),
          heightDimension: .estimated(44)
        )
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
          layoutSize: headerFooterSize,
          elementKind: HeaderViewCollectionReusableView.sectionHeaderElementKind,
          alignment: .top
        )
        section.boundarySupplementaryItems = [sectionHeader]

        return section
    }
    
    private func makeDataSource() -> DataSource {
        let dataSource = DataSource(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
            switch itemIdentifier {
            case .stockTicker(let viewModel):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StockTickerCollectionViewCell.reuseIdentifier, for: indexPath) as! StockTickerCollectionViewCell
                cell.configure(with: viewModel)
                return cell
            case .latestNews(let viewModel):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LatestNewsCollectionViewCell.reuseIdentifier, for: indexPath) as! LatestNewsCollectionViewCell
                cell.configure(with: viewModel)
                return cell
            case .remainigNews(let viewModel):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewsCollectionViewCell.reuseIdentifier, for: indexPath) as! NewsCollectionViewCell
                cell.configure(with: viewModel)
                return cell
            }
        }
        
        dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
            guard kind == HeaderViewCollectionReusableView.sectionHeaderElementKind else {
                return nil
            }
            let section = self.dataSource.snapshot()
                .sectionIdentifiers[indexPath.section]
            let view = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: HeaderViewCollectionReusableView.reuseIdentifier,
                for: indexPath) as? HeaderViewCollectionReusableView
            view?.configure(with: section.rawValue)
            return view
        }
        return dataSource
    }
    
    private  func snapshotForCurrentState() -> Snapshot {
        var snapshot = Snapshot()

        if !self.stockTickersViewModels.isEmpty {
            snapshot.appendSections([Section.stockTickers])
            snapshot.appendItems(self.stockTickersViewModels.map({ Item.stockTicker($0) }))
        }
        
        if !self.latestNewsFeedItemsViewModels.isEmpty {
            snapshot.appendSections([Section.latestNews])
            snapshot.appendItems(self.latestNewsFeedItemsViewModels.map({ Item.latestNews($0) }))
        }
        
        if !self.resetNewsFeedItemsViewModels.isEmpty {
            snapshot.appendSections([Section.remainingNews])
            snapshot.appendItems(self.resetNewsFeedItemsViewModels.map({ Item.remainigNews($0) }))
        }
        return snapshot
    }
    
    private func applySnapshotForCurrentState() {
        self.dataSource.apply(snapshotForCurrentState())
    }
}
