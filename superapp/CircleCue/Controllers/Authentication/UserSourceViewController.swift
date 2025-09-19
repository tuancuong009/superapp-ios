//
//  UserSourceViewController.swift
//  CircleCue
//
//  Created by QTS Coder on 11/07/2022.
//

import UIKit
import SwiftUI

enum UserSource: Equatable {
    case google
    case facebook
    case instagram
    case apple
    case microsoft
    case linkedin
    case other(text: String)
    
    var name: String {
        switch self {
        case .google:
            return "Google"
        case .facebook:
            return "Facebook"
        case .instagram:
            return "Instagram"
        case .apple:
            return "Apple Search Ads"
        case .microsoft:
            return "Microsoft/Bing"
        case .linkedin:
            return "Linkedin"
        case .other:
            return "Other"
        }
    }
    
    var para: String {
        switch self {
        case .google:
            return "google"
        case .facebook:
            return "facebook"
        case .instagram:
            return "instagram"
        case .apple:
            return "apple search ads"
        case .microsoft:
            return "microsoft"
        case .linkedin:
            return "linkedin"
        case .other(let text):
            return "other-\(text)"
        }
    }
    
    var isHidden: Bool {
        switch self {
        case .other:
            return false
        default:
            return true
        }
    }
}

class UserSourceViewController: BaseViewController {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    
    private var selectedSource: UserSource?
    private var sources: [UserSource] = [.google, .facebook, .instagram, .apple, .linkedin, .microsoft, .other(text: "")]
    
    var didSubmit: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1, options: [.curveEaseOut, .allowUserInteraction]) {
            self.containerView.transform = .identity
            self.view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        } completion: {_ in
        }
    }
    
    @IBAction func didTapCancelButton(_ sender: Any) {
        self.closeView()
    }
    
    @IBAction func didTapSubmitButton(_ sender: Any) {
        guard let id = AppSettings.shared.userLogin?.userId, let source = selectedSource else { return }
        self.showSimpleHUD(fromView: self.view)
        ManageAPI.shared.submitUserSource(id: id, source: source.para) {[weak self] error in
            guard let self = self else { return }
            self.hideLoading()
            DispatchQueue.main.async {
                print(error?.msg as Any)
                self.closeView {
                    self.didSubmit?()
                }
            }
        }
    }
}

extension UserSourceViewController {
    
    private func setupUI() {
        containerView.backgroundColor = .white
        containerView.transform = CGAffineTransform(translationX: 0, y: UIScreen.main.bounds.height/2 + containerView.frame.height/2)
        self.view.backgroundColor = .clear
    }
    
    private func setupTableView() {
        tableView.registerNibCell(identifier: UserSourceTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 46
        tableView.isScrollEnabled = false
        tableViewHeightConstraint.constant = sources.count.cgFloat * tableView.rowHeight
    }
    
    private func closeView(completion: (() -> Void)? = nil) {
        self.view.endEditing(true)
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 1, options: [.curveLinear, .allowUserInteraction]) {
            self.containerView.transform = CGAffineTransform(translationX: 0, y: UIScreen.main.bounds.height/2 + self.containerView.frame.height / 2)
            self.view.backgroundColor = .clear
        } completion: { _ in
            self.dismiss(animated: false, completion: completion)
        }
    }
}

extension UserSourceViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sources.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UserSourceTableViewCell = tableView.dequeueCell(for: indexPath)
        cell.setup(source: sources[indexPath.row], isSelected: sources[indexPath.row] == selectedSource)
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.row < sources.count, sources[indexPath.row] != selectedSource else { return }
        selectedSource = sources[indexPath.row]
        tableView.reloadData()
    }
}

extension UserSourceViewController: UserSourceViewDelegate {
    func didSelectOtherSource(source: UserSource) {
        selectedSource = source
    }
}
