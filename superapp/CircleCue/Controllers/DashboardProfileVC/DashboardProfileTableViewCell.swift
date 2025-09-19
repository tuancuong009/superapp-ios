//
//  DashboardProfileTableViewCell.swift
//  CircleCue
//
//  Created by QTS Coder on 27/12/24.
//

import UIKit
protocol DashboardProfileTableViewCellDelegate: AnyObject{
    func didSelectGallery(indexPath: IndexPath, imageV: UIImageView?)
    func didSelectSocial(indexPath: IndexPath)
}
class DashboardProfileTableViewCell: UITableViewCell {
    var gallerys: [Gallery] = []
    var socialItems: [HomeSocialItem] = []
    @IBOutlet weak var cltGallery: UICollectionView!
    var indexTab = 0
    weak var delegate: DashboardProfileTableViewCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        registerCell()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    private func registerCell(){
        cltGallery.registerNibCell(identifier: "PhotoDashboardCollect")
        cltGallery.registerNibCell(identifier: "SocialDashboardCollect")
    }
}

extension DashboardProfileTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if indexTab == 2{
            return socialItems.count
        }
        return gallerys.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexTab == 2{
            let cell = cltGallery.dequeueReusableCell(withReuseIdentifier: "SocialDashboardCollect", for: indexPath) as! SocialDashboardCollect
            cell.setup(socialItems[indexPath.row])
            return cell
        }
        let cell = cltGallery.dequeueReusableCell(withReuseIdentifier: "PhotoDashboardCollect", for: indexPath) as! PhotoDashboardCollect
        cell.setup(gallerys[indexPath.row])
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexTab == 2{
            return CGSizeMake((cltGallery.frame.size.width - 30)/4, (cltGallery.frame.size.width - 30)/4)
        }
        
        return CGSizeMake((cltGallery.frame.size.width - 30)/4, 124)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexTab == 2{
            self.delegate?.didSelectSocial(indexPath: indexPath)
        }
        else{
            if let cell = cltGallery.cellForItem(at: indexPath) as? PhotoDashboardCollect{
                self.delegate?.didSelectGallery(indexPath: indexPath, imageV: cell.imgCell)
            }
            else{
                self.delegate?.didSelectGallery(indexPath: indexPath, imageV: nil)
            }
            
        }
    }
    
}
