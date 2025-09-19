//
//  SocialMedias.swift
//  CircleCue
//
//  Created by QTS Coder on 10/7/20.
//

import UIKit
import AVKit

struct PrivacyItem {
    var type: PrivacyType
    var isPrivate: Bool = false
    
    var isPrivateValue: String {
        return isPrivate ? "1" : "0"
    }
}

struct SocialMediaObj {
    var type: SocialMedia
    var isPrivate: Bool = false
    var username: String? = nil
    
    var isPrivateValue: Int {
        return isPrivate ? 1 : 0
    }
}

struct HomeSocialItem {
    var type: SocialMedia
    var link: String?
    var numberOfClick: Int = 0
    var isPrivate: Bool = false
    
    var isPrivateValue: Int {
        return isPrivate ? 1 : 0
    }
    
    var shouldHide: Bool {
        return (isPrivate || link == nil || link?.isEmpty == true)
    }
}

struct ProfileInfomation {
    var type: ProfileItem = .email
    var email: String = ""
    var push: Bool = true
    var mobile: String = ""
    var city: String = ""
    var title: String = ""
    var bio: String = ""
    var blog: String = ""
    var notification: Bool = false
    var showLocation: Bool = false
    var uploadResumePrivate: Bool = true
    var albumPrivate: Bool = false
    var reviewPrivate: Bool = false
    var circle_status: Bool = false
    var blog_status: Bool = false
    var value: Any {
        switch type {
        case .email:
            return email
        case .pushNotification:
            return push ? 1 : 0
        case .emailNotification:
            return notification ? 1 : 0
        case .city:
            return city.isEmpty ? " " : city
        case .title:
            return title.isEmpty ? " " : title
        case .bio:
            return bio.isEmpty ? " " : bio
        case .blog:
            return blog.isEmpty ? " " : blog
        case .location:
            return showLocation ? 1 : 0
        case .blog_status:
            return blog_status ? 1 : 0
        case .uploadResume:
            return uploadResumePrivate ? "true" : "false"
        case .album:
            return albumPrivate ? 0 : 1
        case .review:
            return reviewPrivate ? 1 : 0
        case .circle_number:
            return circle_status ? 1 : 0
        }
    }
    
    init() {}

    init(type: ProfileItem) {
        self.type = type
        guard let user = AppSettings.shared.currentUser else { return }
        switch type {
        case .email:
            self.email = user.email ?? ""
        case .pushNotification:
            self.push = user.push
        case .emailNotification:
            self.notification = user.notification
        case .city:
            self.city = user.city
        case .title:
            self.title = user.title
        case .bio:
            self.bio = user.bio
        case .blog:
            self.blog = user.blog
        case .blog_status:
            print("user.blog_status--->",user.blog_status)
            self.blog_status = user.blog_status
        case .location:
            self.showLocation = user.showlocation
        case .uploadResume:
            self.uploadResumePrivate = user.resume_status
        case .album:
            self.albumPrivate = user.album_status
        case .review:
            self.reviewPrivate = user.review_status
        case .circle_number:
            self.circle_status = user.circle_status
        }
    }
}

struct EditSocialObject {
    var type: ProfileItemType
    var isExpanding: Bool = false
    var socialItems: [HomeSocialItem]
    var profileItems: [ProfileInfomation] = []
    var customLinkItems: [CustomLink] = []
    
    var isSelectingAll: Bool {
        return socialItems.filter({$0.isPrivate == false}).isEmpty
    }
}

struct CustomLink {
    var id: Int = 0
    var type: CustomLinkType = .custom
    var name: String = ""
    var link: String = ""
    var isPrivate: Bool = false
    
    var isPrivateValue: String {
        return isPrivate ? "true" : "false"
    }
    
    var key: String {
        if (name.isEmpty && link.isEmpty) {
            return ""
        }
        return "\(name)&\(link)&\(isPrivateValue)"
    }
    
    init(type: CustomLinkType = .custom, name: String, link: String, isPrivate: Bool = false) {
        self.type = type
        self.name = name
        self.link = link
        self.isPrivate = isPrivate
    }
    
    init(index: Int) {
        self.id = index
        self.type = .custom
        self.name = ""
        self.link = ""
        self.isPrivate = false
    }
    
    init(dic: NSDictionary) {
        if let id = dic.value(forKey: "id") as? String, let value = id.int {
            self.id = value
        }
        if let name = dic.value(forKey: "name") as? String {
            self.name = name
        }
        if let value = dic.value(forKey: "value") as? String {
            self.link = value
        }
        if let status = dic.value(forKey: "status") as? String, let value = status.bool {
            self.isPrivate = value
        }
    }
}

struct Notes {
    var title: String = ""
    var description: String = ""
    var date: Date = Date()
    var image: UIImage? = nil
    var imageURL: String? = nil
    
    var isNoteImage: Bool {
        return (image != nil || imageURL != nil)
    }
}

struct BusinessUser {
    var type: BusinessUserType = .circleUser
    var user: String = ""
    var businessName: String = ""
    var email: String = ""
}

struct BusinessFeedback {
    var id: Int = 0
    var feedback_username: String = ""
    var date: Date = Date()
    var feedback_comment: String = ""
    var ratingNumber: Double = 0
    var isReplied: Bool = false
    var reply_comment: String?
    var isRepling: Bool = false
    var user: BusinessUser = BusinessUser()
}
