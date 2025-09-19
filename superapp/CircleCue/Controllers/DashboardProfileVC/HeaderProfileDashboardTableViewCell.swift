//
//  HeaderProfileDashboardTableViewCell.swift
//  CircleCue
//
//  Created by QTS Coder on 27/12/24.
//

import UIKit
protocol HeaderProfileDashboardTableViewCellDelegate: AnyObject{
    func didTapFollower()
    func didTapFollowing()
    func didTapPost()
    func didTapEditBanner()
    func didTapAvatar(indexP: Int)
    func didTapRemoveRadomUser(indexP: Int)
    func didTapAddCircle(indexP: Int)
    func didTapProfileUser(indexP: Int)
}
class HeaderProfileDashboardTableViewCell: UITableViewCell {

    @IBOutlet weak var imgAvatar2: UIImageView!
    @IBOutlet weak var imgAvatar1: UIImageView!
    @IBOutlet weak var widthAvatar2: NSLayoutConstraint!
    @IBOutlet weak var imgAvatar3: UIImageView!
    @IBOutlet weak var spaceAvatar2: NSLayoutConstraint!
    @IBOutlet weak var viewAvatar2: UIView!
    @IBOutlet weak var viewAvatar3: UIView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblJob: UILabel!
    @IBOutlet weak var lblAbout: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet var arrButtons: [UIButton]!
    @IBOutlet weak var btnFollowing: UIButton!
    @IBOutlet weak var btnFollowers: UIButton!
    @IBOutlet weak var cltSugess: UICollectionView!
    @IBOutlet weak var imgVip: UIImageView!
    weak var delegate: HeaderProfileDashboardTableViewCellDelegate?
    @IBOutlet weak var bgColor: UIView!
    @IBOutlet weak var heightCltSugess: NSLayoutConstraint!
    @IBOutlet weak var bannerImage: UIImageView!
    var arrRadomUsers = [RadomUser]()
    override func awakeFromNib() {
        super.awakeFromNib()
        for btn in arrButtons{
            btn.layer.cornerRadius = btn.frame.size.height/2
        }
        bgColor.backgroundColor = UIColor(hex: self.randomHexColor())
        cltSugess.registerNibCell(identifier: "SugessCollectionViewCell")
        // Initialization code
    }
    func randomHexColor() -> String {
        let red = Int(arc4random_uniform(256))
        let green = Int(arc4random_uniform(256))
        let blue = Int(arc4random_uniform(256))
        
        // Chuyển đổi sang mã hex
        return String(format: "#%02X%02X%02X", red, green, blue)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func doImage2(_ sender: Any) {
        self.delegate?.didTapAvatar(indexP: 1)
    }
    @IBAction func doImage1(_ sender: Any) {
        self.delegate?.didTapAvatar(indexP: 0)
    }
    @IBAction func doImage3(_ sender: Any) {
        self.delegate?.didTapAvatar(indexP: 2)
    }
    @IBAction func doEditProfile(_ sender: Any) {
        self.delegate?.didTapEditBanner()
    }
    
    func updateUI(_ user: UserInfomation, _ radomUser: [RadomUser]){
       
        cltSugess.alwaysBounceHorizontal = false
        self.arrRadomUsers = radomUser
        self.heightCltSugess.constant = radomUser.count == 0 ? 0 : 176.0
        cltSugess.reloadData()
        imgAvatar1.setImage(with: user.pic ?? "")
        if user.pic2 != nil &&  user.pic3 != nil{
            viewAvatar2.isHidden = false
            viewAvatar3.isHidden = false
            if let pic2 = user.pic2{
                spaceAvatar2.constant = 0
                widthAvatar2.constant = 60
                imgAvatar2.setImage(with: pic2)
            }
            
            if let pic3 = user.pic3{
                imgAvatar3.setImage(with: pic3)
            }
        }
        else if user.pic2 == nil &&  user.pic3 == nil{
            viewAvatar2.isHidden = false
            viewAvatar3.isHidden = false
            imgAvatar2.image = nil
            imgAvatar3.image = nil
        }
        else{
            viewAvatar3.isHidden = false
            imgAvatar3.image = nil
            if let pic2 = user.pic2{
                spaceAvatar2.constant = 10
               // widthAvatar2.constant = 120
                imgAvatar2.setImage(with: pic2)
            }
            else if let pic2 = user.pic3{
                spaceAvatar2.constant = 10
               // widthAvatar2.constant = 120
                imgAvatar2.setImage(with: pic2)
            }
        }
       
        imgAvatar1.layer.cornerRadius = imgAvatar1.frame.size.height/2
        imgAvatar1.layer.masksToBounds = true
        if user.accountType == .business{
            imgAvatar1.layer.borderWidth = 4.0
            imgAvatar1.layer.borderColor = UIColor.init(hex: "2A9AD1").cgColor
        }
        else{
            imgAvatar1.layer.borderWidth = 1.0
            imgAvatar1.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        }
        
        
        imgAvatar2.layer.cornerRadius = imgAvatar2.frame.size.height/2
        imgAvatar2.layer.masksToBounds = true
        
        imgAvatar3.layer.cornerRadius = imgAvatar3.frame.size.height/2
        imgAvatar3.layer.masksToBounds = true
        
       // imgAvatar2.layer.borderWidth = 1.0
       // imgAvatar2.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        
        //imgAvatar3.layer.borderWidth = 1.0
      //  imgAvatar3.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        var name = ""
        if let fname = user.fname
        {
            name = name + fname
        }
        if let lname = user.lname
        {
            name = name + " " + lname
        }
        if name.trimmed.isEmpty{
            name = user.username ?? ""
        }
        lblName.text = name
        lblJob.text  = user.title
        lblAbout.text = user.bio
        lblAddress.text = user.country
        if user.followercount == 0 {
            btnFollowers.setTitle("In Circle", for: .normal)
        }
        else{
            btnFollowers.setTitle("In Circle \(user.followercount)", for: .normal)
        }
        if user.followingcount == 0{
            btnFollowing.setTitle("Me Circling", for: .normal)
        }
        else{
            btnFollowing.setTitle("Me Circling \(user.followingcount)", for: .normal)
        }
        imgVip.isHidden = user.premium ? false : true
    }
    
    @IBAction func doPost(_ sender: Any) {
        self.delegate?.didTapPost()
    }
    @IBAction func doFollower(_ sender: Any) {
        self.delegate?.didTapFollower()
    }
    @IBAction func doFollowing(_ sender: Any) {
        self.delegate?.didTapFollowing()
    }
}

extension HeaderProfileDashboardTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrRadomUsers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = cltSugess.dequeueReusableCell(withReuseIdentifier: "SugessCollectionViewCell", for: indexPath) as! SugessCollectionViewCell
        cell.configCell(arrRadomUsers[indexPath.row])
        cell.tapRemove = { [] in
            self.arrRadomUsers.remove(at: indexPath.row)
            self.cltSugess.reloadData()
            self.delegate?.didTapRemoveRadomUser(indexP: indexPath.row)
        }
        cell.tapAdd = { [] in
            if self.arrRadomUsers[indexPath.row].isRequest{
                return
            }
            self.delegate?.didTapAddCircle(indexP: indexPath.row)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSizeMake(152, cltSugess.frame.size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.delegate?.didTapProfileUser(indexP: indexPath.row)
    }
}
