//
//  LoginPopupView.swift
//  CircleCue
//
//  Created by QTS Coder on 1/11/21.
//

import UIKit

enum LoginPopupAction {
    case close
    case login
    case join
}

protocol LoginPopupViewDelegate: AnyObject {
    func performAction(_ action: LoginPopupAction)
}

class LoginPopupView: UIView {

    @IBOutlet private var contentView: UIView!
    
    weak var delegate: LoginPopupViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    
    private func setup() {
        if UIDevice.current.userInterfaceIdiom == .pad {
            Bundle.main.loadNibNamed("LoginPopupView_iPad", owner: self, options: nil)
        } else {
            Bundle.main.loadNibNamed("LoginPopupView", owner: self, options: nil)
        }
        self.addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    @IBAction func loginAction(_ sender: Any) {
        delegate?.performAction(.login)
    }
    
    @IBAction func joinAction(_ sender: Any) {
        delegate?.performAction(.join)
    }
    
    @IBAction func didTapCloseButton(_ sender: Any) {
        delegate?.performAction(.close)
    }
}
