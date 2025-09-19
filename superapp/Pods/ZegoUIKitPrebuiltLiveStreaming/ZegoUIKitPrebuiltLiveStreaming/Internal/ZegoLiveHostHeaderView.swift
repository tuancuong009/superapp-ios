//
//  ZegoLiveHostHeaderView.swift
//  ZegoUIKitPrebuiltLiveStreaming
//
//  Created by zego on 2022/10/31.
//

import UIKit
import ZegoUIKit

class ZegoLiveHostHeaderView: UIView {
    
    var host: ZegoUIKitUser? {
        didSet {
            guard let host = host else {
                self.headNameLabel.text = ""
                return
            }
            self.setHeadUserName(host.userName ?? "", host.userID ?? "")
        }
    }
    
//    lazy var headLabel: UILabel = {
//        let label = UILabel()
//        label.font = UIFont.systemFont(ofSize: 23, weight: .semibold)
//        label.textAlignment = .center
//        label.textColor = UIColor.colorWithHexString("#222222")
//        label.backgroundColor = UIColor.colorWithHexString("#DBDDE3")
//        return label
//    }()
    
    lazy var avatarImageV: UIImageView = {
        let label = UIImageView()
        label.backgroundColor = UIColor.colorWithHexString("#DBDDE3")
        return label
    }()
    
    lazy var headNameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = UIColor.colorWithHexString("#FFFFFF")
        return label
    }()
    lazy var btnProfile: UIButton = {
        let label = UIButton()
        label.setTitle("", for: .normal)
        label.backgroundColor = .clear
        return label
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.colorWithHexString("#1E2740", alpha: 0.4)
        self.addSubview(avatarImageV)
        self.addSubview(headNameLabel)
        self.addSubview(btnProfile)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.setupLayout()
    }
    
    func setupLayout() {
        self.avatarImageV.layer.masksToBounds = true
        self.avatarImageV.layer.cornerRadius = 14
        self.avatarImageV.frame = CGRect(x: 3, y: 3, width: 28, height: 28)
        self.headNameLabel.frame = CGRect(x: self.avatarImageV.frame.maxX + 6, y: 6, width: self.frame.size.width - 31 - 16, height: self.frame.size.height - 12)
        self.btnProfile.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
    }
    
    private func setHeadUserName(_ userName: String, _ avatar: String) {
//        if userName.count > 0 {
//            let firstStr: String = String(userName[userName.startIndex])
//            self.headLabel.text = firstStr
//        }
    
      
        let arrs = userName.components(separatedBy: "=")
        
        if arrs.count == 1 || arrs.count == 0{
            self.headNameLabel.text = userName
        }
        else{
            self.headNameLabel.text = arrs[0]
            if !arrs[1].isEmpty{
                getData(from: URL.init(string: arrs[1])!) { data, response, error in
                        guard let data = data, error == nil else { return }
                        print("Download Finished")
                        // always update the UI from the main thread
                        DispatchQueue.main.async() { [weak self] in
                            self?.avatarImageV.image = UIImage(data: data)
                        }
                    }
            }
        }
        
       
    }
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
}
