//
//  RadomUser.swift
//  CircleCue
//
//  Created by QTS Coder on 13/1/25.
//

import Foundation
class RadomUser: NSObject {
    var fromid: String = ""
    var status: String = ""
    var idd: String = ""
    var id: String = ""
    var username: String = ""
    var title: String = ""
    var bio: String = ""
    var premium: String = ""
    var country: String = ""
    var pic: String = ""
    var isbusiness = false
    var isRequest = false
    init(dic: NSDictionary?) {
        if let fromid = dic?.value(forKey: "fromid") as? String {
            self.fromid = fromid
        }
     
        if let status = dic?.value(forKey: "status") as? String {
            self.status = status
        }
        if let isbusiness = dic?.value(forKey: "isbusiness") as? String {
            self.isbusiness = isbusiness.bool ?? false
        }
        if let idd = dic?.value(forKey: "idd") as? String {
            self.idd = idd
        }
        if let status = dic?.value(forKey: "status") as? String {
            self.status = status
        }
        if let id = dic?.value(forKey: "id") as? String {
            self.id = id
        }
        if let username = dic?.value(forKey: "username") as? String {
            self.username = username
        }
        if let title = dic?.value(forKey: "title") as? String {
            self.title = title
        }
        
        if let bio = dic?.value(forKey: "bio") as? String {
            self.bio = bio
        }
        
        if let premium = dic?.value(forKey: "premium") as? String {
            self.premium = premium
        }
        
        if let country = dic?.value(forKey: "country") as? String {
            self.country = country
        }
        if let pic = dic?.value(forKey: "pic") as? String {
            if pic.hasPrefix("http") {
                self.pic = pic
            } else {
                self.pic = Constants.UPLOAD_URL + pic
            }
        }
    }
}
