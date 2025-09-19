//
//  AddSocialTableViewCell.swift
//  CircleCue
//
//  Created by QTS Coder on 10/4/20.
//

import UIKit

class AddSocialTableViewCell: UITableViewCell {

    @IBOutlet weak var socialImageView: UIImageView!
    @IBOutlet weak var domainLabel: UILabel!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var privateButton: UIButton!
    @IBOutlet weak var viewContent: UIView!
    
    static let cellHeight: CGFloat = 70.0
    var socialMedia: SocialMediaObj?
    weak var delegate: RegisterViewControllerDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        usernameTextField.delegate = self
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        socialMedia = nil
    }
    
    func setup(socialMedia: SocialMediaObj) {
        self.socialMedia = socialMedia
        socialImageView.image = socialMedia.type.image
        domainLabel.text = socialMedia.type.domain
        usernameTextField.text = socialMedia.username
        usernameTextField.placeholder = socialMedia.type.placeHolder
        privateButton.setPrivateStatus(socialMedia.isPrivate)
        
        viewContent.layer.cornerRadius = 10
        viewContent.layer.borderWidth = 1.0
        viewContent.layer.borderColor = UIColor.init(hex: "DDDDDD").cgColor
    }

    @IBAction func privateAction(_ sender: UIButton) {
        self.socialMedia?.isPrivate.toggle()
        privateButton.setPrivateStatus(socialMedia?.isPrivate ?? false)
        delegate?.update(socialMedia)
    }
    
    private func updateUsername() {
        guard let domain = socialMedia?.type.domain,  let username = socialMedia?.username else { return }
        domainLabel.text = domain + username
    }
    
    @IBAction func socialLoginAction(_ sender: UIButton) {
        guard let social = socialMedia else { return }
        delegate?.socialLogin(social)
    }
    
}

extension AddSocialTableViewCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        socialMedia?.username = textField.text?.trimmingCharacters(in: .whitespaces)
        delegate?.update(socialMedia)
        print(socialMedia as Any)
        updateUsername()
    }
}

extension UIButton {
    
    func setHomePrivateStatus(_ isPrivate: Bool) {
        setImage(isPrivate ? #imageLiteral(resourceName: "ic_radio_white_selected") : #imageLiteral(resourceName: "ic_radio_white"), for: .normal)
    }
    
    func setPrivateStatus(_ isPrivate: Bool) {
        setImage(isPrivate ? #imageLiteral(resourceName: "ic_radio_selected_20") : #imageLiteral(resourceName: "ic_radio_20"), for: .normal)
    }
    
    func setAgreeTerm(_ isAgree: Bool) {
        setImage(isAgree ? #imageLiteral(resourceName: "ic_radio_selected") : #imageLiteral(resourceName: "ic_radio"), for: .normal)
    }
    
    func setSelected(_ isSelected: Bool) {
        setImage(isSelected ? #imageLiteral(resourceName: "ic_radio_selected_20") : UIImage(named: "ic_radio_white_20"), for: .normal)
    }
}
