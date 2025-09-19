//
//  SelectAllTableViewCell.swift
//  CircleCue
//
//  Created by QTS Coder on 11/4/20.
//

import UIKit

class SelectAllTableViewCell: UITableViewCell {

    @IBOutlet weak var selectAllButton: UIButton!
    
    weak var delegate: EditProfileDelegate?
    var item: EditSocialObject?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        item = nil
    }
    
    func setup(item: EditSocialObject) {
        self.item = item
        selectAllButton.setHomePrivateStatus(item.isSelectingAll)
    }
    
    @IBAction func selectAllAction(_ sender: Any) {
        guard let item = item else { return }
        delegate?.selectingAll(item: item)
    }
}
