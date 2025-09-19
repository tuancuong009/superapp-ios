//
//  LikesViewController.swift
//  CircleCue
//
//  Created by QTS Coder on 1/6/21.
//

import UIKit

class LikesViewController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noDataLabel: UILabel!
    
    var likes: [PhotoLike] = []
    var photoId: String?
    
    var didDismisController: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        noDataLabel.text = "No Likes."
        setupTableView()
        if let photoId = photoId {
            fetchPhotoLike(id: photoId)
            noDataLabel.isHidden = true
        } else {
            noDataLabel.isHidden = !likes.isEmpty
        }
    }
    
    override func backAction() {
        dismiss(animated: true) {
            self.didDismisController?()
        }
    }
}

extension LikesViewController {
    private func setupTableView() {
        tableView.registerNibCell(identifier: PhotoLikeTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 70
        tableView.backgroundColor = .clear
    }
    
    private func fetchPhotoLike(id: String) {
        self.showSimpleHUD()
        ManageAPI.shared.fetchPhotoLikes(id) {[weak self] (likes, error) in
            guard let self = self else { return }
            self.hideLoading()
            DispatchQueue.main.async {
                if error == nil {
                    self.likes = likes
                    self.noDataLabel.isHidden = !likes.isEmpty
                    self.tableView.reloadData()
                    return
                }
                self.showErrorAlert(message: error?.msg)
            }
        }
    }
}

extension LikesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return likes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PhotoLikeTableViewCell.identifier, for: indexPath) as! PhotoLikeTableViewCell
        cell.setup(likes[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.row < likes.count else { return }
        let user = likes[indexPath.row]
        
        if user.uid == AppSettings.shared.userLogin?.userId {
            let controller = MyProfileViewController.instantiate()
            navigationController?.pushViewController(controller, animated: true)
        } else {
            let controller = FriendProfileViewController.instantiate()
            controller.basicInfo = UniversalUser(likeUser: user)
            navigationController?.pushViewController(controller, animated: true)
        }
    }
}
