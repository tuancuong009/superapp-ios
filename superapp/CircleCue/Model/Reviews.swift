//
//  Reviews.swift
//  CircleCue
//
//  Created by QTS Coder on 11/24/20.
//

import UIKit

struct Review {
    var id: String = ""
    var uid1: String = ""
    var uid2: String = ""
    var rname: String = ""
    var bname: String = ""
    var bemail: String = ""
    var rating: Double = 0.0
    var content: String = ""
    var rply: String?
    var createdDate: Date?
    
    var isRepling: Bool = false
    
    var isReplied: Bool {
        return rply != nil && rply?.isEmpty == false
    }
    
    init(dic: NSDictionary) {
        if let id = dic.value(forKey: "id") as? String {
            self.id = id
        }
        if let uid1 = dic.value(forKey: "uid1") as? String {
            self.uid1 = uid1
        }
        if let uid2 = dic.value(forKey: "uid2") as? String {
            self.uid2 = uid2
        }
        if let rname = dic.value(forKey: "rname") as? String {
            self.rname = rname
        }
        if let bname = dic.value(forKey: "bname") as? String {
            self.bname = bname
        }
        if let bemail = dic.value(forKey: "bemail") as? String {
            self.bemail = bemail
        }
        if let ratingString = dic.value(forKey: "rating") as? String, let rating = Double(ratingString) {
            self.rating = rating
        }
        if let content = dic.value(forKey: "content") as? String {
            self.content = content
        }
        if let rply = dic.value(forKey: "rply") as? String {
            self.rply = rply
        }
        if let created = dic.value(forKey: "created") as? String, !created.isEmpty {
            self.createdDate = created.toAPIDate()
        }
    }
}
