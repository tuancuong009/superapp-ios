//
//  SearchDatingCircleViewController.swift
//  CircleCue
//
//  Created by QTS Coder on 1/19/21.
//

import UIKit
import Alamofire

class SearchDatingCircleViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var noDataLabel: UILabel!
    
    var searchType: SEARCHViewController.CircleSearchType = .Circles {
        didSet {
            print(searchType.rawValue)
            searchTextField.text = nil
            users.removeAll()
            noDataLabel.isHidden = true
            tableView.reloadData()
        }
    }
    
    var users: [UniversalUser] = [] {
        didSet {
            noDataLabel.isHidden = !users.isEmpty
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        noDataLabel.text = "No Users Found"
        noDataLabel.isHidden = true
        setupTextField()
        setupTableView()
    }
    
    @IBAction func searchAction(_ sender: Any) {
        handleSearch(searchEmptyString: true)
    }
}

extension SearchDatingCircleViewController {
    
    private func setupTableView() {
        tableView.registerNibCell(identifier: SearchTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    private func setupTextField() {
        searchTextField.delegate = self
    }
    
    private func handleSearch(searchEmptyString: Bool) {
        guard let term = searchTextField.text?.trimmed else { return }
        if !searchEmptyString, term.isEmpty {
            return
        }
        view.endEditing(true)
        switch searchType {
        case .Circles:
            searchAllCircleUser(term)
        case .Dating:
            searchDatingUser(term)
        case .DineOut:
            searchDinnerUser(term)
        case .Travel:
            searchTravelUser(term)
        }
    }
    
    private func searchAllCircleUser(_ term: String) {
        noDataLabel.isHidden = true
        showSimpleHUD()
        
        let parameter: Parameters = ["id": term, "circle": "1"]
        ManageAPI.shared.searchCircleUser(parameter) {[weak self] (results, error) in
            guard let self = self else { return }
            self.hideLoading()
            DispatchQueue.main.async {
                if let err = error {
                    self.showAlert(title: "Oops!", message: err)
                    return
                }
                self.users = results
                self.tableView.reloadData()
            }
        }
    }
    
    private func searchDatingUser(_ term: String) {
        guard let user = AppSettings.shared.currentUser, user.dating_status else { return }
        noDataLabel.isHidden = true
        showSimpleHUD()
        let para: Parameters = ["id": term, "dating": "1"]
        ManageAPI.shared.searchCircleUser(para) {[weak self] (results, error) in
            guard let self = self else { return }
            self.hideLoading()
            DispatchQueue.main.async {
                if let err = error {
                    self.showAlert(title: "Oops!", message: err)
                    return
                }
                self.users = results
                self.tableView.reloadData()
            }
        }
    }
    
    private func searchDinnerUser(_ term: String) {
        guard let user = AppSettings.shared.currentUser, let dinner = user.dinner_status, dinner == true else { return }
        noDataLabel.isHidden = true
        showSimpleHUD()
        let para: Parameters = ["id": term, "dinner": "1"]
        ManageAPI.shared.searchCircleUser(para) {[weak self] (results, error) in
            guard let self = self else { return }
            self.hideLoading()
            DispatchQueue.main.async {
                if let err = error {
                    self.showAlert(title: "Oops!", message: err)
                    return
                }
                self.users = results
                self.tableView.reloadData()
            }
        }
    }
    
    private func searchTravelUser(_ term: String) {
        guard let user = AppSettings.shared.currentUser, let travel = user.travel_status, travel == true else { return }
        noDataLabel.isHidden = true
        showSimpleHUD()
        let para: Parameters = ["id": term, "travel": "1"]
        ManageAPI.shared.searchCircleUser(para) {[weak self] (results, error) in
            guard let self = self else { return }
            self.hideLoading()
            DispatchQueue.main.async {
                if let err = error {
                    self.showAlert(title: "Oops!", message: err)
                    return
                }
                self.users = results
                self.tableView.reloadData()
            }
        }
    }
}

extension SearchDatingCircleViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SearchTableViewCell = tableView.dequeueCell(for: indexPath)
        cell.setup(users[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.row < users.count else { return }
        let user = users[indexPath.row]
        if user.id == AppSettings.shared.userLogin?.userId {
            let controller = MyProfileViewController.instantiate()
            navigationController?.pushViewController(controller, animated: true)
        } else {
            let controller = FriendProfileViewController.instantiate()
            controller.basicInfo = user
            navigationController?.pushViewController(controller, animated: true)
        }
    }
}

extension SearchDatingCircleViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        handleSearch(searchEmptyString: true)
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return true
    }
}
