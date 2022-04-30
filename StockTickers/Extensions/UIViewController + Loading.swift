//
//  UIViewController + Loading.swift
//  StockTickers
//
//  Created by mac on 30/04/2022.
//

import SVProgressHUD

extension UIViewController {
    func showLoading() {
        SVProgressHUD.show()
    }
    
    func hideLoading() {
        SVProgressHUD.dismiss()
    }
}
