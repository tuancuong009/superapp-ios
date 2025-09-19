//
//  SearchReviewsViewController.swift
//  CircleCue
//
//  Created by QTS Coder on 1/19/21.
//

import UIKit
import Alamofire

class SearchReviewsViewController: BaseViewController {

    @IBOutlet weak var searchUserButton: UIButton!
    @IBOutlet weak var inputManualButton: UIButton!
    @IBOutlet weak var searchUserTextField: SearchTextField!
    @IBOutlet weak var searchUserOverlayView: UIView!
    @IBOutlet weak var inputUserOverlayView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchManualTextField: UITextField!
    @IBOutlet weak var noDataLabel: UILabel!

    private var currentIndex: Int = 0
    private var businessUsers: [BusinessUserObject] = []
    
    private var reviews: [Review] = [] {
        didSet {
            noDataLabel.isHidden = !reviews.isEmpty
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        fetchBusinessUserList()
    }

    @IBAction func selectTypeUserAction(_ sender: UIButton) {
        guard currentIndex != sender.tag else { return }
        if sender.tag == 0 {
            searchUserButton.setImage(#imageLiteral(resourceName: "ic_radio_selected_20"), for: .normal)
            inputManualButton.setImage(#imageLiteral(resourceName: "ic_radio_white"), for: .normal)
            searchUserOverlayView.isHidden = false
            inputUserOverlayView.isHidden = true
        } else {
            inputManualButton.setImage(#imageLiteral(resourceName: "ic_radio_selected_20"), for: .normal)
            searchUserButton.setImage(#imageLiteral(resourceName: "ic_radio_white"), for: .normal)
            searchUserOverlayView.isHidden = true
            inputUserOverlayView.isHidden = false
        }
        currentIndex = sender.tag
        self.view.endEditing(true)
    }
    
    @IBAction func searchAction(_ sender: Any) {
        view.endEditing(true)
        let term = searchManualTextField.text?.trimmed
        searchReviews(term)
        searchUserTextField.text = nil
    }
}

extension SearchReviewsViewController {
    
    private func fetchBusinessUserList() {
        showSimpleHUD()
        ManageAPI.shared.fetchBusinessUserList {[weak self] (users) in
            guard let self = self else { return }
            self.hideLoading()
            self.businessUsers = users
            DispatchQueue.main.async {
                self.configureSimpleSearchTextField()
            }
        }
    }
    
    private func searchReviews(_ term: String?) {
        noDataLabel.isHidden = true
        showSimpleHUD()
        var para: Parameters?
        if let term = term {
            para = ["search": term]
        }
        ManageAPI.shared.searchReviews(para) {[weak self] (results, error) in
            guard let self = self else { return }
            self.hideLoading()
            DispatchQueue.main.async {
                if let err = error {
                    self.reviews = []
                    self.tableView.reloadData()
                    self.showAlert(title: "Oops!", message: err)
                    return
                }
                self.reviews = results
                self.tableView.reloadData()
            }
        }
    }
}

extension SearchReviewsViewController {
    
    private func setup() {
        setupUI()
        setupTableView()
        setupTextField()
    }
    
    private func setupUI() {
        currentIndex = 0
        searchUserButton.setImage(#imageLiteral(resourceName: "ic_radio_selected_20"), for: .normal)
        inputManualButton.setImage(#imageLiteral(resourceName: "ic_radio_white"), for: .normal)
        searchUserOverlayView.isHidden = false
        inputUserOverlayView.isHidden = true
        
        noDataLabel.text = "No Reviews Found"
        noDataLabel.isHidden = true
    }
    
    private func setupTableView() {
        tableView.registerNibCell(identifier: SearchReviewTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    private func setupTextField() {
        searchManualTextField.delegate = self
        searchUserTextField.addPaddingLeft(10)
    }

    private func configureSimpleSearchTextField() {
        searchUserTextField.theme.cellHeight = 44
        searchUserTextField.theme.bgColor = .white
        searchUserTextField.theme.font = UIFont.myriadProRegular(ofSize: 15)
        searchUserTextField.theme.separatorColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 0.8)
        searchUserTextField.highlightAttributes = [NSAttributedString.Key.foregroundColor: UIColor.red, NSAttributedString.Key.font: UIFont.myriadProBold(ofSize: 17)]
        searchUserTextField.startVisible = true
        let tags = businessUsers.map({$0.username})
        searchUserTextField.filterStrings(tags)
        searchUserTextField.delegate = self
        
        searchUserTextField.itemSelectionHandler = {[weak self] (filterResult, index) in
            guard let self = self else { return }
            self.searchUserTextField.text = filterResult[index].title
            self.view.endEditing(true)
            self.searchReviews(filterResult[index].title)
            self.searchManualTextField.text = nil
        }
    }
    
    private func reset() {
        searchUserTextField.text = nil
        setupUI()
    }
    
    private func showNotFoundUserAlert() {
        let titleAttribute: [NSAttributedString.Key: Any] = [.font: UIFont.myriadProSemiBold(ofSize: 16), .foregroundColor: UIColor.black]
        let messageAttribute: [NSAttributedString.Key: Any] = [.font: UIFont.myriadProRegular(ofSize: 14), .foregroundColor: UIColor.black]
        
        let titleString = NSAttributedString(string: "Oops!", attributes: titleAttribute)
        let messageString = NSAttributedString(string: "Business user not found.", attributes: messageAttribute)
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        alertController.setValue(titleString, forKey: "attributedTitle")
        alertController.setValue(messageString, forKey: "attributedMessage")
        
        let closeAction = UIAlertAction(title: "Close", style: .cancel) { (action) in
            self.searchUserTextField.becomeFirstResponder()
        }
        
        alertController.addAction(closeAction)
        present(alertController, animated: true, completion: nil)
    }
}

extension SearchReviewsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchReviewTableViewCell.identifier, for: indexPath) as! SearchReviewTableViewCell
        let review = reviews[indexPath.row]
        cell.setup(review)
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.row < reviews.count else { return }
        let controller = OldFeedbackDetailViewController.instantiate()
        controller.review = reviews[indexPath.row]
        controller.viewing = true
        navigationController?.pushViewController(controller, animated: true)
    }
}

extension SearchReviewsViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case searchManualTextField:
            let term = searchManualTextField.text?.trimmed
            textField.resignFirstResponder()
            searchReviews(term)
            searchUserTextField.text = nil
        default:
            break
        }
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard textField == searchUserTextField else { return }
        if let text = textField.trimmedText, !text.isEmpty {
            let tags = businessUsers.map({$0.username})
            if !tags.contains(text) {
                showNotFoundUserAlert()
            }
        }
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return true
    }
}

extension SearchReviewsViewController: ReviewDelegate {
    func viewUserProfile(_ review: Review) {
        print(review)
        if review.uid1 == AppSettings.shared.userLogin?.userId {
            let controller = MyProfileViewController.instantiate()
            navigationController?.pushViewController(controller, animated: true)
        } else {
            let controller = FriendProfileViewController.instantiate()
            controller.basicInfo = UniversalUser(id: review.uid1, username: review.rname, country: nil, pic: nil)
            navigationController?.pushViewController(controller, animated: true)
        }
    }
}
