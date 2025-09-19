//
//  CircleUser.swift
//  CircleCue
//
//  Created by QTS Coder on 11/4/20.
//

import Foundation

struct CircleUser {
    var count: Int = 0
    var fromid: String = ""
    var toid: String = ""
    var status: InnerCircleStatus = .no
    var idd: String = ""
    var id: String = ""
    var username: String = ""
    var country: String = ""
    var pic: String = ""
    var title: String = ""
    var bio: String = ""
    var premium: Bool = false
    var isSelected: Bool = false
        
    init() {}
    
    init(dic: NSDictionary?) {
        guard let dic = dic else { return }
        if let count = dic.value(forKey: "count") as? Int {
            self.count = count
        }
        if let fromid = dic.value(forKey: "fromid") as? String {
            self.fromid = fromid
        }
        if let toid = dic.value(forKey: "toid") as? String {
            self.toid = toid
        }
        if let status = dic.value(forKey: "status") as? String, let type = InnerCircleStatus(rawValue: status) {
            self.status = type
            if type == .receivedPending {
                if fromid == AppSettings.shared.userLogin?.userId {
                    self.status = .sentPending
                }
            }
        }
        if let premium = dic.value(forKey: "premium") as? Bool {
            self.premium = premium
        }
        if let idd = dic.value(forKey: "idd") as? String {
            self.idd = idd
        }
        if let id = dic.value(forKey: "id") as? String {
            self.id = id
        }
        if let username = dic.value(forKey: "username") as? String {
            self.username = username
        }
        if let country = dic.value(forKey: "country") as? String {
            self.country = country
        }
        if let pic = dic.value(forKey: "pic") as? String, !pic.isEmpty {
            if pic.hasPrefix("http") {
                self.pic = pic
            } else {
                self.pic = Constants.UPLOAD_URL + pic
            }
        }
        if let title = dic.value(forKey: "title") as? String {
            self.title = title
        }
        if let bio = dic.value(forKey: "bio") as? String {
            self.bio = bio
        }
    }
}
