//
//  ShowCaseViewController.swift
//  Matcheron
//
//  Created by QTS Coder on 7/10/24.
//

import UIKit
import SDWebImage
class ShowCaseViewController: BaseMatcheronViewController {
    var arrDatas = [NSDictionary]()
    @IBOutlet weak var cltProfiles: UICollectionView!
    @IBOutlet weak var lblNoData: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        cltProfiles.register(UINib(nibName: "MatchCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "MatchCollectionViewCell")
        callApi()
        lblNoData.isHidden = true
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
    private func callApi(){
        self.showBusy()
        APIHelper.shared.showcase { success, dict in
            self.hideBusy()
            if let dict = dict{
                self.arrDatas = dict
                self.cltProfiles.reloadData()
            }
            self.lblNoData.isHidden = self.arrDatas.count == 0 ? false : true
        }
    }
}
extension ShowCaseViewController:UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrDatas.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = cltProfiles.dequeueReusableCell(withReuseIdentifier: "MatchCollectionViewCell", for: indexPath) as! MatchCollectionViewCell
        let object = self.arrDatas[indexPath.row]
        cell.configCell(object)
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (cltProfiles.frame.size.width - 10)/2, height: 180)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = ProfileUserViewController.init()
        vc.dictUser = self.arrDatas[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
}
