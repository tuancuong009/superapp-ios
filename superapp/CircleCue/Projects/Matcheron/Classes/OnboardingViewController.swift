//
//  OnboardingViewController.swift
//  Matcheron
//
//  Created by QTS Coder on 18/10/24.
//

import UIKit
import SDWebImage
class OnboardingViewController: AllViewController {

    @IBOutlet weak var cltProfile: UICollectionView!
    var arrDatas = [NSDictionary]()
    override func viewDidLoad() {
        super.viewDidLoad()
        cltProfile.register(UINib(nibName: "MatchCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "MatchCollectionViewCell")
        callAPI()
        // Do any additional setup after loading the view.
    }


    @IBAction func doBack(_ sender: Any) {
        APP_DELEGATE.initSuperApp()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func doLogin(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginMatcheronVC") as! LoginMatcheronVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func doJoin(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RegisterVC") as! RegisterVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func callAPI(){
        self.showBusy()
        APIHelper.shared.onboarding { success, dict in
            self.hideBusy()
            if let dict = dict{
                self.arrDatas = dict
            }
            self.cltProfile.reloadData()
        }
    }
}
extension OnboardingViewController:UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrDatas.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = cltProfile.dequeueReusableCell(withReuseIdentifier: "MatchCollectionViewCell", for: indexPath) as! MatchCollectionViewCell
        let object = self.arrDatas[indexPath.row]
        cell.configCell(object)
        cell.lblAddress.text = ""
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (cltProfile.frame.size.width - 10)/2, height: 160)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = PopUpLoginViewController.init()
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        vc.tapLogin = { [] in
            self.doLogin(AnyClass.self)
        }
        vc.tapSignUp = { [] in
            self.doJoin(AnyClass.self)
        }
        present(vc, animated: true)
    }
}
