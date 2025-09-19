//
//  PremierCircleShowcaseController.swift
//  CircleCue
//
//  Created by QTS Coder on 12/30/20.
//

import UIKit
import Alamofire

class PremierCircleShowcaseController: BaseViewController {

    @IBOutlet weak var userTypeView: UIView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var userTypeTextField: UITextField!
    @IBOutlet weak var searchCityTextField: CustomTextField!
    @IBOutlet weak var searchContainerView: UIView!
    
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var joinButton: UIButton!
    
    private var dropDown = DropDown()
    private var refreshControl = UIRefreshControl()
    
    private var users: [UniversalUser] = []
    private let dataSource = ["Personal A/C", "Business A/C"]
    private var isRefreshing: Bool = false
    private var currentSearchTerm: String?
    private var searchCity: String?
    
    private var selectedIndex: Int = 0 {
        didSet {
            searchTextField.placeholder = selectedIndex == 0 ? "Username/Occupation" : "Username/Industry"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        searchUser(nil, city: nil)
    }
    
    @IBAction func chooseUserTypeAction(_ sender: Any) {
        dropDown.show()
    }
    
    @IBAction func searchAction(_ sender: Any) {
        let term = searchTextField.text?.trimmed
        let city = searchCityTextField.text?.trimmed
        view.endEditing(true)
        searchUser(term, city: city)
    }
    
    @IBAction func didTapLogJoinButton(_ sender: UIButton) {
        if sender.tag == 0 {
            self.navigationController?.pushViewController(LoginVC.instantiate(from: StoryboardName.authentication.rawValue), animated: true)
        } else {
            var viewController = self.navigationController!.viewControllers
            viewController.append(LoginVC.instantiate(from: StoryboardName.authentication.rawValue))
            viewController.append(RegisterViewController.instantiate(from: StoryboardName.authentication.rawValue))
            self.navigationController?.setViewControllers(viewController, animated: true)
        }
    }
    
    @IBAction func didTapBackAction(_ sender: Any) {
        if AppSettings.shared.currentUser == nil{
            APP_DELEGATE.setRoot()
        }
        else{
            navigationController?.popViewController(animated: true)
        }
        
    }
}

extension PremierCircleShowcaseController {
    
    private func setup() {
        selectedIndex = 0
        setupUI()
        setupDropdown()
        setupTextField()
        setupCollectionView()
        setupRefreshControl()
    }
    
    private func setupUI() {
        searchButton.layer.borderColor = UIColor.white.cgColor
        searchButton.layer.borderWidth = 0.5
        //backButton.isHidden = AppSettings.shared.currentUser == nil
        searchContainerView.isHidden = AppSettings.shared.currentUser == nil
        loginButton.isHidden = AppSettings.shared.currentUser != nil
        joinButton.isHidden = loginButton.isHidden
        if let user = AppSettings.shared.currentUser {
            if user.accountType == .business {
                selectedIndex = 1
            } else {
                selectedIndex = 0
            }
        }
        userTypeTextField.text = dataSource[selectedIndex]
    }
    
    private func setupRefreshControl() {
        refreshControl.tintColor = UIColor.white
        let attributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.myriadProRegular(ofSize: 12)]
        refreshControl.attributedTitle = NSAttributedString(string: "Refreshing...", attributes: attributes)
        refreshControl.addTarget(self, action: #selector(self.refresh), for: .valueChanged)
        collectionView.refreshControl = refreshControl
    }
    
    private func setupTextField() {
        searchTextField.delegate = self
        searchCityTextField.placeholder = "Location"
    }
    
    private func setupDropdown() {
        dropDown.anchorView = userTypeView
        dropDown.dataSource = dataSource
        dropDown.selectRow(selectedIndex)
        dropDown.bottomOffset = CGPoint(x: 0, y: userTypeView.frame.height + 5)
        dropDown.direction = .bottom
        dropDown.textFont = UIFont.myriadProRegular(ofSize: 14)
        dropDown.cellHeight = 40.0
        dropDown.animationduration = 0.2
        dropDown.backgroundColor = UIColor.white
        dropDown.selectionBackgroundColor = UIColor.init(hex: "e0e0e0")
        dropDown.cornerRadius = 8
        dropDown.selectionAction = {[weak self] (index: Int, item: String) in
            guard let self = self else { return }
            self.userTypeTextField.text = item
            self.selectedIndex = index
            self.currentSearchTerm = self.searchTextField.text?.trimmed
            self.searchCity = self.searchCityTextField.text?.trimmed
            self.searchUser(self.currentSearchTerm, city: self.searchCity)
        }
    }
    
    private func setupCollectionView() {
        collectionView.registerNibCell(identifier: FeedPageCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    private func searchUser(_ term: String?, city: String?) {
        showSimpleHUD()
        self.currentSearchTerm = term
        self.searchCity = city
        var para: Parameters = ["type": selectedIndex]
        if let term = term {
            para.updateValue(term, forKey: "search")
        }
        if let city = city {
            para.updateValue(city, forKey: "city")
        }
        
        ManageAPI.shared.fetchShowCase(para) {[weak self] (results) in
            guard let self = self else { return }
            self.hideLoading()
            self.isRefreshing = false
            DispatchQueue.main.async {
                self.users = results
                self.collectionView.reloadData()
                self.refreshControl.endRefreshing()
            }
        }
    }
    
    @objc private func refresh() {
        guard !isRefreshing else { return }
        isRefreshing = true
        refreshControl.beginRefreshing()
        searchUser(currentSearchTerm, city: self.searchCity)
    }
}

extension PremierCircleShowcaseController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return users.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeedPageCollectionViewCell.identifier, for: indexPath) as! FeedPageCollectionViewCell
        cell.setup(users[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (UIScreen.main.bounds.width - 43) / 3
        var height: CGFloat = width*0.86 + 80
        if UIDevice.current.userInterfaceIdiom == .pad {
            height += 50
        }
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard indexPath.row < users.count else { return }
        let user = users[indexPath.row]
        if user.id == AppSettings.shared.userLogin?.userId {
            navigationController?.pushViewController(MyProfileViewController.instantiate(), animated: true)
        } else {
            let controller = FriendProfileViewController.instantiate()
            controller.basicInfo = user
            navigationController?.pushViewController(controller, animated: true)
        }
    }
}

extension PremierCircleShowcaseController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        switch textField {
        case searchTextField:
            self.currentSearchTerm = searchTextField.text?.trimmed
        case searchCityTextField:
            self.searchCity = searchCityTextField.text?.trimmed
        default:
            break
        }
        searchUser(self.currentSearchTerm, city: self.searchCity)
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        switch textField {
        case searchTextField:
            self.currentSearchTerm = nil
        case searchCityTextField:
            self.searchCity = nil
        default:
            break
        }
        return true
    }
}
