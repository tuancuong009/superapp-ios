//
//  DetailProductViewController.swift
//  CircleCue
//
//  Created by QTS Coder on 5/8/24.
//

import UIKit

class DetailProductViewController: BaseViewController {
    var dictProduct: NSDictionary?
    @IBOutlet weak var lblCondition: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblCategory: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblCountry: UILabel!
    @IBOutlet weak var lblState: UILabel!
    @IBOutlet weak var lblCity: UILabel!
    @IBOutlet weak var lblZip: UILabel!
    @IBOutlet weak var lblDetail: UILabel!
    @IBOutlet weak var lblSold: UILabel!
    @IBOutlet weak var cltImages: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var viewRequired: UIView!
    var arrPhotos = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        cltImages.registerNibCell(identifier: "PhotoProductCollect")
        if let dictProduct = dictProduct{
            configCel(dictProduct)
        }
        // Do any additional setup after loading the view.
    }


    @IBAction func doTapUserName(_ sender: Any) {
        if let dictProduct = dictProduct{
            let controller = FriendProfileViewController.instantiate()
            controller.basicInfo = UniversalUser(id: dictProduct.object(forKey: "uid") as? String ?? "", username: dictProduct.object(forKey: "username") as? String ?? "", country: "", pic: "")
            self.navigationController?.pushViewController(controller, animated: true)
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
    private func configCel( _ dict: NSDictionary){
        self.arrPhotos.removeAll()
        if let img1 = dict.object(forKey: "img1") as? String{
            let join = "https://www.circlecue.com/assets/images/product-img/" + img1
            self.arrPhotos.append(join)
        }
        if let img2 = dict.object(forKey: "img2") as? String{
            let join = "https://www.circlecue.com/assets/images/product-img/" + img2
            self.arrPhotos.append(join)
        }
        if let img3 = dict.object(forKey: "img3") as? String{
            let join = "https://www.circlecue.com/assets/images/product-img/" + img3
            self.arrPhotos.append(join)
        }
        pageControl.numberOfPages = self.arrPhotos.count
        self.lblCondition.text = dict.object(forKey: "condition") as? String
        self.lblName.text = dict.object(forKey: "itemname") as? String
        self.lblCategory.text = dict.object(forKey: "category") as? String
        self.lblCountry.text = dict.object(forKey: "country") as? String
        self.lblState.text = dict.object(forKey: "state") as? String
        self.lblPrice.text = (dict.object(forKey: "price") as? String ?? "")
        self.lblDetail.text = dict.object(forKey: "brief") as? String
        self.lblCountry.text = dict.object(forKey: "country") as? String
        self.lblZip.text = dict.object(forKey: "zip") as? String
        self.lblCity.text = dict.object(forKey: "city") as? String
        self.lblUserName.text = dict.object(forKey: "username") as? String
        cltImages.reloadData()
        
        if let sold = dict.object(forKey: "sold") as? String{
            self.lblSold.isHidden = (sold == "1" ? false : true)
            self.viewRequired.isHidden = (sold == "1" ? true : false)
        }
        else if let sold = dict.object(forKey: "sold") as? Int{
            self.lblSold.isHidden = (sold == 1 ? true : false)
        }else{
            self.lblSold.isHidden = true
        }
    }
    @IBAction func doUniquird(_ sender: Any) {
        if let dictProduct = dictProduct{
            let vc = BuyNowViewController.init()
            vc.dictProduct = dictProduct
            self.navigationController?.pushViewController(vc, animated: true)
        }
       
    }
}

extension DetailProductViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrPhotos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell =  cltImages.dequeueReusableCell(withReuseIdentifier: "PhotoProductCollect", for: indexPath) as! PhotoProductCollect
        cell.imgPhoto.setImage(with: arrPhotos[indexPath.row], placeholderImage: .photo)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.cltImages.frame.size.width, height: self.cltImages.frame.size.height)
    }
    
}

extension DetailProductViewController: UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let width = scrollView.frame.width
        let page = Int(round(scrollView.contentOffset.x/width))
        self.pageControl.currentPage = page
    }
}
