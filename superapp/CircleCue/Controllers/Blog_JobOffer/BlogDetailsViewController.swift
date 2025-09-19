//
//  BlogDetailsViewController.swift
//  CircleCue
//
//  Created by QTS Coder on 2/2/21.
//

import UIKit

class BlogDetailsViewController: BaseViewController {

    @IBOutlet weak var mediaView: UIView!
    @IBOutlet weak var mediaImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var postedByUserLabel: UILabel!
    @IBOutlet weak var postedByView: UIView!
    
    var item: Blog_Job?
    var viewType: MenuItem = .jobOffer
    var isFromSearch = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if viewType == .jobOffer {
            self.topBarMenuView.title = "Job Posting Details"
            self.postedByView.isHidden = true
        } else {
            self.topBarMenuView.title = "Blog/Event/News Article Details"
        }
        
        setupUI()
    }
    
    private func setupUI() {
        descriptionTextView.font = UIFont.myriadProRegular(ofSize: 17)
        descriptionTextView.linkTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white,
                                                  NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue,
                                                  NSAttributedString.Key.underlineColor: UIColor.white]
        
        guard let item = item else { return }
        mediaView.isHidden = !item.imageItem
        mediaImageView.setImage(with: item.media, placeholderImage: .photo)
        titleLabel.text = item.title
        descriptionTextView.text = item.content
        dateLabel.text = item.date
        postedByUserLabel.text = item.username
        postedByView.isHidden = item.username.trimmed.isEmpty || !isFromSearch
    }

    @IBAction func viewPhotoAction(_ sender: Any) {
        self.showSimplePhotoViewer(for: mediaImageView, image: mediaImageView.image)
    }
    
    @IBAction func didTapPostedByUser(_ sender: Any) {
        guard let item = item else { return }
        if item.u_id == AppSettings.shared.userLogin?.userId {
            let controller = MyProfileViewController.instantiate()
            navigationController?.pushViewController(controller, animated: true)
        } else {
            let controller = FriendProfileViewController.instantiate()
            controller.basicInfo = UniversalUser(id: item.u_id, username: nil, country: nil, pic: nil)
            navigationController?.pushViewController(controller, animated: true)
        }
    }
}
