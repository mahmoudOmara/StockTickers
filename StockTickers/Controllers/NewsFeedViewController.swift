//
//  NewsFeedViewController.swift
//  StockTickers
//
//  Created by mac on 28/04/2022.
//

import UIKit

class NewsFeedViewController: UIViewController {

    private var viewModel: NewsFeedViewModel?
    
    convenience init(viewModel: NewsFeedViewModel) {
        self.init()
        self.viewModel = viewModel
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }

}
