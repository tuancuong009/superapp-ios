//
//  JobOffersViewController.swift
//  CircleCue
//
//  Created by QTS Coder on 11/10/20.
//

import UIKit

class JobOffersViewController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noDataLabel: UILabel!
    @IBOutlet weak var introductionView: UIView!
    
    var viewType: MenuItem = .jobOffer
    var datas: [Blog_Job] = [] {
        didSet {
            self.noDataLabel.isHidden = !datas.isEmpty
            if viewing {
                self.introductionView.isHidden = true
            } else {
                self.introductionView.isHidden = self.noDataLabel.isHidden
            }
        }
    }
    
    var viewerId: String?
    var viewing: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
        
        if let userId = viewerId {
            fetchData(userId: userId)
            topBarMenuView.leftButtonType = 1
            topBarMenuView.showRightMenu = false
            viewing = true
        } else {
            guard let userId = AppSettings.shared.userLogin?.userId else { return }
            fetchData(userId: userId)
        }
    }
    
    override func addNote() {
        let controller = AddJobOfferViewController.instantiate()
        controller.viewType = viewType
        controller.delegate = self
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func seeVideoAction(_ sender: Any) {
        self.showOutsideAppWebContent(urlString: "https://youtu.be/U-HOpIzY9Y8")
    }
}

extension JobOffersViewController {
    
    private func fetchData(userId: String, _ loading: Bool = true) {
        showSimpleHUD()
        switch viewType {
        case .blog:
            ManageAPI.shared.fetchBlog(userId) {[weak self] (results) in
                guard let self = self else { return }
                self.hideLoading()
                DispatchQueue.main.async {
                    self.datas = results
                    self.tableView.reloadData()
                }
            }
        case .jobOffer:
            ManageAPI.shared.fetchJobs(userId) {[weak self] (results) in
                guard let self = self else { return }
                self.hideLoading()
                DispatchQueue.main.async {
                    self.datas = results
                    self.tableView.reloadData()
                }
            }
        default:
            break
        }
    }
    
    private func deleteItem(_ item: Blog_Job) {
        showSimpleHUD()
        switch viewType {
        case .blog:
            ManageAPI.shared.deleteBlog("\(item.id)") {[weak self] (error) in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    if let err = error {
                        self.hideLoading()
                        return self.showErrorAlert(message: err)
                    }
                    self.fetchData(userId: item.u_id)
                }
            }
        case .jobOffer:
            ManageAPI.shared.deleteJob("\(item.id)") {[weak self] (error) in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    if let err = error {
                        self.hideLoading()
                        return self.showErrorAlert(message: err)
                    }
                    self.fetchData(userId: item.u_id)
                }
            }
        default:
            break
        }
    }
}

extension JobOffersViewController {
    
    private func setupUI() {
        self.topBarMenuView.title = viewType.rawValue
        if viewType == .blog {
            self.noDataLabel.text = "No Blogs/Events/News/Promos Articles posted yet"
            self.topBarMenuView.title = "Blogs/Events/News/Promos"
        } else {
            self.noDataLabel.text = "No Job Postings posted yet"
        }
        self.noDataLabel.numberOfLines = 0
        self.noDataLabel.isHidden = true
        self.introductionView.isHidden = true
    }
    
    private func setupTableView() {
        tableView.registerNibCell(identifier: JobOfferTableViewCell.identifier)
        tableView.registerNibCell(identifier: ImageJobOfferTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 60
        tableView.rowHeight = UITableView.automaticDimension
        tableView.backgroundColor = .clear
    }
    
    private func showDeleteConfirm(item: Blog_Job) {
        let alert = UIAlertController(title: "Are you sure you want to delete ?", message: nil, preferredStyle: .actionSheet)
        let yesAction = UIAlertAction(title: "Yes", style: .destructive) { (action) in
            self.deleteItem(item)
        }
        let noAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
        
        alert.addAction(yesAction)
        alert.addAction(noAction)
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            alert.popoverPresentationController?.sourceView = self.view
            alert.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            alert.popoverPresentationController?.permittedArrowDirections = [.down, .up]
        }
        
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    private func edit(item: Blog_Job) {
        let controller = AddJobOfferViewController.instantiate()
        controller.delegate = self
        controller.viewType = viewType
        controller.data = item
        self.navigationController?.pushViewController(controller, animated: true)
    }
}

extension JobOffersViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = datas[indexPath.row]
        if item.imageItem {
            let cell = tableView.dequeueReusableCell(withIdentifier: ImageJobOfferTableViewCell.identifier, for: indexPath) as! ImageJobOfferTableViewCell
            cell.setup(datas[indexPath.row])
            cell.delegate = self
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: JobOfferTableViewCell.identifier, for: indexPath) as! JobOfferTableViewCell
        cell.setup(datas[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if viewing {
            return false
        }
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            DispatchQueue.main.async {
                self.showDeleteConfirm(item: self.datas[indexPath.row])
            }
        }

        let edit = UITableViewRowAction(style: .normal, title: "Edit") { (action, indexPath) in
            self.edit(item: self.datas[indexPath.row])
        }

        edit.backgroundColor = Constants.light_blue

        return [delete, edit]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.row < datas.count else { return }
        let controller = BlogDetailsViewController.instantiate()
        controller.viewType = viewType
        controller.item = datas[indexPath.row]
        navigationController?.pushViewController(controller, animated: true)
    }
}

extension JobOffersViewController: AddJobOffseDelegate {
    func shouldReloadData() {
        guard let userId = AppSettings.shared.userLogin?.userId else { return }
        self.fetchData(userId: userId, false)
    }
    
    func viewImage(imageView: UIImageView) {
        self.showSimplePhotoViewer(for: imageView, image: imageView.image)
    }
}
