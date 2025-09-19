//
//  SearchEventsViewController.swift
//  CircleCue
//
//  Created by QTS Coder on 25/04/2022.
//

import UIKit

class SearchEventsViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var noDataLabel: UILabel!

    var events: [Blog_Job] = [] {
        didSet {
            noDataLabel.isHidden = !events.isEmpty
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        noDataLabel.text = "No Events Found"
        noDataLabel.isHidden = true
        setupTextField()
        setupTableView()
    }
    
    @IBAction func searchAction(_ sender: Any) {
        guard let term = searchTextField.text?.trimmed else { return }
        view.endEditing(true)
        searchEvent(term)
    }
}

extension SearchEventsViewController {
    
    private func setupTableView() {
        tableView.registerNibCell(identifier: JobOfferTableViewCell.identifier)
        tableView.registerNibCell(identifier: ImageJobOfferTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
    }
    
    private func setupTextField() {
        searchTextField.delegate = self
    }

    private func searchEvent(_ term: String) {
        noDataLabel.isHidden = true
        showSimpleHUD()
        ManageAPI.shared.searchEvent(query: term) {[weak self] (results) in
            guard let self = self else { return }
            self.hideLoading()
            DispatchQueue.main.async {
                self.events = results
                self.tableView.reloadData()
            }
        }
    }
}

extension SearchEventsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = events[indexPath.row]
        if item.imageItem {
            let cell = tableView.dequeueReusableCell(withIdentifier: ImageJobOfferTableViewCell.identifier, for: indexPath) as! ImageJobOfferTableViewCell
            cell.setupSearchEvent(item)
            cell.delegate = self
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: JobOfferTableViewCell.identifier, for: indexPath) as! JobOfferTableViewCell
        cell.setupSearchEvent(item)
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.row < events.count else { return }
        let controller = BlogDetailsViewController.instantiate()
        controller.viewType = .blog
        controller.item = events[indexPath.row]
        controller.isFromSearch = true
        navigationController?.pushViewController(controller, animated: true)
    }
}

extension SearchEventsViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let term = searchTextField.text?.trimmed else { return false }
        textField.resignFirstResponder()
        searchEvent(term)
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return true
    }
}

extension SearchEventsViewController: AddJobOffseDelegate {
    
    func shouldReloadData() {
    }
    
    func viewImage(imageView: UIImageView) {
        self.showSimplePhotoViewer(for: imageView, image: imageView.image)
    }
    
    func viewUserProfile(id: String) {
        if id == AppSettings.shared.userLogin?.userId {
            let controller = MyProfileViewController.instantiate()
            navigationController?.pushViewController(controller, animated: true)
        } else {
            let controller = FriendProfileViewController.instantiate()
            controller.basicInfo = UniversalUser(id: id, username: nil, country: nil, pic: nil)
            navigationController?.pushViewController(controller, animated: true)
        }
    }
}
