//
//  WantedVC.swift
//  Roomrently
//
//  Created by QTS Coder on 05/04/2024.
//


import UIKit
import Alamofire
class WantedVC: BaseRRViewController {
    @IBOutlet weak var txfCity: UITextField!
    @IBOutlet weak var txfState: UITextField!
    @IBOutlet weak var txfZip: UITextField!
    @IBOutlet weak var cltSearch: UICollectionView!
    @IBOutlet weak var txfSelectType: UITextField!
    @IBOutlet weak var lblNoData: UILabel!
    var arrStates = [NSDictionary]()
    var arrDatas = [NSDictionary]()
    var dictState: NSDictionary?
    var selectType = ""
    var isHome = false
    @IBOutlet weak var bntMenu: UIButton!
    var page = 1
    var totalPage = 0
    var isCallApi = false
    override func viewDidLoad() {
        cltSearch.register(UINib.init(nibName: "WantedCollect", bundle: nil), forCellWithReuseIdentifier: "WantedCollect")
        getState()
        callApi()
        if isHome{
            bntMenu.setImage(UIImage.init(named: "btn_backrr"), for: .normal)
        }
        //self.txfSelectType.text = selectType.isEmpty ? "Both" : selectType
        self.txfSelectType.text = nil
        super.viewDidLoad()
    }
    
    private func showHideNoData(){
        if self.arrDatas.count == 0{
            
            lblNoData.isHidden = false
        }
        else{
            lblNoData.isHidden = true
        }
      
        if self.page == totalPage{
            isCallApi = true
        }
        else{
            isCallApi = false
        }
       
    }
    @IBAction func doLoadMore(_ sender: Any) {
        self.callLoadMorePage()
    }
    @IBAction func doSearch(_ sender: Any) {
        lblNoData.isHidden = true
        self.page = 1
        self.totalPage = 0
        self.callApi()
    }
    @IBAction func doMenuSearch(_ sender: Any) {
        if isHome{
            self.navigationController?.popViewController(animated: true)
        }
        else{
            self.sideMenuController?.showLeftView(animated: true)
        }
    }
    
    @IBAction func doState(_ sender: Any) {
        var arrs = [String]()
        arrs.append("All")
        for arrState in arrStates {
            arrs.append(arrState.object(forKey: "name") as? String ?? "")
        }
        DPPickerManager.shared.showPicker(title: "State", sender, selected: txfState.text, strings: arrs) { value, index, cancel in
            if !cancel{
                self.txfState.text  = value
                if index == 0{
                    self.dictState = nil
                }
                else{
                    self.dictState = self.arrStates[index - 1]
                }
               
            }
        }
    }
    
    private func getState()
    {
        APIRoomrentlyHelper.shared.getStates { success, arrs in
            self.arrStates.removeAll()
            if let arrs = arrs{
                self.arrStates = arrs
            }
        }
    }
    private func callApi(){
        lblNoData.isHidden = true
        var param: Parameters = [:]
        if !txfZip.text!.trimText().isEmpty{
            param["zip"] = txfZip.text!.trimText()
        }
        if let dictState = dictState{
            param["state"] = dictState.object(forKey: "code") as? String ?? ""
        }
        if !txfCity.text!.trimText().isEmpty{
            param["city"] = txfCity.text!.trimText()
        }
        if !selectType.isEmpty{
            param["seeking"] = selectType
        }
        param["page"] = self.page
        showBusy()
        print("param-->",param)
        APIRoomrentlyHelper.shared.wanted(param) { success, arrs, total in
            print("arrs-->",arrs?.count)
            self.hideBusy()
            self.totalPage  = total
            self.arrDatas.removeAll()
            if let arrs = arrs{
                self.arrDatas = arrs
            }
            self.showHideNoData()
            self.cltSearch.reloadData()
            
        }
    }
    
    private func callLoadMorePage(){
        page = page + 1
        var param: Parameters = [:]
        if !txfZip.text!.trimText().isEmpty{
            param["zip"] = txfZip.text!.trimText()
        }
        if let dictState = dictState{
            param["state"] = dictState.object(forKey: "code") as? String ?? ""
        }
        if !txfCity.text!.trimText().isEmpty{
            param["city"] = txfCity.text!.trimText()
        }
        if !selectType.isEmpty{
            param["seeking"] = selectType
        }
        param["page"] = self.page
        print("param-->",param)
        APIRoomrentlyHelper.shared.wanted(param) { success, arrs, total in
            if let arrs = arrs{
                for item in arrs{
                    self.arrDatas.append(item)
                }
            }
            self.showHideNoData()
            self.cltSearch.reloadData()
        }
    }
    @IBAction func doSelectType(_ sender: Any) {
        let arrs = ["Select Type", "Both","Rent", "Buy"]
       
        DPPickerManager.shared.showPicker(title: "Select type", sender, selected: txfSelectType.text, strings: arrs) { value, index, cancel in
            if !cancel{
                if index == 0{
                    self.txfSelectType.text = ""
                    self.selectType  = ""
                }
                else if index == 1{
                    self.txfSelectType.text = value
                    self.selectType  = ""
                }
                else if index == 2{
                    self.txfSelectType.text = value
                    self.selectType  = "2"
                }
               
                else{
                    self.txfSelectType.text = value
                    self.selectType  =  "1"
                }
            }
        }
    }
}

extension WantedVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrDatas.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = cltSearch.dequeueReusableCell(withReuseIdentifier: "WantedCollect", for: indexPath) as! WantedCollect
       cell.configCell(arrDatas[indexPath.row])
        cell.tapDetail = { [] in
            let vc = DetailWantedVC.init()
            vc.dict = self.arrDatas[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: (cltSearch.frame.size.width - 20)/2, height: 180)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = DetailWantedVC.init()
        vc.dict = self.arrDatas[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
            
        case UICollectionView.elementKindSectionHeader:
            
            return UICollectionReusableView.init()
            
        case UICollectionView.elementKindSectionFooter:
            let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "FooterView", for: indexPath) as! FooterView
            footerView.indicator.startAnimating()
            footerView.indicator.isHidden = true
            footerView.btnLoadMore.isHidden = false
            footerView.tapLoadMore = { [self] in
                footerView.btnLoadMore.isHidden = true
                footerView.indicator.isHidden = false
                if !isCallApi && totalPage > 0{
                    self.isCallApi = true
                    self.callLoadMorePage()
                }
                
            }
            return footerView
            
        default:
            
            assert(false, "Unexpected element kind")
        }
        return UICollectionReusableView.init()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if page == self.totalPage || self.totalPage == 0{
            return CGSize(width: 0, height: 0)
        }
        return CGSize(width: self.cltSearch.frame.size.width, height:80)
    }

}


