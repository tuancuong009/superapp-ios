//
//  WebsiteTableViewCell.swift
//  CircleCue
//
//  Created by QTS Coder on 10/4/20.
//

import UIKit

class WebsiteTableViewCell: UITableViewCell {
    
    @IBOutlet weak var socialImageView: UIImageView!
    @IBOutlet weak var websiteTextField: UITextField!
    @IBOutlet weak var privateButton: UIButton!
    
    static let cellHeight: CGFloat = 70.0
    var socialMedia: SocialMediaObj?
    weak var delegate: RegisterViewControllerDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        websiteTextField.delegate = self
        websiteTextField.attributedPlaceholder = NSAttributedString(string: "https://www.yourblog.com", attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(hex: "4F061C")])
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        socialMedia = nil
    }
    
    func setup(socialMedia: SocialMediaObj) {
        self.socialMedia = socialMedia
       // socialImageView.tintColor = UIColor.black
        socialImageView.image = UIImage.init(named: "app_blog")
        websiteTextField.text = socialMedia.username
        privateButton.setPrivateStatus(socialMedia.isPrivate)
    }

    @IBAction func privateAction(_ sender: UIButton) {
        self.socialMedia?.isPrivate.toggle()
        privateButton.setPrivateStatus(socialMedia?.isPrivate ?? false)
        delegate?.update(socialMedia)
    }
    
}

extension WebsiteTableViewCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        socialMedia?.username = textField.text?.trimmingCharacters(in: .whitespaces)
        delegate?.update(socialMedia)
        print(socialMedia as Any)
    }
}
