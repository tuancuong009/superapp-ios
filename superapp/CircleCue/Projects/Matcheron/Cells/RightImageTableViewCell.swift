//
//  RightImageTableViewCell.swift
//  Matcheron
//
//  Created by QTS Coder on 5/11/24.
//

import UIKit

class RightImageTableViewCell: UITableViewCell {
    var tapImage: (() ->())?
    @IBOutlet weak var imgCell: UIImageView!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var icRead: UIImageView!
    @IBOutlet weak var bubble: UIView!
    @IBOutlet weak var imgPlayVideo: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func doImage(_ sender: Any) {
        self.tapImage?()
    }
}
