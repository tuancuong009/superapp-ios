//
//  CustomButton.swift
//  DesignMaterial
//
//  Created by QTS Coder on 8/25/20.
//

import UIKit

private extension CustomButton {
    struct Fonts {
        static let labelFont14: UIFont = UIFont.myriadProRegular(ofSize: 14)
        static let labelFont17: UIFont = UIFont.myriadProRegular(ofSize: 18)
    }
    
    struct Colors {
        static let highlightedBackgroundColor: UIColor = UIColor(displayP3Red: 132.0 / 255.0, green: 164.0 / 255.0,  blue: 196.0/255.0, alpha: 1.0)
        
        static let disabledColor: UIColor = UIColor.black.withAlphaComponent(0.32)
        static let disabled: UIColor = UIColor.black.withAlphaComponent(0.32)
        
    }
    
    struct AnimationDuration {
        static let highlightDuration: TimeInterval = 0.2
        static let enabledDuration: TimeInterval = 0.2
    }
}

class CustomButton: UIButton {
    
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
    var defaultBackgroundColor: UIColor = Constants.red_brown {
        didSet {
            self.backgroundColor = defaultBackgroundColor
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat = 0.0 {
        didSet {
            self.layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable
    var borderColor: UIColor = UIColor.clear {
        didSet {
            self.layer.borderColor = borderColor.cgColor
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
//        setupTitleLabel()
        setupLayer()
    }
    
    private func setupColors() {
        setTitleColor(Colors.disabledColor, for: .disabled)
        self.backgroundColor = defaultBackgroundColor
    }
    
    private func setupTitleLabel() {
        titleLabel?.font = Fonts.labelFont17
    }
    
    private func setupLayer() {
        switch self.style {
        case .none:
            layer.cornerRadius = radius
            break
        case .roundedRadius:
            layer.cornerRadius = frame.size.height / 2
            break
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
    
    override open var isHighlighted: Bool {
        didSet {
            let colors = Colors.self
            let backgroundColor: UIColor? = isHighlighted ? colors.highlightedBackgroundColor : defaultBackgroundColor
            UIView.animate(withDuration: AnimationDuration.highlightDuration) {
                self.backgroundColor = backgroundColor
            }
        }
    }
    
    override open var isEnabled: Bool {
        didSet{
            let colors = Colors.self
            let backgroundColor: UIColor? = isEnabled ? defaultBackgroundColor : colors.disabledColor
            UIView.animate(withDuration: AnimationDuration.enabledDuration) {
                self.backgroundColor = backgroundColor
            }
        }
    }
}

class BasicButton: UIButton {
    @IBInspectable
    var radius: CGFloat = 0 {
        didSet {
            self.layer.cornerRadius = radius
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat = 0.0 {
        didSet {
            self.layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable
    var borderColor: UIColor = UIColor.clear {
        didSet {
            self.layer.borderColor = borderColor.cgColor
        }
    }
}
