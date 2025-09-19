//
//  UIViewExtesion+Helpers.swift
//  CRT
//
//  Created by QTS Coder on 8/15/20.
//  Copyright © 2020 QTS Coder. All rights reserved.
//

import UIKit

extension UIView {
    func removeAllSubView() {
        self.subviews.forEach { (sub) in
            sub.removeFromSuperview()
        }
    }
    
    func fixInView(_ container: UIView, xibName: String) {
        Bundle.main.loadNibNamed(xibName, owner: self, options: nil)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.frame = container.bounds
        container.addSubview(self)
        NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: container, attribute: .leading, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: container, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: container, attribute: .top, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: container, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
    }
}

public extension UIWindow {
    static var key: UIWindow? {
        if #available(iOS 13, *) {
            return UIApplication.shared.windows.first { $0.isKeyWindow }
        } else {
            return UIApplication.shared.keyWindow
        }
    }
}
