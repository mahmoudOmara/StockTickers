//
//  HeaderViewCollectionReusableView.swift
//  StockTickers
//
//  Created by mac on 29/04/2022.
//

import UIKit

class HeaderViewCollectionReusableView: UICollectionReusableView {

    private var title: String?
    
    func configure(with title: String) {
        self.title = title
    }
    
}

extension HeaderViewCollectionReusableView {
    static let reuseIdentifier = String(describing: HeaderViewCollectionReusableView.self)

    static let sectionHeaderElementKind = "section-header-element-kind"

    static func nib() -> UINib {
        return UINib(nibName: String(describing: HeaderViewCollectionReusableView.self), bundle: nil)
    }
}
