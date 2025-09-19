//
//  PhotoLike.swift
//  CircleCue
//
//  Created by QTS Coder on 1/8/21.
//

import Foundation

struct PhotoLike {
    var id: String = ""
    var uid: String = ""
    var username: String = ""
    var pic: String = ""
    var created: Date?
    
    init(dic: NSDictionary?) {
        if let id = dic?.value(forKey: "id") as? String {
            self.id = id
        }
        if let uid = dic?.value(forKey: "uid") as? String {
            self.uid = uid
        }
        if let username = dic?.value(forKey: "username") as? String {
            self.username = username
        }
        if let pic = dic?.value(forKey: "pic") as? String {
            if pic.hasPrefix("http") {
                self.pic = pic
            } else {
                self.pic = Constants.UPLOAD_URL + pic
            }
        }
        if let created = dic?.value(forKey: "created") as? String {
            self.created = created.toAPIDate()
        }
    }
}
