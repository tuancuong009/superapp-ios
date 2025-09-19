//
//  TopbarView.swift
//  CircleCue
//
//  Created by QTS Coder on 10/7/20.
//

import UIKit

protocol TopbarViewDelegate: AnyObject {
    func backAction()
    func editProfile()
    func addNote()
}

class TopbarView: UIView {

    @IBOutlet private var contentView: UIView!
    @IBOutlet private weak var leftButton: UIButton!
    @IBOutlet public weak var rightButton: UIButton!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var titleLogo: UIImageView!
    
    weak var delegate: TopbarViewDelegate?
    
    @IBInspectable
    var showTitle: Bool = true {
        didSet {
            titleLabel.isHidden = !showTitle
            titleLogo.isHidden = !showTitle
        }
    }
    
    @IBInspectable
    var title: String? = nil {
        didSet {
            if !showTitle {
                titleLabel.isHidden = true
                titleLogo.isHidden = true
            } else if let title = title {
                if title.trimmed.isEmpty {
                    titleLabel.text = nil
                    titleLabel.isHidden = true
                    titleLogo.isHidden = true
                } else {
                    titleLabel.text = title
                    titleLabel.isHidden = false
                    titleLogo.isHidden = true
                }
            } else {
                titleLabel.isHidden = true
                titleLogo.isHidden = false
            }
        }
    }
    
    @IBInspectable
    var showRightMenu: Bool = false {
        didSet {
            rightButton.isHidden = !showRightMenu
        }
    }
    
    @IBInspectable
    var leftButtonType: Int = 1 {
        didSet {
            switch leftButtonType {
                case 0,1:
                    leftButton.setImage(#imageLiteral(resourceName: "btn_back"), for: .normal)
                    leftButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
                default:
                    leftButton.isHidden = true
                    leftButton.setImage(nil, for: .normal)
            }
        }
    }
    
    @IBInspectable
    var rightButtonType: Int = 0 {
        didSet {
            switch rightButtonType {
                case 0:
                    rightButton.setImage(#imageLiteral(resourceName: "menu_profile"), for: .normal)
                case 1:
                    rightButton.setImage(#imageLiteral(resourceName: "btn_new"), for: .normal)
                default:
                    rightButton.setImage(nil, for: .normal)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    
    private func setup() {
        Bundle.main.loadNibNamed("TopbarView", owner: self, options: nil)
        self.addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        title = nil
        
        leftButton.setImage(#imageLiteral(resourceName: "btn_back"), for: .normal)
        leftButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    @IBAction func menuAction(_ sender: Any) {
        delegate?.backAction()
    }
    
    @IBAction func rightMenuAction(_ sender: Any) {
        switch rightButtonType {
            case 0:
                delegate?.editProfile()
            case 1:
                delegate?.addNote()
            default:
                break
        }
    }
}
