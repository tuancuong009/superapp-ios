//
//  GroupHeaderView.swift
//  CircleCue
//
//  Created by QTS Coder on 10/7/20.
//

import UIKit

protocol GroupHeaderViewDelegate: AnyObject {
    func expanding(_ item: EditSocialObject)
}

class GroupHeaderView: UIView {

    @IBOutlet private var contentView: UIView!
    @IBOutlet public weak var groupButton: HeaderButton!
    
    static let height: CGFloat = 50.0
    weak var delegate: GroupHeaderViewDelegate?
    var item: EditSocialObject?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadNib()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadNib()
    }
    
    private func loadNib() {
        Bundle.main.loadNibNamed("GroupHeaderView", owner: self, options: nil)
        self.addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    func setup(item: EditSocialObject) {
        self.item = item
        groupButton.titleLabel?.text = item.type.title
        groupButton.setTitle(item.type.title, for: .normal)
        groupButton.isSelected = item.isExpanding
    }
    
    
    @IBAction func expandingAction(_ sender: Any) {
        guard let item = self.item else { return }
        delegate?.expanding(item)
    }
}
