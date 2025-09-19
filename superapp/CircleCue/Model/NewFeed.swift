//
//  NewFeed.swift
//  CircleCue
//
//  Created by QTS Coder on 3/26/21.
//

import Foundation

public struct NewFeed: Equatable {
    
    var id: String = ""
    var uid: String = ""
    var title: String = ""
    var date: String = ""
    var description: String = ""
    var pic: String = ""
    var userpic: String = ""
    var username: String = ""
    var country: String = ""
    var isbusiness: Bool = false
    var comment_count: Int = 0
    var like_count: Int = 0
    var user_like: Bool = false
    var arrComments = [PhotoComment]()
    var isReadMore: Bool = false
    var newFeedType: MediaType {
        if pic.lowercased().contains(".mp4") {
            return .video
        }
        
        return .image
    }
    
    init(dic: NSDictionary) {
        if let id = dic.value(forKey: "id") as? String {
            self.id = id
        }
        if let uid = dic.value(forKey: "uid") as? String {
            self.uid = uid
        }
        if let title = dic.value(forKey: "title") as? String {
            self.title = title
        }
        if let date = dic.value(forKey: "date") as? String {
            self.date = date
        }
        if let description = dic.value(forKey: "description") as? String {
            self.description = description
        }
        if let pic = dic.value(forKey: "pic") as? String, !pic.isEmpty {
            if pic.hasPrefix("http") {
                var mediaPath = pic.replacingOccurrences(of: Constants.UPLOAD_URL_RETURN, with: "")
                mediaPath = pic.replacingOccurrences(of: Constants.UPLOAD_URL, with: "")
                if mediaPath.isEmpty == false && mediaPath.lowercased().contains("undefine") == false {
                    self.pic = pic
                }
            } else {
                self.pic = Constants.UPLOAD_URL + pic
            }
        }
        if let userpic = dic.value(forKey: "userpic") as? String, !userpic.isEmpty {
            if userpic.hasPrefix("http") {
                let mediaPath = userpic.replacingOccurrences(of: Constants.UPLOAD_URL, with: "")
                if mediaPath.isEmpty == false && mediaPath.lowercased().contains("undefine") == false {
                    self.userpic = userpic
                }
            } else {
                self.userpic = Constants.UPLOAD_URL + userpic
            }
        }
        if let comments = dic.value(forKey: "comments") as? [NSDictionary] {
            arrComments.removeAll()
            for comment in comments {
                arrComments.append(PhotoComment.init(dic: comment))
            }
        }
        if let username = dic.value(forKey: "username") as? String {
            self.username = username
        }
        if let country = dic.value(forKey: "country") as? String {
            self.country = country
        }
        if let isbusiness = dic.value(forKey: "isbusiness") as? String {
            self.isbusiness = isbusiness.bool ?? false
        }
        if let comment_count = dic.value(forKey: "comment_count") as? Int {
            self.comment_count = comment_count
        }
        if let like_count = dic.value(forKey: "like_count") as? Int {
            self.like_count = like_count
        }
        if let user_like = dic.value(forKey: "user_like") as? Int {
            self.user_like = user_like.bool
        }
    }
}
