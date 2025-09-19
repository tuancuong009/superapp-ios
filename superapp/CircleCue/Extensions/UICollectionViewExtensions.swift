//
//  UICollectionViewExtensions.swift
//  CircleCue
//
//  Created by QTS Coder on 10/13/20.
//

import UIKit

extension UICollectionView {
    
    func registerNibCell(identifier: String) {
        self.register(UINib(nibName: identifier, bundle: nil), forCellWithReuseIdentifier: identifier)
    }
    
    func dequeueCell<T: UICollectionViewCell>(for indexPath: IndexPath) -> T {
        return dequeueReusableCell(withReuseIdentifier: T.className, for: indexPath) as! T
    }
    
    func dequeueReusableView<T: UICollectionReusableView>(for indexPath: IndexPath, with kind: String) -> T {
        return dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: T.className, for: indexPath) as! T
    }
}

extension UICollectionViewCell {
    
    static var identifier: String {
        return String(describing: self)
    }
    
    static var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
}
