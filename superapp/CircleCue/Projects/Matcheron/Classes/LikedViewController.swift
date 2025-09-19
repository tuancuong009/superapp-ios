//
//  LikedViewController.swift
//  Matcheron
//
//  Created by QTS Coder on 2/10/24.
//

import UIKit
import LGSideMenuController
import SDWebImage
class LikedViewController: BaseMatcheronViewController {
    @IBOutlet weak var cltData: UICollectionView!
    @IBOutlet weak var lblNoData: UILabel!
    var arrDatas = [NSDictionary]()
    public var isLiked = false
    @IBOutlet weak var lblNavi: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        cltData.register(UINib(nibName: "MatchCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "MatchCollectionViewCell")
        lblNoData.isHidden = true
        if isLiked{
            lblNavi.text = "Liked"
            lblNoData.text = "No Liked"
        }
        callApi(true)
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

    @IBAction func doBack(_ sender: Any) {
        self.sideMenuController?.showLeftView(animated: true)
    }
    
    private func callApi(_ isLoading: Bool){
        if isLoading{
            self.showBusy()
        }
       
        self.arrDatas.removeAll()
        let userID = UserDefaults.standard.value(forKey: USER_ID) as? String ?? ""
        if isLiked{
            APIHelper.shared.likedMe(id: userID) { success, dict in
                self.hideBusy()
                if let dict = dict{
                    self.arrDatas = dict
                   
                }
                self.cltData.reloadData()
                self.lblNoData.isHidden = self.arrDatas.count == 0 ? false : true
            }
        }
        else{
            APIHelper.shared.liekd(id: userID) { success, dict in
                self.hideBusy()
                if let dict = dict{
                    self.arrDatas = dict
                   
                }
                self.cltData.reloadData()
                self.lblNoData.isHidden = self.arrDatas.count == 0 ? false : true
            }
        }
        
    }
}

extension LikedViewController:UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrDatas.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = cltData.dequeueReusableCell(withReuseIdentifier: "MatchCollectionViewCell", for: indexPath) as! MatchCollectionViewCell
        let object = self.arrDatas[indexPath.row]
        cell.configCell(object)
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (cltData.frame.size.width - 10)/2, height: 180)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = ProfileUserViewController.init()
        vc.dictUser = self.arrDatas[indexPath.row]
        vc.isMenuLike = true
        vc.tapSuccess = { [] in
            self.callApi(false)
        }
        navigationController?.pushViewController(vc, animated: true)
    }
}
