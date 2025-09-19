//
//  MenuContactTableViewCell.swift
//  CircleCue
//
//  Created by QTS Coder on 4/19/21.
//

import UIKit

class MenuContactTableViewCell: UITableViewCell {

    @IBOutlet weak var informTextFiled: UITextView!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var copyrightTextView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        informTextFiled.layer.borderWidth = 2
        informTextFiled.layer.borderColor = UIColor.white.cgColor
        
        informTextFiled.textContainerInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        contentTextView.textContainerInset = UIEdgeInsets(top: 10, left: 20, bottom: 20, right: 20)
        copyrightTextView.textContainerInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        
        contentTextView.linkTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.underlineStyle: NSUnderlineStyle.thick.rawValue]
    }
}
