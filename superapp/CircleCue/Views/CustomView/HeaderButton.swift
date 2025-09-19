//
//  HeaderButton.swift
//  CircleCue
//
//  Created by QTS Coder on 10/22/20.
//

import UIKit

private extension HeaderButton {
    struct Fonts {
        static let labelFont17: UIFont = UIFont.myriadProRegular(ofSize: 17)
    }
    
    struct Colors {
        static let selectedBackgroundColor: UIColor = UIColor(hex: "ECE590")
    }
}

class HeaderButton: UIButton {
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    enum Style {
        case none
        case roundedRadius
    }
    
    @IBInspectable
    var rounded: Bool = false {
        didSet {
            style = rounded ? .roundedRadius : .none
        }
    }
    
    @IBInspectable
    var radius: CGFloat = 0 {
        didSet {
            setupLayer()
        }
    }
    
    @IBInspectable
    var defaultBackgroundColor: UIColor = UIColor.init(hex: "4F0624") {
        didSet {
            self.backgroundColor = defaultBackgroundColor
        }
    }
    
    var style: Style = .none {
        didSet{
            self.setupLayer()
        }
    }
    
    // MARK: - Setup
    
    private func setup() {
        isExclusiveTouch = true
        setupColors()
        setupTitleLabel()
        setupLayer()
    }
    
    private func setupColors() {
        setTitleColor(.white, for: .normal)
        self.backgroundColor = defaultBackgroundColor
    }
    
    private func setupTitleLabel() {
        titleLabel?.font = Fonts.labelFont17
    }
    
    private func setupLayer() {
        switch self.style {
        case .none:
            layer.cornerRadius = radius
        case .roundedRadius:
            layer.cornerRadius = frame.size.height / 2
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.setupLayer()
    }
    
    // MARK: - Overrides
    override func setImage(_ image: UIImage?, for state: UIControl.State) {
        super.setImage(image, for: state)
        self.imageView?.clipsToBounds = true
        self.imageView?.layer.cornerRadius = 5.0
        self.imageView?.contentMode = .scaleAspectFit
        self.imageView?.clipsToBounds = true
        self.imageView?.layer.transform = CATransform3DMakeScale(0.8, 0.8, 0.8)
        self.imageEdgeInsets = UIEdgeInsets.init(top: 8, left: 0, bottom: 8, right: 4)
        self.titleEdgeInsets = UIEdgeInsets.init(top: 0, left: 4, bottom: 0, right: 0)
    }
    
    override var isSelected: Bool {
        didSet{
            let colors = Colors.self
            let backgroundColor: UIColor? = isSelected ? colors.selectedBackgroundColor : defaultBackgroundColor
            UIView.animate(withDuration: 0.2) {
                self.backgroundColor = backgroundColor
            }
        }
    }
}
