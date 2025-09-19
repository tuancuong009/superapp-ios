//
//  SearchJobsViewController.swift
//  CircleCue
//
//  Created by QTS Coder on 3/12/21.
//

import UIKit
import Alamofire

class SearchJobsViewController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var noDataLabel: UILabel!

    var jobs: [SearchJob] = [] {
        didSet {
            noDataLabel.isHidden = !jobs.isEmpty
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        noDataLabel.text = "No Jobs Found"
        noDataLabel.isHidden = true
        setupTextField()
        setupTableView()
    }
    
    @IBAction func searchAction(_ sender: Any) {
        guard let term = searchTextField.text?.trimmed else { return }
        view.endEditing(true)
        searchUser(term)
    }
}

extension SearchJobsViewController {
    
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
        ManageAPI.shared.searchJobs(para) {[weak self] (results, error) in
            guard let self = self else { return }
            self.hideLoading()
            DispatchQueue.main.async {
                if let err = error {
                    self.showAlert(title: "Oops!", message: err)
                    return
                }
                self.jobs = results
                self.tableView.reloadData()
            }
        }
    }
}

extension SearchJobsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return jobs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = jobs[indexPath.row]
        if item.imageItem {
            let cell = tableView.dequeueReusableCell(withIdentifier: ImageJobOfferTableViewCell.identifier, for: indexPath) as! ImageJobOfferTableViewCell
            cell.setupSearchJob(item)
            cell.delegate = self
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: JobOfferTableViewCell.identifier, for: indexPath) as! JobOfferTableViewCell
        cell.setupSearchJob(item)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.row < jobs.count else { return }
        let controller = BlogDetailsViewController.instantiate()
        controller.viewType = .jobOffer
        controller.item = Blog_Job(searchItem: jobs[indexPath.row])
        navigationController?.pushViewController(controller, animated: true)
    }
}

extension SearchJobsViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let term = searchTextField.text?.trimmed else { return false }
        textField.resignFirstResponder()
        searchUser(term)
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return true
    }
}

extension SearchJobsViewController: AddJobOffseDelegate {
    func shouldReloadData() {
    }
    
    func viewImage(imageView: UIImageView) {
        self.showSimplePhotoViewer(for: imageView, image: imageView.image)
    }
}
