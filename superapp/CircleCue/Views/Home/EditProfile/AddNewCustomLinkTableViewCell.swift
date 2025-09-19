//
//  AddNewCustomLinkTableViewCell.swift
//  CircleCue
//
//  Created by QTS Coder on 10/16/20.
//

import UIKit

class AddNewCustomLinkTableViewCell: UITableViewCell {
    
    weak var delegate: EditProfileDelegate?
    
    @IBAction func addMoreAction(_ sender: Any) {
        delegate?.addMoreCustomLink()
    }
}
