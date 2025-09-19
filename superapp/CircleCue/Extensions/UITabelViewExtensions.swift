//
//  UITabelViewExtensions.swift
//  CircleCue
//
//  Created by QTS Coder on 10/13/20.
//

import UIKit



extension UITableView {
    func registerNibCell(identifier: String) {
        self.register(UINib(nibName: identifier, bundle: nil), forCellReuseIdentifier: identifier)
    }
    
    func dequeueCell<T: UITableViewCell>(for indexPath: IndexPath) -> T {
        return dequeueReusableCell(
            withIdentifier: T.className,
            for: indexPath
        ) as! T
    }
}

extension UITableViewCell {
    
    static var identifier: String {
        return String(describing: self)
    }
    
    static var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
}
