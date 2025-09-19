//
//  RoundImageView.swift
//  CircleCue
//
//  Created by QTS Coder on 10/16/20.
//

import UIKit

class RoundImageView: UIImageView {
    
    @IBInspectable
    var rounded: Bool = false
    
    @IBInspectable
    var radius: CGFloat = 0.0 {
        didSet {
            self.layer.cornerRadius = radius
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        if rounded {
            self.layer.cornerRadius = self.frame.height/2
        } else if radius > 0 {
            self.layer.cornerRadius = radius
        } else {
            self.layer.cornerRadius = self.frame.height * 0.18
        }
    }
    
    @IBInspectable
    var borderColor: UIColor = .clear {
        didSet {
            self.layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat = 0.0 {
        didSet {
            self.layer.borderWidth = borderWidth
        }
    }
    
}
