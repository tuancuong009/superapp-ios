//
//  CustomView.swift
//  TinderSwipeView_Example
//
//  Created by Nick on 29/05/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit

class CustomViewProfile: UIView {
        
    @IBOutlet var contentView: UIView!

    @IBOutlet weak var imgCard: UIImageView!
    @IBOutlet weak var btnProfile: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        Bundle.main.loadNibNamed(CustomView.className, owner: self, options: nil)
        contentView.fixInView(self)
        imgCard.layer.cornerRadius = 16
        imgCard.layer.masksToBounds = true
        
    }
    
 

}

extension UIView{
    
    func fixInView(_ container: UIView!) -> Void{
        
        self.translatesAutoresizingMaskIntoConstraints = false;
        self.frame = container.frame;
        container.addSubview(self);
        NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: container, attribute: .leading, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: container, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: container, attribute: .top, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: container, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
    }
}

extension NSObject {
    
    class var className: String {
        return String(describing: self)
    }
}
