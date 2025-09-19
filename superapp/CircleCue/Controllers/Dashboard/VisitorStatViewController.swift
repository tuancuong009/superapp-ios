//
//  VisitorStatViewController.swift
//  CircleCue
//
//  Created by QTS Coder on 10/19/20.
//

import UIKit

class VisitorStatViewController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!

    var visitors: [Visitor] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        fetchVisitor()
    }
}

extension VisitorStatViewController {
    
    private func setupTableView() {
        tableView.registerNibCell(identifier: VisitorStatTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 40
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    private func fetchVisitor() {
        guard let userId = AppSettings.shared.userLogin?.userId else { return }
        showSimpleHUD()
        ManageAPI.shared.fetchVisitors(userId) {[weak self] (results) in
            guard let self = self else { return }
            self.hideLoading()
            DispatchQueue.main.async {
                self.visitors = results
                self.tableView.reloadData()
            }
        }
    }
}

extension VisitorStatViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return visitors.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: VisitorStatTableViewCell.identifier, for: indexPath) as! VisitorStatTableViewCell
        cell.setup(vistor: visitors[indexPath.row])
        return cell
    }
}
