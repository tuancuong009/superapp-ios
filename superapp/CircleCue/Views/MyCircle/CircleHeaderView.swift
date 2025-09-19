//
//  CircleHeaderView.swift
//  CircleCue
//
//  Created by QTS Coder on 10/10/20.
//

import UIKit

class CircleHeaderView: UIView {

    @IBOutlet private var contentView: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    
    private func setup() {
        Bundle.main.loadNibNamed("CircleHeaderView", owner: self, options: nil)
        self.addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    func setup(_ title: String) {
        titleLabel.text = title
    }
}
