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
        
        self.viewModel?
            .$loadingState
            .sink(receiveValue: { [weak self] in
                switch $0 {
                case .loading:
                    self?.showLoading()
                case .notLoading:
                    self?.hideLoading()
                }
            })
            .store(in: &cancellableSet)
        
        self.viewModel?
            .$newsFeedLoadingError
            .filter({ !$0.isEmpty })
            .sink(receiveValue: { [weak self] in
                self?.showErrorAlert(message: $0)
            })
            .store(in: &cancellableSet)
        
        self.viewModel?
            .$stockTickersLoadingError
            .filter({ !$0.isEmpty })
            .sink(receiveValue: { [weak self] in
                self?.showErrorAlert(message: $0)
            })
            .store(in: &cancellableSet)
    }
    
    private func showErrorAlert(message: String) {
        guard self.presentedViewController == nil else { return }
        let alertController = UIAlertController(
            title: "Something went wrong!",
            message: message,
            preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(
            title: "Ok",
            style: .default))
        
        present(alertController, animated: true)
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
        let layout = UICollectionViewCompositionalLayout { [weak self] (sectionIndex, _) -> NSCollectionLayoutSection? in
            
            guard let self = self else { return nil}
            let sectionType = self.dataSource.sectionIdentifier(for: sectionIndex)
            switch sectionType {
            case .stockTickers:
                return self.generateStockTickersLayout()
            case .latestNews:
                return self.generateLatestNewsLayout()
            case .remainingNews:
                return self.generateRemainingLayout()
            default:
                return nil
            }
        }
        return layout
    }
    
    private func generateStockTickersLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
          widthDimension: .fractionalWidth(1),
          heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        item.contentInsets = NSDirectionalEdgeInsets(
            top: 5,
            leading: 5,
            bottom: 5,
            trailing: 5)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.85),
          heightDimension: .absolute(50))
        let group = NSCollectionLayoutGroup.horizontal(
          layoutSize: groupSize,
          subitem: item,
          count: 3)
        
        let headerSize = NSCollectionLayoutSize(
          widthDimension: .fractionalWidth(1.0),
          heightDimension: .absolute(36))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
          layoutSize: headerSize,
          elementKind: HeaderViewCollectionReusableView.sectionHeaderElementKind,
          alignment: .top)
        
        sectionHeader.contentInsets = NSDirectionalEdgeInsets(
            top: 5,
            leading: 5,
            bottom: 5,
            trailing: 5)

        let section = NSCollectionLayoutSection(group: group)
        
        section.boundarySupplementaryItems = [sectionHeader]
        section.orthogonalScrollingBehavior = .continuous

        return section
      }
    
    private func generateLatestNewsLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
          widthDimension: .fractionalWidth(1),
          heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        item.contentInsets = NSDirectionalEdgeInsets(
            top: 5,
            leading: 5,
            bottom: 5,
            trailing: 5)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(CGFloat(0.8)),
          heightDimension: .fractionalWidth(CGFloat(2/3 * 0.8)))
        let group = NSCollectionLayoutGroup.horizontal(
          layoutSize: groupSize,
          subitem: item,
          count: 1)

        let headerSize = NSCollectionLayoutSize(
          widthDimension: .fractionalWidth(1.0),
          heightDimension: .absolute(36))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
          layoutSize: headerSize,
          elementKind: HeaderViewCollectionReusableView.sectionHeaderElementKind,
          alignment: .top)
        
        sectionHeader.contentInsets = NSDirectionalEdgeInsets(
            top: 5,
            leading: 5,
            bottom: 5,
            trailing: 5)

        let section = NSCollectionLayoutSection(group: group)
        
        section.boundarySupplementaryItems = [sectionHeader]
        section.orthogonalScrollingBehavior = .groupPaging

        return section
      }
    
    private func generateRemainingLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
          widthDimension: NSCollectionLayoutDimension.fractionalWidth(1),
          heightDimension: NSCollectionLayoutDimension.fractionalHeight(1)
        )
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        item.contentInsets = NSDirectionalEdgeInsets(
            top: 5,
            leading: 5,
            bottom: 5,
            trailing: 5)
        
        let groupSize = NSCollectionLayoutSize(
          widthDimension: NSCollectionLayoutDimension.fractionalWidth(1),
          heightDimension: NSCollectionLayoutDimension.fractionalHeight(0.5)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
        let section = NSCollectionLayoutSection(group: group)
        
        
        let headerSize = NSCollectionLayoutSize(
          widthDimension: .fractionalWidth(1.0),
          heightDimension: .absolute(36)
        )
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
          layoutSize: headerSize,
          elementKind: HeaderViewCollectionReusableView.sectionHeaderElementKind,
          alignment: .top
        )
        
        sectionHeader.contentInsets = NSDirectionalEdgeInsets(
            top: 5,
            leading: 5,
            bottom: 5,
            trailing: 5)
        
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
        
        dataSource.supplementaryViewProvider = { [weak self] collectionView, kind, indexPath in
            guard let self = self else { return nil }
            guard kind == HeaderViewCollectionReusableView.sectionHeaderElementKind else { return nil }
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
    
    private func applySnapshotForCurrentState(animatingDifferences: Bool = true) {
        self.dataSource.apply(snapshotForCurrentState(), animatingDifferences: animatingDifferences)
    }
}
