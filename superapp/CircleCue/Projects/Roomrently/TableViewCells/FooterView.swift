//
//  FooterView.swift
//  Roomrently
//
//  Created by QTS Coder on 29/12/2023.
//

import UIKit

class FooterView: UICollectionReusableView {
    var tapLoadMore: (() ->())?
    @IBOutlet weak var btnLoadMore: UIButton!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBAction func doLoadMore(_ sender: Any) {
        self.tapLoadMore?()
    }
}
