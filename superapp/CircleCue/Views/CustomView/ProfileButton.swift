//
//  ProfileButton.swift
//  CircleCue
//
//  Created by QTS Coder on 1/4/21.
//

import UIKit

class ProfileButton: UIButton {

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
    
    @IBInspectable
    var profileType: Bool = true

    @IBInspectable
    var personalAccount: Bool = true {
        didSet {
            switch personalAccount {
            case true:
                let bgImage = profileType ? UIImage(named: "bg_btn_personal") : UIImage(named: "bg_btn_send_msg")
                self.setBackgroundImage(bgImage, for: .normal)
            case false:
                let bgImage = profileType ? UIImage(named: "bg_btn_business") : UIImage(named: "bg_btn_send_msg_business")
                self.setBackgroundImage(bgImage, for: .normal)
            }
        }
    }
}
