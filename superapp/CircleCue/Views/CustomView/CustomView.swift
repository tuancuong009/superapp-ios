//
//  CustomView.swift
//  CircleCue
//
//  Created by QTS Coder on 1/4/21.
//

import UIKit

class CustomView: UIView {

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
class CustomViewRR: UIView {
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable
    var borderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.borderColor = color.cgColor
            } else {
                layer.borderColor = nil
            }
        }
    }
}
class CustomBtnRR: UIButton {
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable
    var borderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.borderColor = color.cgColor
            } else {
                layer.borderColor = nil
            }
        }
    }
}
