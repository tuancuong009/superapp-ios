//
//  VisitorStatTableViewCell.swift
//  CircleCue
//
//  Created by QTS Coder on 10/19/20.
//

import UIKit

class VisitorStatTableViewCell: UITableViewCell {

    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    
    func setup(vistor: Visitor) {
        locationLabel.text = vistor.country.trimmed.isEmpty ? " " : vistor.country.trimmed
        numberLabel.text = vistor.countt.toVistorStats
    }
}
