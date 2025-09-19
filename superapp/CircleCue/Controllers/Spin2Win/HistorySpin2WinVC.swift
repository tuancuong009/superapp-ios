//
//  HistorySpin2WinVC.swift
//  CircleCue
//
//  Created by QTS Coder on 21/04/2023.
//

import UIKit

class HistorySpin2WinVC: BaseViewController {
    var arrHistories = [NSDictionary]()
    @IBOutlet weak var lblNoData: UILabel!
    @IBOutlet weak var tblHistory: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tblHistory.registerNibCell(identifier: "WinnerCell")
        self.showSimpleHUD()
        lblNoData.isHidden = true
        guard let userId = AppSettings.shared.userLogin?.userId else { return }
        ManageAPI.shared.winnerHistory(userId: userId) { [weak self] users, error in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.hideLoading()
                self.arrHistories = users
                self.tblHistory.reloadData()
                self.lblNoData.isHidden = self.arrHistories.count == 0 ? false : true
            }
        }
    }
    
    @IBAction func doBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
extension HistorySpin2WinVC: UITableViewDataSource, UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrHistories.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 35
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tblHistory.dequeueReusableCell(withIdentifier: "WinnerCell") as! WinnerCell
        let dict = arrHistories[indexPath.row]
        cell.lblUserName.text = dict.object(forKey: "date") as? String
        cell.lblPrice.text = "$" + (dict.object(forKey: "price") as? String ?? "0")
        return cell
    }
}
