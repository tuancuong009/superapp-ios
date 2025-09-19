//
//  SearchProfileViewController.swift
//  CircleCue
//
//  Created by QTS Coder on 10/6/20.
//

import UIKit
import Alamofire

class SearchProfileViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var noDataLabel: UILabel!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var searchCityTextField: UITextField!
    
    var users: [UniversalUser] = [] {
        didSet {
            noDataLabel.isHidden = !users.isEmpty
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTextField()
        setupTableView()
    }
    
    @IBAction func searchAction(_ sender: Any) {
        view.endEditing(true)
        let term = searchTextField.text?.trimmed
        let city = searchCityTextField.text?.trimmed
        searchUser(term, city: city)
    }
}

extension SearchProfileViewController {
    
    private func setupUI() {
        noDataLabel.text = "No Users Found"
        noDataLabel.isHidden = true
        searchButton.layer.cornerRadius = 4
        searchButton.layer.borderWidth = 0.5
        searchButton.layer.borderColor = UIColor.white.cgColor
    }
    
    private func setupTableView() {
        tableView.registerNibCell(identifier: SearchTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
    }
    
    private func setupTextField() {
        searchTextField.delegate = self
        searchCityTextField.delegate = self
    }
    
    private func searchUser(_ term: String?, city: String?) {
        noDataLabel.isHidden = true
        showSimpleHUD()
        var para = Parameters()
        if let term = term {
            para.updateValue(term, forKey: "search")
        }
        if let city = city {
            para.updateValue(city, forKey: "city")
        }
        ManageAPI.shared.search(para) {[weak self] (results, error) in
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

extension SearchProfileViewController: UITableViewDelegate, UITableViewDataSource {
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

extension SearchProfileViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        let term = searchTextField.text?.trimmed
        let city = searchCityTextField.text?.trimmed
        searchUser(term, city: city)
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return true
    }
}
