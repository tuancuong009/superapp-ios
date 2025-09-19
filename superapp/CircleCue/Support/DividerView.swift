//
//  DividerView.swift
//  CircleCue
//
//  Created by QTS Coder on 22/02/2023.
//

import UIKit

class DividerView: UIView {
    
    @IBInspectable
    var dividerColor: UIColor = UIColor.black.withAlphaComponent(0.5) {
        didSet {
            dividerView.backgroundColor = dividerColor
        }
    }
    
    private var dividerView = UIView()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: - Setup
    
    private func setup() {
        self.backgroundColor = .clear
        self.dividerView.backgroundColor = dividerColor
        self.addSubview(dividerView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.dividerView.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: 0.5)
    }
}
