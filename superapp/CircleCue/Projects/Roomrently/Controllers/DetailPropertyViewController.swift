//
//  DetailPropertyViewController.swift
//  Roomrently
//
//  Created by QTS Coder on 05/10/2023.
//

import UIKit
import SDWebImage
import ImageViewer_swift
class DetailPropertyViewController: BaseRRViewController {
    
    @IBOutlet weak var lblID: UILabel!
    @IBOutlet weak var lblRent: UILabel!
    @IBOutlet weak var cltPhotos: UICollectionView!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var imgHost: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var btnMore: UIButton!
    @IBOutlet weak var btnPre: UIButton!
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var lblReamrk: UILabel!
    @IBOutlet weak var btnMoreRemark: UIButton!
    @IBOutlet weak var viewAction: UIView!
    
    @IBOutlet weak var heightViewAction: NSLayoutConstraint!
    @IBOutlet weak var viewHost: UIView!
    @IBOutlet weak var heightHost: NSLayoutConstraint!
    @IBOutlet weak var lblType: UILabel!
    @IBOutlet weak var lblTitleSpecial: UILabel!
    var isViewProperty = false
    var arrPhotos = [String]()
    var urlPhotos = [URL]()
    var dictDetail: NSDictionary?
    var arrDatas = [NSDictionary]()
    var indexPosition = 0
    var share_url = ""
    var idHost = ""
    var nameHost = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        showHideBtnNextPrev()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func doProfile(_ sender: Any) {
        let vc = MyProfileUserVC()
         vc.profileID = self.idHost
        vc.idBook = self.lblID.text!
         self.navigationController?.pushViewController(vc, animated: true)
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }Arihant Agra AL 282001 United States
     */
    
    @IBAction func doBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func doMore(_ sender: Any) {
        lblDesc.numberOfLines = 0
        btnMore.isHidden = true
    }
    
    @IBAction func doUniqui(_ sender: Any) {
        if self.isCheckLogin(){
            if isViewProperty{
                if let property = dictDetail{
                    if let type = property.object(forKey: "type") as? String, type != "Rent"{
                        let vc = UIStoryboard.init(name: "MainRR", bundle: nil).instantiateViewController(withIdentifier: "BookViewController") as! BookViewController
                        vc.idBook = self.lblID.text!
                        vc.property = property
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                    else{
                        let vc = UIStoryboard.init(name: "MainRR", bundle: nil).instantiateViewController(withIdentifier: "BuyInquiryViewController") as! BuyInquiryViewController
                        vc.idBook = self.lblID.text!
                        vc.property = property
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                    
                }
            }
            else{
                if let dict = dictDetail{
                    
                    if let property = dict.object(forKey: "property") as? NSDictionary{
                        if let type = property.object(forKey: "type") as? String, type == "Rent"{
                            let vc = UIStoryboard.init(name: "MainRR", bundle: nil).instantiateViewController(withIdentifier: "BookViewController") as! BookViewController
                            vc.idBook = self.lblID.text!
                            vc.dictData = dict
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                        else{
                            let vc = UIStoryboard.init(name: "MainRR", bundle: nil).instantiateViewController(withIdentifier: "BuyInquiryViewController") as! BuyInquiryViewController
                            vc.idBook = self.lblID.text!
                            vc.dictData = dict
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                    }
                }
                
            }
            
            
        }
        else{
            let vc = UIStoryboard.init(name: "MainRR", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            vc.isLogin = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    @IBAction func doShare(_ sender: Any) {
        let text = share_url
        
        // set up activity view controller
        let textToShare = [ text ]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        
        // exclude some activity types from the list (optional)
        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]
        
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    @IBAction func doMoreRemark(_ sender: Any) {
        lblReamrk.numberOfLines = 0
        btnMoreRemark.isHidden = true
    }
    @IBAction func doPre(_ sender: Any) {
        indexPosition = indexPosition - 1
        self.dictDetail = arrDatas[indexPosition]
        updateUI()
        showHideBtnNextPrev()
    }
    
    @IBAction func doNext(_ sender: Any) {
        indexPosition = indexPosition + 1
        self.dictDetail = arrDatas[indexPosition]
        updateUI()
        showHideBtnNextPrev()
    }
    func updateUI(){
        if isViewProperty{
            viewAction.isHidden = true
            heightViewAction.constant = 0
            viewHost.isHidden = true
            heightHost.constant = 0
            imgHost.isHidden = true
            if let property = dictDetail{
                let id = (property.object(forKey: "pid") as? String ?? "")
                lblID.text = id
                self.share_url = (property.object(forKey: "url") as? String ?? "")
                let rent = property.object(forKey: "rent") as? String ?? ""
                let rtype = property.object(forKey: "rtype") as? String ?? ""
                if let type = property.object(forKey: "type") as? String, type == "Rent"{
                    
                    lblRent.text  = "$" + rent + "/" + rtype
                }
                else{
                    
                    lblRent.text  = "$" + rent
                }
                lblType.text = property.object(forKey: "type") as? String
                let city = property.object(forKey: "city") as? String ?? ""
                let state = property.object(forKey: "state") as? String ?? ""
                let zip = property.object(forKey: "zip") as? String ?? ""
                lblAddress.text =   city + " " + state + " " + zip
                lblDesc.text = property.object(forKey: "discription") as? String
                lblReamrk.text = property.object(forKey: "remark") as? String
                lblDesc.numberOfLines = 3
                lblReamrk.numberOfLines = 3
                if lblReamrk.text!.isEmpty{
                    lblTitleSpecial.isHidden = true
                }
                self.arrPhotos.removeAll()
                if let img1 = property.object(forKey: "img1") as? String{
                    arrPhotos.append(LINK_URL.URL_PHOTO + img1)
                }
                if let img1 = property.object(forKey: "img2") as? String{
                    arrPhotos.append(LINK_URL.URL_PHOTO + img1)
                }
                if let img1 = property.object(forKey: "img3") as? String{
                    arrPhotos.append(LINK_URL.URL_PHOTO + img1)
                }
                
                if let img1 = property.object(forKey: "img4") as? String{
                    arrPhotos.append(LINK_URL.URL_PHOTO + img1)
                }
                urlPhotos.removeAll()
                for arrPhoto in arrPhotos {
                    urlPhotos.append(URL.init(string: arrPhoto)!)
                }
                cltPhotos.reloadData()
                let height = (property.object(forKey: "discription") as? String ?? "").height(withConstrainedWidth: UIScreen.main.bounds.size.width - 40, font: self.lblDesc.font)
                if height >  70{
                    btnMore.isHidden = false
                }
                else{
                    btnMore.isHidden = true
                }
                
                let heightRemark = (property.object(forKey: "remark") as? String ?? "").height(withConstrainedWidth: UIScreen.main.bounds.size.width - 40, font: self.lblReamrk.font)
                if heightRemark >  70{
                    btnMoreRemark.isHidden = false
                }
                else{
                    btnMoreRemark.isHidden = true
                }
                
                if let host = property.object(forKey: "host") as? NSDictionary{
                    self.idHost = host.object(forKey: "id") as? String ?? ""
                    let firstName = host.object(forKey: "fname") as? String ?? ""
                    let lastName = host.object(forKey: "lname") as? String ?? ""
                    self.idHost = host.object(forKey: "id") as? String ?? ""
                    self.nameHost = firstName + " " + lastName
                    if let pic = host.object(forKey: "pic") as? String{
                        self.imgHost.sd_setImage(with: URL.init(string: pic))
                        self.imgHost.setupImageViewer(
                            urls: [URL.init(string: pic)!],
                            initialIndex: 0,
                            options: [
                                
                            ],
                            from: self)
                    }
                    if lastName.count > 0{
                        let l = lastName.prefix(1)
                        self.lblName.text = firstName + " " + l
                    }
                    else{
                        self.lblName.text = firstName
                    }
                    
                }
            }
        }
        else{
            if let dict = dictDetail{
                if let property = dict.object(forKey: "property") as? NSDictionary{
                    let id = (property.object(forKey: "pid") as? String ?? "")
                    lblID.text = id
                    self.share_url = (property.object(forKey: "url") as? String ?? "")
                    let rent = property.object(forKey: "rent") as? String ?? ""
                    let rtype = property.object(forKey: "rtype") as? String ?? ""
                    if let type = property.object(forKey: "type") as? String, type == "Rent"{
                        
                        lblRent.text  = "$" + rent + "/" + rtype
                    }
                    else{
                        
                        lblRent.text  = "$" + rent
                    }
                    
                    lblType.text = property.object(forKey: "type") as? String
                    let address = property.object(forKey: "address") as? String ?? ""
                    let city = property.object(forKey: "city") as? String ?? ""
                    let state = property.object(forKey: "state") as? String ?? ""
                    let zip = property.object(forKey: "zip") as? String ?? ""
                    let country = property.object(forKey: "country ") as? String ?? ""
                    lblAddress.text =   city + " " + state + " " + zip
                    lblDesc.text = property.object(forKey: "discription") as? String
                    lblReamrk.text = property.object(forKey: "remark") as? String
                    lblDesc.numberOfLines = 3
                    lblReamrk.numberOfLines = 3
                    if lblReamrk.text!.isEmpty{
                        lblTitleSpecial.isHidden = true
                    }
                    self.arrPhotos.removeAll()
                    if let img1 = property.object(forKey: "img1") as? String{
                        arrPhotos.append(LINK_URL.URL_PHOTO + img1)
                    }
                    if let img1 = property.object(forKey: "img2") as? String{
                        arrPhotos.append(LINK_URL.URL_PHOTO + img1)
                    }
                    if let img1 = property.object(forKey: "img3") as? String{
                        arrPhotos.append(LINK_URL.URL_PHOTO + img1)
                    }
                    
                    if let img1 = property.object(forKey: "img4") as? String{
                        arrPhotos.append(LINK_URL.URL_PHOTO + img1)
                    }
                    urlPhotos.removeAll()
                    for arrPhoto in arrPhotos {
                        urlPhotos.append(URL.init(string: arrPhoto)!)
                    }
                    cltPhotos.reloadData()
                    let height = (property.object(forKey: "discription") as? String ?? "").height(withConstrainedWidth: UIScreen.main.bounds.size.width - 40, font: self.lblDesc.font)
                    if height >  70{
                        btnMore.isHidden = false
                    }
                    else{
                        btnMore.isHidden = true
                    }
                    
                    let heightRemark = (property.object(forKey: "remark") as? String ?? "").height(withConstrainedWidth: UIScreen.main.bounds.size.width - 40, font: self.lblReamrk.font)
                    if heightRemark >  70{
                        btnMoreRemark.isHidden = false
                    }
                    else{
                        btnMoreRemark.isHidden = true
                    }
                    
                    if let host = property.object(forKey: "host") as? NSDictionary{
                        let firstName = host.object(forKey: "fname") as? String ?? ""
                        let lastName = host.object(forKey: "lname") as? String ?? ""
                        self.idHost = host.object(forKey: "id") as? String ?? ""
                        self.nameHost = firstName + " " + lastName
                        if let pic = host.object(forKey: "pic") as? String{
                            self.imgHost.sd_setImage(with: URL.init(string: pic))
                            self.imgHost.setupImageViewer(
                                urls: [URL.init(string: pic)!],
                                initialIndex: 0,
                                options: [
                                    
                                ],
                                from: self)
                        }
                        if lastName.count > 0{
                            let l = lastName.prefix(1)
                            self.lblName.text = firstName + " " + l
                        }
                        else{
                            self.lblName.text = firstName
                        }
                        
                    }
                }
            }
        }
        
    }
    
    @IBAction func doMessage(_ sender: Any) {
        if self.isCheckLogin(){
            let vc = SendMessageRRVC.init(nibName: "SendMessageRRVC", bundle: nil)
            vc.profileName = self.nameHost
            vc.profileID = self.idHost
            vc.idDetailSearch = true
            vc.messageDefault = lblID.text!
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else{
            let vc = UIStoryboard.init(name: "MainRR", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            vc.isLogin = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    func showHideBtnNextPrev(){
        if arrDatas.count == 1{
            btnPre.isHidden = true
            btnNext.isHidden = true
        }
        else{
            if indexPosition == 0{
                btnPre.isHidden = true
                btnNext.isHidden = false
            }
            else  if indexPosition == arrDatas.count - 1{
                btnPre.isHidden = false
                btnNext.isHidden = true
            }
            else{
                btnPre.isHidden = false
                btnNext.isHidden = false
            }
        }
        
    }
}

extension DetailPropertyViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrPhotos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = cltPhotos.dequeueReusableCell(withReuseIdentifier: "PhotoCollect", for: indexPath) as! PhotoCollect
        cell.imgCell.sd_setImage(with: URL(string: arrPhotos[indexPath.row]), placeholderImage:nil, options: .continueInBackground) { image, error, cacheType, url in
            print("errro-------->",error)
        }
        //cell.imgCell.sd_setImage(with: URL.init(string: arrPhotos[indexPath.row]))
        cell.imgCell.setupImageViewer(
            urls: urlPhotos,
            initialIndex: indexPath.item,
            options: [
                
            ],
            from: self)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: cltPhotos.frame.size.height, height: cltPhotos.frame.size.height)
    }
}
