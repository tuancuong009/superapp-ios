//
//  HeaderProfileActionTableViewCell.swift
//  CircleCue
//
//  Created by QTS Coder on 27/12/24.
//

import UIKit
protocol HeaderProfileActionTableViewCellDelegate: AnyObject{
    func didSelectTab(_ index: Int)
}
class HeaderProfileActionTableViewCell: UITableViewCell {
    @IBOutlet var arrButtons: [UIButton]!
    @IBOutlet var arrSelecteds: [UIView]!
    weak var delegate: HeaderProfileActionTableViewCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateTab(_ indexTab: Int){
        for i in 0..<arrButtons.count{
            if i == indexTab{
                arrButtons[i].isSelected = true
            }
            else{
                arrButtons[i].isSelected = false
            }
        }
        for i in 0..<arrSelecteds.count{
            if i == indexTab{
                arrSelecteds[i].isHidden = false
            }
            else{
                arrSelecteds[i].isHidden = true
            }
        }
    }
    
    @IBAction func doAction(_ sender: Any) {
        guard let btn = sender as? UIButton else {
            return
        }
        self.delegate?.didSelectTab(btn.tag)
        for i in 0..<arrButtons.count{
            if i == btn.tag{
                arrButtons[i].isSelected = true
            }
            else{
                arrButtons[i].isSelected = false
            }
        }
        for i in 0..<arrSelecteds.count{
            if i == btn.tag{
                arrSelecteds[i].isHidden = false
            }
            else{
                arrSelecteds[i].isHidden = true
            }
        }
    }
}
