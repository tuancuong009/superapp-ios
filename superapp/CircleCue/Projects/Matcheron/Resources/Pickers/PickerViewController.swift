//
//  PickerViewController.swift
//  Matcheron
//
//  Created by QTS Coder on 15/11/24.
//

import UIKit

class PickerViewController: UIViewController {
    var tapDone: (() ->())?
    @IBOutlet weak var lblnavi: UILabel!
    @IBOutlet weak var tblDatas: UITableView!
    var titleNavi = ""
    var arrDatas = [String]()
    var indexSelect: Int = 0
    var value = ""
    var isRequiredSlect: Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        lblnavi.text = titleNavi
        tblDatas.register(UINib(nibName: "PickerTableViewCell", bundle: nil), forCellReuseIdentifier: "PickerTableViewCell")
        // Do any additional setup after loading the view.
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func doDone(_ sender: Any) {
        
       
        self.dismiss(animated: true)
    }
    @IBAction func doCancel(_ sender: Any) {
        self.dismiss(animated: true)
    }
}


extension PickerViewController: UITableViewDataSource, UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrDatas.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblDatas.dequeueReusableCell(withIdentifier: "PickerTableViewCell") as! PickerTableViewCell
        cell.lblName.text = arrDatas[indexPath.row]
//        if isRequiredSlect{
//            cell.accessoryType  = indexSelect == indexPath.row ? .checkmark : .none
//        }
//        else{
//            if indexPath.row == 0 {
//                cell.accessoryType  = .none
//            }
//            else{
//                
//                cell.accessoryType  = indexSelect == indexPath.row ? .checkmark : .none
//            }
//          
//            
//        }
       
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tblDatas.deselectRow(at: indexPath, animated: true)
        if isRequiredSlect{
            indexSelect = indexPath.row
            value = arrDatas[indexPath.row]
            tblDatas.reloadData()
            self.tapDone?()
            self.dismiss(animated: true)
        }
        else{
            if indexPath.row == 0 {
                indexSelect = 0
                tblDatas.reloadData()
                self.tapDone?()
                self.dismiss(animated: true)
            }
            else{
                indexSelect = indexPath.row
                value = arrDatas[indexPath.row]
                tblDatas.reloadData()
                self.tapDone?()
                self.dismiss(animated: true)
            }
        }
        
       
    }
}
