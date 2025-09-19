//
//  OnboardingViewController.swift
//  Matcheron
//
//  Created by QTS Coder on 18/10/24.
//

import UIKit
import SDWebImage
class OnboardingRRViewController: BaseRRViewController {

    @IBOutlet weak var cltProfile: UICollectionView!
    var arrDatas = [NSDictionary]()
    override func viewDidLoad() {
        super.viewDidLoad()
        cltProfile.register(UINib(nibName: "ShowcaseCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ShowcaseCollectionViewCell")
   
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
        APP_DELEGATE.initSuperApp()
    }
    @IBAction func doLogin(_ sender: Any) {
        let vc = UIStoryboard.init(name: "MainRR", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        vc.isLogin = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func doJoin(_ sender: Any) { 
        let vc = UIStoryboard.init(name: "MainRR", bundle: nil).instantiateViewController(withIdentifier: "RegisterRRViewController") as! RegisterRRViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
}
extension OnboardingRRViewController:UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = cltProfile.dequeueReusableCell(withReuseIdentifier: "ShowcaseCollectionViewCell", for: indexPath) as! ShowcaseCollectionViewCell
        cell.lblTitle.text = self.titleCell(indexPath.row)
        cell.lblAddress.text = self.addressCell(indexPath.row)
        cell.lblPrice.text = self.priceCell(indexPath.row)
        cell.imgCell.image = UIImage(named: "showcase\(indexPath.row + 1)")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return CGSize(width: (cltProfile.frame.size.width - 20)/3, height: 90 + ((cltProfile.frame.size.width - 20)/3) * 0.6)
        }
        return CGSize(width: (cltProfile.frame.size.width - 10)/2, height: 90 + ((cltProfile.frame.size.width - 10)/2) * 0.6)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = PopUpLoginRRViewController.init()
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
    
    private func configCell(_ index: Int){
        
    }
    
    private func titleCell(_ index: Int)-> String{
        switch index {
        case 0:
            return "Pinecrest Villa"
        case 1:
            return "Maple Apartments"
        case 2:
            return "Hilltop House"
        case 3:
            return "Ocean View Condo"
        case 4:
            return "Downtown Loft"
        case 5:
            return "Greenwood House"
        case 6:
            return "Riverside Cottage"
        case 7:
            return "Cedar Heights"
        default:
            return ""
        }
    }
    
    private func addressCell(_ index: Int)-> String{
        switch index {
        case 0:
            return "Fairfax, VA"
        case 1:
            return "San francisco, CA"
        case 2:
            return "Boston, MA"
        case 3:
            return "Philpadephlia, PA"
        case 4:
            return "Washington, DC"
        case 5:
            return "Fairfax, VA"
        case 6:
            return "Houston, TX"
        case 7:
            return "Chicago, IL"
        default:
            return ""
        }
    }
    
    private func priceCell(_ index: Int)-> String{
        switch index {
        case 0:
            return "$700 / Month"
        case 1:
            return "$1200 / Month"
        case 2:
            return "$300,000 / Sale"
        case 3:
            return "$950 / Month"
        case 4:
            return "$1,800/month"
        case 5:
            return "$750,000 / Sale"
        case 6:
            return "$950,00 / Sale"
        case 7:
            return "375,000 / Sale"
        default:
            return ""
        }
    }
}
