//
//  MaybeViewController.swift
//  Matcheron
//
//  Created by QTS Coder on 2/10/24.
//

import UIKit
import LGSideMenuController
import SDWebImage
class MaybeViewController: BaseMatcheronViewController {
    @IBOutlet weak var cltProfile: UICollectionView!
    @IBOutlet weak var viewAction: UIStackView!
    @IBOutlet weak var btnPrev: UIButton!
    @IBOutlet weak var btnNext: UIButton!
    var indexProfile = 0
    var arrDatas = [NSDictionary]()
    @IBOutlet weak var lblNoData: UILabel!
    @IBOutlet weak var btnReport: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        cltProfile.register(UINib(nibName: "ProfileCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ProfileCollectionViewCell")
        
        hideAllUI()
        self.callAPI()
        // Do any additional setup after loading the view.
    }

    
    @IBAction func doBack(_ sender: Any) {
        self.sideMenuController?.showLeftView()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func doReport(_ sender: Any) {
        let vc = ReportViewController.init()
        present(vc, animated: true)
    }
    @IBAction func doPrev(_ sender: Any) {
        if indexProfile == 0 {
            return
        }
        indexProfile = indexProfile - 1
        
        cltProfile.scrollToItem(at: IndexPath(row: indexProfile, section: 0), at: .left, animated: true)
    }
    @IBAction func doNext(_ sender: Any) {
        
        if indexProfile == arrDatas.count - 1 {
            return
        }
        indexProfile = indexProfile + 1
        
        cltProfile.scrollToItem(at: IndexPath(row: indexProfile, section: 0), at: .right, animated: true)
    }
    @IBAction func doNo(_ sender: Any) {
        self.actionProfile(2)
       
    }
    @IBAction func doMayBe(_ sender: Any) {
        self.actionProfile(3)
       
    }
    @IBAction func doYes(_ sender: Any) {
        self.actionProfile(1)
    }
    
    private func hideAllUI(){
        lblNoData.isHidden = true
        viewAction.isHidden = true
        btnPrev.isHidden = true
        btnNext.isHidden = true
        btnReport.isHidden = true
    }
    
    private func showAllUI(){
        viewAction.isHidden = false
        btnPrev.isHidden = false
        btnNext.isHidden = false
        btnReport.isHidden = false
    }
    
    
    private func callAPI(){
        self.showBusy()
        let userID = UserDefaults.standard.value(forKey: USER_ID) as? String ?? ""
        APIHelper.shared.getMaybes(id: userID) { success, dict in
            self.hideBusy()
            if let dict = dict{
                self.arrDatas = dict
            }
            //self.lblNoData.isHidden = self.arrDatas.count == 0 ? false : true
            if self.arrDatas.count == 0 {
                self.hideAllUI()
                self.lblNoData.isHidden = false
            }
            else{
                
                self.showAllUI()
            }
            self.cltProfile.reloadData()
        }
    }
    
    private func actionProfile(_ type: Int){
        let dict = self.arrDatas[indexProfile]
        let profileID = dict.object(forKey: "id") as? String ?? ""
        let userID = UserDefaults.standard.value(forKey: USER_ID) as? String ?? ""
        self.showBusy()
        if type == 1{
            APIHelper.shared.likedYes(id: userID, id2: profileID) { success, erro in
                self.hideBusy()
                if success!{
                    self.arrDatas.remove(at: self.indexProfile)
                    self.cltProfile.reloadData()
                    if self.arrDatas.count == 0 {
                        self.hideAllUI()
                        self.lblNoData.isHidden = false
                    }
                    if self.indexProfile >= self.arrDatas.count - 1 {
                        self.indexProfile = self.arrDatas.count - 1
                    }
                    else{
                        
                    }
                }
                else{
                    self.showAlertMessage(message: erro ?? "")
                }
            }
        }
        else if type == 2{
            APIHelper.shared.rejectNo(id: userID, id2: profileID) { success, erro in
                self.hideBusy()
                if success!{
                    self.arrDatas.remove(at: self.indexProfile)
                    self.cltProfile.reloadData()
                    if self.arrDatas.count == 0 {
                        self.hideAllUI()
                        self.lblNoData.isHidden = false
                    }
                    if self.indexProfile >= self.arrDatas.count - 1 {
                        self.indexProfile = self.arrDatas.count - 1
                    }
                    else{
                        
                    }
                }
                else{
                    self.showAlertMessage(message: erro ?? "")
                }
            }
        }
        else{
            self.hideBusy()
//            APIHelper.shared.addMaybe(id: userID, id2: profileID) { success, erro in
//                self.hideBusy()
//                if success!{
//
//                    self.cltProfile.reloadData()
//                }
//                else{
//                    self.showAlertMessage(message: erro ?? "")
//                }
//            }
        }
    }
    
    private func checkExitMessageProfile(_ object: NSDictionary)-> Bool{
        let profileID = object.object(forKey: "id") as? String ?? ""
        for message in APP_DELEGATE.messageAll {
            if message.receiver_id == profileID{
                return true
            }
        }
        return false
    }
}
extension MaybeViewController: UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let witdh = scrollView.frame.width - (scrollView.contentInset.left*2)
        let index = scrollView.contentOffset.x / witdh
        let roundedIndex = round(index)
        indexProfile = Int(roundedIndex)
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        
        indexProfile = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
    }
}

extension MaybeViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrDatas.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = cltProfile.dequeueReusableCell(withReuseIdentifier: "ProfileCollectionViewCell", for: indexPath) as! ProfileCollectionViewCell
        let object = self.arrDatas[indexPath.row]
        cell.configCell(object: object)
        cell.btnMessaged.isHidden = !self.checkExitMessageProfile(object)
        cell.tapMessaged = { [] in
            let vc = SendMessageVC()
            vc.profileID = object.object(forKey: "id") as? String ?? ""
            vc.profileName = object.object(forKey: "fname") as? String ?? ""
            self.navigationController?.pushViewController(vc, animated: true)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.cltProfile.frame.size.width, height: self.cltProfile.frame.size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let object = self.arrDatas[indexPath.row]
        let vc = ProfileUserViewController.init()
        vc.dictUser = object
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
