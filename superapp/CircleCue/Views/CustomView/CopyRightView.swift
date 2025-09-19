//
//  CopyRightView.swift
//  CircleCue
//
//  Created by QTS Coder on 10/7/20.
//

import UIKit

protocol CopyRightViewDelegate: AnyObject {
    func showInfomation(_ type: AppInfomation)
}

class CopyRightView: UIView {

    @IBOutlet var contentView: UIView!
    
    weak var delegate: CopyRightViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    
    private func setup() {
        Bundle.main.loadNibNamed("CopyRightView", owner: self, options: nil)
        self.addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
}
