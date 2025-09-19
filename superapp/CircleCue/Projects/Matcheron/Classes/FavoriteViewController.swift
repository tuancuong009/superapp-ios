//
//  FavoriteViewController.swift
//  Matcheron
//
//  Created by QTS Coder on 2/10/24.
//

import UIKit
import LGSideMenuController
class FavoriteViewController: BaseViewController {

    @IBOutlet weak var cltData: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        cltData.register(UINib(nibName: "MatchCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "MatchCollectionViewCell")
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
}

extension FavoriteViewController:UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = cltData.dequeueReusableCell(withReuseIdentifier: "MatchCollectionViewCell", for: indexPath) as! MatchCollectionViewCell
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (cltData.frame.size.width - 10)/2, height: 180)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = ProfileUserViewController.init()
        navigationController?.pushViewController(vc, animated: true)
    }
}
