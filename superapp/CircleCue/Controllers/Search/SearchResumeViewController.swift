//
//  SearchResumeViewController.swift
//  CircleCue
//
//  Created by QTS Coder on 3/12/21.
//

import UIKit
import Alamofire

class SearchResumeViewController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var noDataLabel: UILabel!

    var resumes: [SearchResume] = [] {
        didSet {
            noDataLabel.isHidden = !resumes.isEmpty
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        noDataLabel.text = "No Resumes Found"
        noDataLabel.isHidden = true
        setupTextField()
        setupTableView()
        
        searchUser("")
    }
    
    @IBAction func searchAction(_ sender: Any) {
        guard let term = searchTextField.text?.trimmed else {
            return
        }
        view.endEditing(true)
        searchUser(term)
    }
}

extension SearchResumeViewController {
    
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
    
    private func searchUser(_ term: String) {
        noDataLabel.isHidden = true
        showSimpleHUD()
        let para: Parameters = ["search": term]
        ManageAPI.shared.searchResumes(para) {[weak self] (results, error) in
            guard let self = self else { return }
            self.hideLoading()
            DispatchQueue.main.async {
                if let err = error {
                    self.showAlert(title: "Oops!", message: err)
                    return
                }
                self.resumes = results
                self.tableView.reloadData()
            }
        }
    }
}

extension SearchResumeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resumes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = resumes[indexPath.row]
        if item.imageItem {
            let cell = tableView.dequeueReusableCell(withIdentifier: ImageJobOfferTableViewCell.identifier, for: indexPath) as! ImageJobOfferTableViewCell
            cell.setupSearchResume(item)
            cell.delegate = self
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: JobOfferTableViewCell.identifier, for: indexPath) as! JobOfferTableViewCell
        cell.setupSearchResume(item)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.row < resumes.count else { return }
        let item = resumes[indexPath.row]
        let controller = ResumeViewController.instantiate()
        controller.user = UserInfomation(item: item)
        navigationController?.pushViewController(controller, animated: true)
    }
}

extension SearchResumeViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let term = searchTextField.text?.trimmed else {
            return true
        }
        textField.resignFirstResponder()
        searchUser(term)
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return true
    }
}

extension SearchResumeViewController: AddJobOffseDelegate {
    func shouldReloadData() {
    }
    
    func viewImage(imageView: UIImageView) {
        self.showSimplePhotoViewer(for: imageView, image: imageView.image)
    }
}
