//
//  InquiryViewController.swift
//  Roomrently
//
//  Created by QTS Coder on 18/09/2023.
//

import UIKit
import Alamofire
import LGSideMenuController
class InquiryViewController: BaseRRViewController {

    @IBOutlet weak var lblNoData: UILabel!
    @IBOutlet weak var segment: UISegmentedControl!
    @IBOutlet weak var cltInquire: UICollectionView!
    var arrDatas = [NSDictionary]()
    @IBOutlet weak var btnMenu: UIButton!
    var isProfile = false
    override func viewDidLoad() {
        super.viewDidLoad()
        lblNoData.isHidden = true
        cltInquire.register(UINib.init(nibName: "rentalCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "rentalCollectionViewCell")
        if isProfile{
            btnMenu.setImage(UIImage.init(named: "btn_backrr"), for: .normal)
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if segment.selectedSegmentIndex == 0{
            self.callApi()
        }
        else{
            self.callApi2()
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func doMenuApp(_ sender: Any) {
        if !self.isProfile{
            self.sideMenuController?.showLeftView(animated: true)
        }
        else{
            
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func changeSegment(_ sender: Any) {
        lblNoData.isHidden = true
        if segment.selectedSegmentIndex == 0{
            self.callApi()
        }
        else{
            self.callApi2()
        }
    }
    private func showHideUI(){
        if self.arrDatas.count == 0{
            lblNoData.isHidden = false
            cltInquire.isHidden = true
        }
        else{
            lblNoData.isHidden = true
            cltInquire.isHidden = false
        }
    }
    
    private func callApi(){
        self.showBusy()
        let param: Parameters = ["uid": UserDefaults.standard.value(forKey: USER_ID_RR) as? String ?? ""]
        APIRoomrentlyHelper.shared.myInquirySent(param) { success, arrs in
            self.hideBusy()
            self.arrDatas.removeAll()
            if let arrs = arrs{
                for arr in arrs {
                    if let data = arr.object(forKey: "data") as? NSDictionary{
                        self.arrDatas.append(data)
                    }
                }
            }
            self.showHideUI()
            self.cltInquire.reloadData()
        }
    }
    
    private func callApi2(){
        self.showBusy()
        let param: Parameters = ["uid": UserDefaults.standard.value(forKey: USER_ID_RR) as? String ?? ""]
        APIRoomrentlyHelper.shared.my_inquiry_rcvd(param) { success, arrs in
            self.hideBusy()
            self.arrDatas.removeAll()
            if let arrs = arrs{
                for arr in arrs {
                    if let data = arr.object(forKey: "data") as? NSDictionary{
                        self.arrDatas.append(data)
                    }
                }
            }
            self.showHideUI()
            self.cltInquire.reloadData()
        }
    }
    
}

extension InquiryViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrDatas.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = cltInquire.dequeueReusableCell(withReuseIdentifier: "rentalCollectionViewCell", for: indexPath) as! rentalCollectionViewCell
        cell.configCellIquire(arrDatas[indexPath.row])
        cell.tapDetail = { [] in
           
          
        }
        cell.btnInquire.isHidden = true
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
      
        return CGSize(width: (cltInquire.frame.size.width - 20)/2, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = UIStoryboard.init(name: "MainRR", bundle: nil).instantiateViewController(withIdentifier: "DetailPropertyViewController") as! DetailPropertyViewController
        vc.dictDetail = self.arrDatas[indexPath.row]
        vc.indexPosition = indexPath.row
        vc.arrDatas = self.arrDatas
        vc.isViewProperty = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
