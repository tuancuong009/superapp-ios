//
//  HomeShowCaseViewController.swift
//  Roomrently
//
//  Created by QTS Coder on 11/12/24.
//

import UIKit
import Alamofire
class HomeShowCaseViewController: BaseRRViewController {
    @IBOutlet weak var cltSearch: UICollectionView!
    @IBOutlet weak var lblNoData: UILabel!
    var arrDatas = [NSDictionary]()
    @IBOutlet weak var bntMenu: UIButton!
    var page = 1
    var totalPage = 0
    var isCallApi = false
    override func viewDidLoad() {
        cltSearch.register(UINib.init(nibName: "rentalCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "rentalCollectionViewCell")
        callApi()
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
    @IBAction func doSuperApp(_ sender: Any) {
        APP_DELEGATE.initSuperApp()
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
        self.sideMenuController?.showLeftView(animated: true)
    }
    
   
    private func callApi(){
        lblNoData.isHidden = true
        var param: Parameters = [:]
        
        param["page"] = self.page
        param["type"] = ""
        showBusy()
        print("param-->",param)
        APIRoomrentlyHelper.shared.search(param) { success, arrs, total in
            print("arrs-->",arrs)
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
        param["page"] = self.page
        param["type"] = ""
        print("param-->",param)
        APIRoomrentlyHelper.shared.search(param) { success, arrs, total in
            if let arrs = arrs{
                for item in arrs{
                    self.arrDatas.append(item)
                }
            }
            self.showHideNoData()
            self.cltSearch.reloadData()
        }
    }
}

extension HomeShowCaseViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrDatas.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = cltSearch.dequeueReusableCell(withReuseIdentifier: "rentalCollectionViewCell", for: indexPath) as! rentalCollectionViewCell
        cell.configCell(arrDatas[indexPath.row])
        cell.tapDetail = { [] in
            let vc = UIStoryboard.init(name: "MainRR", bundle: nil).instantiateViewController(withIdentifier: "DetailPropertyViewController") as! DetailPropertyViewController
            vc.dictDetail = self.arrDatas[indexPath.row]
            vc.indexPosition = indexPath.row
            vc.arrDatas = self.arrDatas
            self.navigationController?.pushViewController(vc, animated: true)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return CGSize(width: (cltSearch.frame.size.width - 40)/3, height: 320)
        }
        return CGSize(width: (cltSearch.frame.size.width - 20)/2, height: 230)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = UIStoryboard.init(name: "MainRR", bundle: nil).instantiateViewController(withIdentifier: "DetailPropertyViewController") as! DetailPropertyViewController
        vc.dictDetail = self.arrDatas[indexPath.row]
        vc.indexPosition = indexPath.row
        vc.arrDatas = self.arrDatas
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


