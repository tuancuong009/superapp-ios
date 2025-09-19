//
//  User.swift
//  CircleCue
//
//  Created by QTS Coder on 10/30/20.
//

import Foundation

struct UniversalUser {
    var id: String?
    var username: String?
    var country: String?
    var pic: String?
    var facebook: String?
    var instagram: String?
    var twitter: String?
    var title: String?
    var bio: String?
    var city: String?
    var fname: String?
    var lname: String?
    var premium: Bool = false
    var profileUrl: String {
        return Constants.HOME_PAGE_WEBSITE + (username ?? "")
    }
    
    var location: String? {
        if let city = city {
            return city
        } else if let country = country {
            return country
        }
        return nil
    }
    
    var locationInfomation: String {
        if let city = city?.trimmed, !city.isEmpty, let title = title?.trimmed, !title.isEmpty {
            return "\(title)\n\(city)"
        } else if let country = country?.trimmed, !country.isEmpty, let title = title?.trimmed, !title.isEmpty {
            return "\(title)\n\(country)"
        } else if let title = title?.trimmed, !title.isEmpty {
            return "\(title)"
        } else if let city = city {
            return city
        } else if let country = country {
            return country
        }
        return ""
    }
    
    init(photoComment: PhotoComment) {
        self.username = photoComment.username
        self.id = photoComment.uid
        self.pic = photoComment.pic
    }
    
    init(likeUser: PhotoLike) {
        self.id = likeUser.uid
        self.username = likeUser.username
        self.pic = likeUser.pic
    }
    
    init(circleUser: CircleUser) {
        self.id = circleUser.id
        self.username = circleUser.username
        self.country = circleUser.country
        self.pic = circleUser.pic
    }
    
    init(followingUser: FollowingUser) {
        self.id = followingUser.fromid
        self.username = followingUser.username
        self.pic = followingUser.pic
    }
    
    init(id: String?, username: String?, country: String?, pic: String?) {
        self.id = id
        self.username = username
        self.country = country
        self.pic = pic
    }
    
    init(dic: NSDictionary?) {
        guard let dic = dic else { return }
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
        if let facebook = dic.value(forKey: "facebook") as? String {
            self.facebook = facebook
        }
        if let instagram = dic.value(forKey: "instagram") as? String {
            self.instagram = instagram
        }
        if let twitter = dic.value(forKey: "twitter") as? String {
            self.twitter = twitter
        }
        
        if let title = dic.value(forKey: "title") as? String {
            self.title = title
        }
        if let bio = dic.value(forKey: "bio") as? String {
            self.bio = bio
        }
        if let city = dic.value(forKey: "city") as? String {
            self.city = city
        }
        
        if let premium = dic.value(forKey: "premium") as? String, let intPre = Int(premium) {
            self.premium = intPre == 1 ? true : false
        }
        else if let premium = dic.value(forKey: "premium") as? Int {
            self.premium = premium == 1 ? true : false
        }
        if let fname = dic.value(forKey: "fname") as? String {
            self.fname = fname.trimmed
        }
        if let lname = dic.value(forKey: "lname") as? String {
            self.lname = lname.trimmed
        }
    }
}


struct UserLogin {
    var userId: String?
    var username: String?
    var pic: String?
    var pic2: String?
    var phone: String?
    var originPicPath: String?
    
    var needUpdateAvatar: Bool {
        if originPicPath == nil || originPicPath?.lowercased().contains("usericon.png") == true {
            return true
        }
        return false
    }
    
    init(dic: NSDictionary?) {
        guard let dic = dic else { return }
        if let id = dic.value(forKey: "Data") as? String, !id.isEmpty {
            self.userId = id
        } else if let id = dic.value(forKey: "Data") as? Int {
            self.userId = "\(id)"
        }
        if let username = dic.value(forKey: "username") as? String {
            self.username = username
        }
        if let phone = dic.value(forKey: "phone") as? String {
            self.phone = phone
        }
        if let pic = dic.value(forKey: "pic") as? String, !pic.isEmpty {
            self.originPicPath = pic
            if pic.hasPrefix("http") {
                self.pic = pic
            } else {
                self.pic = Constants.UPLOAD_URL + pic
            }
        }
        if let pic2 = dic.value(forKey: "pic2") as? String {
            if pic2.hasPrefix("http") {
                self.pic2 = pic2
            } else {
                self.pic2 = Constants.UPLOAD_URL + pic2
            }
        }
    }
    
    init(userId: String?) {
        self.userId = userId
    }
}

struct FollowingUser {
    var id: String = ""
    var fromid: String = ""
    var toid: String = ""
    var username: String = ""
    var created: Date?
    var pic: String = ""
    
    init(dic: NSDictionary?) {
        self.id = dic?.string(forKey: "id") ?? ""
        self.fromid = dic?.string(forKey: "fromid") ?? ""
        self.toid = dic?.string(forKey: "toid") ?? ""
        self.username = dic?.string(forKey: "username") ?? ""
        self.created = dic?.string(forKey: "created")?.toAPIDate()
        if let pic = dic?.string(forKey: "pic"), !pic.isEmpty {
            if pic.hasPrefix("http") {
                self.pic = pic
            } else {
                self.pic = Constants.UPLOAD_URL + pic
            }
        }
    }
}

class UserInfomation {
    var userId: String?
    var favc: Bool = false
    var countt: Int = 0
    var block: Bool = false
    var block_me: Bool = false
    var status: InnerCircleStatus = .no
    var idd: String?
    var req: String?
    var accountType: AccountType = .personal
    var username: String?
    var fname: String?
    var lname: String?
    var mobile: String?
    var email: String?
    var push: Bool = true
    var notification: Bool = false
    var showlocation: Bool = false
    var pic: String?
    var pic2: String?
    var pic3: String?
    var resume: String?
    var resume_text: String?
    var resume_title: String?
    var resume_status: Bool = false
    var country: String?
    var facebook: String?
    var facebook_status: Bool = false
    var snap_chat: String?
    var snap_chat_status: Bool = false
    var instagram: String?
    var instagram_status: Bool = false
    var linkedIn: String?
    var linkedIn_status: Bool = false
    var twitter: String?
    var twitter_status: Bool = false
    var skype: String?
    var skype_status: Bool = false
    var you_tube: String?
    var you_tube_status: Bool = false
    var yelp: String?
    var yelp_status: Bool = false
    var tinder: String?
    var tinder_status: Bool = false
    var reddit: String?
    var reddit_status: Bool = false
    var flickr: String?
    var flickr_status: Bool = false
    var whatsapp: String?
    var whatsapp_status: Bool = false
    var tumblr: String?
    var tumblr_status: Bool = false
    var match: String?
    var match_status: Bool = false
    var meet_up: String?
    var meet_up_status: Bool = false
    var my_space: String?
    var my_space_status: Bool = false
    var pinterest: String?
    var pinterest_status: Bool = false
    var zoosk: String?
    var zoosk_status: Bool = false
    var okcupid: String?
    var okcupid_status: Bool = false
    var jdate: String?
    var jdate_status: Bool = false
    var hinge: String?
    var hinge_status: Bool = false
    var bumble: String?
    var bumble_status: Bool = false
    var wechat: String?
    var wechat_status: Bool = false
    var viber: String?
    var viber_status: Bool = false
    var quora: String?
    var quora_status: Bool = false
    var plenty_of_fish: String?
    var plenty_of_fish_status: Bool = false
    var personal_web_site: String?
    var personal_web_site_status: Bool = false
    var business_web_site: String?
    var business_web_site_status: Bool = false
    var tiktok: String?
    var tiktok_status: Bool = false
    var facebookcount: Int = 0
    var snap_chatcount: Int = 0
    var instagramcount: Int = 0
    var linkedIncount: Int = 0
    var twittercount: Int = 0
    var google_pluscount: Int = 0
    var skypecount: Int = 0
    var you_tubecount: Int = 0
    var yelpcount: Int = 0
    var tindercount: Int = 0
    var redditcount: Int = 0
    var flickrcount: Int = 0
    var whatsappcount: Int = 0
    var tumblrcount: Int = 0
    var matchcount: Int = 0
    var meet_upcount: Int = 0
    var my_spacecount: Int = 0
    var pinterestcount: Int = 0
    var zooskcount: Int = 0
    var okcupidcount: Int = 0
    var jdatecount: Int = 0
    var hingecount: Int = 0
    var bumblecount: Int = 0
    var wechatcount: Int = 0
    var vibercount: Int = 0
    var quoracount: Int = 0
    var plenty_of_fishcount: Int = 0
    var personal_web_sitecount: Int = 0
    var business_web_sitecount: Int = 0
    var profilecount: Int = 0
    var tiktokcount: Int = 0
    var dating_status: Bool = false
    var dinner_status: Bool?
    var travel_status: Bool?
    var album_status: Bool = false
    var blog_status: Bool = false
    var job_status: Bool = false
    var review_status: Bool = false
    var circle_status: Bool = false
    var totalcircle: Int = 0
    var gender: Gender?
    var album_count: Int = 0
    var blog_count: Int = 0
    var job_count: Int = 0
    var review_count: Int = 0
    var zip: String = ""
    var city: String = ""
    var state: String = ""
    var bio: String = ""
    var title: String = ""
    var blog: String = ""
    var premium: Bool = false
    var is_verified: Bool = true
    var followingcount: Int = 0
    var followercount: Int = 0
    var isfollowingcount: Int = 0
    var isfollowercount: Int = 0
    var likec: Bool = false
    var notifications: Bool = false
    var total_likes: Int = 0
    var html: String = ""
    var banner_image: String?
    var hideCircleInnerNumber: Bool {
        return (circle_status || totalcircle == 0)
    }
    
    var hideReview: Bool {
        return (review_status || review_count == 0)
    }
    
    var hideJob: Bool {
        if accountType == .personal {
            return true
        }
        return (job_status || job_count == 0)
    }
    
    var hideBlog: Bool {
        if accountType == .personal {
            return true
        }
        return (blog_status || blog_count == 0)
    }
    
    var hideResume: Bool {
        if accountType == .business {
            return true
        }
        return resume_status == true || (resume == nil && resume_text == nil)
    }
    
    var locationInfomation: String {
        if !city.trimmed.isEmpty, !title.trimmed.isEmpty {
            return "\(title)\n\(city)"
        } else if !city.isEmpty {
            return "\(city)"
        } else if !title.trimmed.isEmpty {
            return "\(title)"
        }
        return ""
    }
    
    var followingDisplay: String {
        "\(followingcount.string) Following"
    }
    
    var followerDisplay: String {
        if followercount > 1 {
            return "\(followercount.string) Followers"
        }
        
        return "\(followercount.string) Follower"
    }
    
    init(item: SearchResume) {
        if !item.resume_title.isEmpty {
            self.resume_title = item.resume_title
        }
        if !item.resume_text.isEmpty {
            self.resume_text = item.resume_text
        }
        if !item.resume.isEmpty {
            self.resume = item.resume
        }
    }
        
    init(dic: NSDictionary?, userId: String? = nil, isPrivacy: Bool = false) {
        guard let dic = dic else { return }
        
        self.userId = userId
        
        if let favc = dic.value(forKey: "favc") as? Int {
            self.favc = favc.bool
        }
        if let likec = dic.value(forKey: "likec") as? Int {
            self.likec = likec.bool
        }
        if let countt = dic.value(forKey: "countt") as? Int {
            self.countt = countt
        }
        if let total_likes = dic.value(forKey: "total_likes") as? Int {
            self.total_likes = total_likes
        }
        if let block = dic.value(forKey: "block") as? Int {
            self.block = block.bool
        }
        if let block_me = dic.value(forKey: "block_me") as? Int {
            self.block_me = block_me.bool
        }
        if let pic = dic.value(forKey: "pic") as? String, !pic.isEmpty {
            if pic.hasPrefix("http") {
                self.pic = pic
            } else {
                self.pic = Constants.UPLOAD_URL + pic
            }
        }
        if let pic2 = dic.value(forKey: "pic2") as? String, !pic2.isEmpty {
            if pic2.hasPrefix("http") {
                self.pic2 = pic2
            } else {
                self.pic2 = Constants.UPLOAD_URL + pic2
            }
        }
        
        if let pic3 = dic.value(forKey: "pic3") as? String, !pic3.isEmpty {
            if pic3.hasPrefix("http") {
                self.pic3 = pic3
            } else {
                self.pic3 = Constants.UPLOAD_URL + pic3
            }
        }
        
        if let status = dic.value(forKey: "status") as? String, let type = InnerCircleStatus(rawValue: status) {
            self.status = type
        }
        if let idd = dic.value(forKey: "idd") as? String {
            self.idd = idd
        }
        if let req = dic.value(forKey: "req") as? String {
            self.req = req
            if status == .receivedPending {
                if req == "1" {
                    self.status = .sentPending
                } else if req == "2" {
                    self.status = .receivedPending
                }
            }
        }
        if let isbusiness = dic.value(forKey: "isbusiness") as? String, let type = AccountType(rawValue: isbusiness) {
            self.accountType = type
        }
        if let username = dic.value(forKey: "username") as? String {
            self.username = username
        }
        
        if let fname = dic.value(forKey: "fname") as? String {
            self.fname = fname
        }
        if let lname = dic.value(forKey: "lname") as? String {
            self.lname = lname
        }
        if let mobile = dic.value(forKey: "mobile") as? String {
            self.mobile = mobile
        }
        if let email = dic.value(forKey: "email") as? String {
            self.email = email
        }
        if let push = dic.value(forKey: "push") as? String {
            self.push = push.bool ?? false
        }
        if let notifications = dic.value(forKey: "notifications") as? String {
            self.notifications = notifications.bool ?? false
        }
        
        if let notification = dic.value(forKey: "notification") as? String {
            self.notification = notification.bool ?? false
        }
        if let showlocation = dic.value(forKey: "showlocation") as? String {
            self.showlocation = showlocation.bool ?? false
        }
        if let html = dic.value(forKey: "html") as? String {
            self.html = html
        }
        if let resume = dic.value(forKey: "resume") as? String, !resume.isEmpty, !resume.lowercased().contains("undefined") {
            if resume.hasPrefix("https") {
                self.resume = resume
            } else {
                self.resume = Constants.UPLOAD_URL + resume
            }
        }
        if let resume_text = dic.value(forKey: "resume_text") as? String, !resume_text.trimmed.isEmpty {
            self.resume_text = resume_text.trimmed
        }
        if let resume_title = dic.value(forKey: "resume_title") as? String, !resume_title.trimmed.isEmpty {
            self.resume_title = resume_title.trimmed
        }
        if let resume_status = dic.value(forKey: "resume_status") as? String {
            self.resume_status = resume_status.bool ?? false
        }
        if let country = dic.value(forKey: "country") as? String {
            self.country = country
        }
        if let facebook = dic.value(forKey: "facebook") as? String {
            self.facebook = facebook
        }
        if let facebook_status = dic.value(forKey: "facebook_status") as? String {
            self.facebook_status = facebook_status.bool ?? false
        }
        if let snap_chat = dic.value(forKey: "snap_chat") as? String {
            self.snap_chat = snap_chat
        }
        if let snap_chat_status = dic.value(forKey: "snap_chat_status") as? String {
            self.snap_chat_status = snap_chat_status.bool ?? false
        }
        if let instagram = dic.value(forKey: "instagram") as? String {
            self.instagram = instagram
        }
        if let instagram_status = dic.value(forKey: "instagram_status") as? String {
            self.instagram_status = instagram_status.bool ?? false
        }
        if let linkedIn = dic.value(forKey: "linkedIn") as? String {
            self.linkedIn = linkedIn
        }
        if let linkedIn_status = dic.value(forKey: "linkedIn_status") as? String {
            self.linkedIn_status = linkedIn_status.bool ?? false
        }
        if let twitter = dic.value(forKey: "twitter") as? String {
            self.twitter = twitter
        }
        if let twitter_status = dic.value(forKey: "twitter_status") as? String {
            self.twitter_status = twitter_status.bool ?? false
        }
        if let skype = dic.value(forKey: "skype") as? String {
            self.skype = skype
        }
        if let skype_status = dic.value(forKey: "skype_status") as? String {
            self.skype_status = skype_status.bool ?? false
        }
        if let you_tube = dic.value(forKey: "you_tube") as? String {
            self.you_tube = you_tube
        }
        if let you_tube_status = dic.value(forKey: "you_tube_status") as? String {
            self.you_tube_status = you_tube_status.bool ?? false
        }
        if let hulu = dic.value(forKey: "hulu") as? String {
            self.yelp = hulu
        }
        if let hulu_status = dic.value(forKey: "hulu_status") as? String {
            self.yelp_status = hulu_status.bool ?? false
        }
        if let tinder = dic.value(forKey: "tinder") as? String {
            self.tinder = tinder
        }
        if let tinder_status = dic.value(forKey: "tinder_status") as? String {
            self.tinder_status = tinder_status.bool ?? false
        }
        if let reddit = dic.value(forKey: "reddit") as? String {
            self.reddit = reddit
        }
        if let reddit_status = dic.value(forKey: "reddit_status") as? String {
            self.reddit_status = reddit_status.bool ?? false
        }
        if let flickr = dic.value(forKey: "flickr") as? String {
            self.flickr = flickr
        }
        if let flickr_status = dic.value(forKey: "flickr_status") as? String {
            self.flickr_status = flickr_status.bool ?? false
        }
        if let whatsapp = dic.value(forKey: "whatsapp") as? String {
            self.whatsapp = whatsapp.replacingOccurrences(of: "https://wa.me/", with: "")
        }
        if let whatsapp_status = dic.value(forKey: "whatsapp_status") as? String {
            self.whatsapp_status = whatsapp_status.bool ?? false
        }
        if let tumblr = dic.value(forKey: "tumblr") as? String {
            self.tumblr = tumblr
        }
        if let tumblr_status = dic.value(forKey: "tumblr_status") as? String {
            self.tumblr_status = tumblr_status.bool ?? false
        }
        if let match = dic.value(forKey: "match") as? String {
            self.match = match
        }
        if let match_status = dic.value(forKey: "match_status") as? String {
            self.match_status = match_status.bool ?? false
        }
        if let meet_up = dic.value(forKey: "meet_up") as? String {
            self.meet_up = meet_up
        }
        if let meet_up_status = dic.value(forKey: "meet_up_status") as? String {
            self.meet_up_status = meet_up_status.bool ?? false
        }
        if let my_space = dic.value(forKey: "my_space") as? String {
            self.my_space = my_space
        }
        if let my_space_status = dic.value(forKey: "my_space_status") as? String {
            self.my_space_status = my_space_status.bool ?? false
        }
        if let shaadi = dic.value(forKey: "shaadi") as? String {
            self.pinterest = shaadi
        }
        if let shaadi_status = dic.value(forKey: "shaadi_status") as? String {
            self.pinterest_status = shaadi_status.bool ?? false
        }
        if let zoosk = dic.value(forKey: "zoosk") as? String {
            self.zoosk = zoosk
        }
        if let zoosk_status = dic.value(forKey: "zoosk_status") as? String {
            self.zoosk_status = zoosk_status.bool ?? false
        }
        if let okcupid = dic.value(forKey: "okcupid") as? String {
            self.okcupid = okcupid
        }
        if let okcupid_status = dic.value(forKey: "okcupid_status") as? String {
            self.okcupid_status = okcupid_status.bool ?? false
        }
        if let jdate = dic.value(forKey: "jdate") as? String {
            self.jdate = jdate
        }
        if let jdate_status = dic.value(forKey: "jdate_status") as? String {
            self.jdate_status = jdate_status.bool ?? false
        }
        if let hinge = dic.value(forKey: "hinge") as? String {
            self.hinge = hinge
        }
        if let hinge_status = dic.value(forKey: "hinge_status") as? String {
            self.hinge_status = hinge_status.bool ?? false
        }
        if let qq = dic.value(forKey: "qq") as? String {
            self.bumble = qq
        }
        if let qq_status = dic.value(forKey: "qq_status") as? String {
            self.bumble_status = qq_status.bool ?? false
        }
        if let wechat = dic.value(forKey: "wechat") as? String {
            self.wechat = wechat
        }
        if let wechat_status = dic.value(forKey: "wechat_status") as? String {
            self.wechat_status = wechat_status.bool ?? false
        }
        if let viber = dic.value(forKey: "viber") as? String {
            self.viber = viber
        }
        if let viber_status = dic.value(forKey: "viber_status") as? String {
            self.viber_status = viber_status.bool ?? false
        }
        if let quora = dic.value(forKey: "quora") as? String {
            self.quora = quora
        }
        if let quora_status = dic.value(forKey: "quora_status") as? String {
            self.quora_status = quora_status.bool ?? false
        }
        if let plenty_of_fish = dic.value(forKey: "plenty_of_fish") as? String {
            self.plenty_of_fish = plenty_of_fish
        }
        if let plenty_of_fish_status = dic.value(forKey: "plenty_of_fish_status") as? String {
            self.plenty_of_fish_status = plenty_of_fish_status.bool ?? false
        }
        if let personal_web_site = dic.value(forKey: "personal_web_site") as? String {
            self.personal_web_site = personal_web_site
        }
        if let personal_web_site_status = dic.value(forKey: "personal_web_site_status") as? String {
            self.personal_web_site_status = personal_web_site_status.bool ?? false
        }
        if let business_web_site = dic.value(forKey: "business_web_site") as? String {
            self.business_web_site = business_web_site
        }
        if let business_web_site_status = dic.value(forKey: "business_web_site_status") as? String {
            self.business_web_site_status = business_web_site_status.bool ?? false
        }
        if let tiktok = dic.value(forKey: "tiktok") as? String {
            self.tiktok = tiktok
        }
        if let tiktok_status = dic.value(forKey: "tiktok_status") as? String {
            self.tiktok_status = tiktok_status.bool ?? false
        }
        if let facebookcount = dic.value(forKey: "facebookcount") as? String, let value = facebookcount.int {
            self.facebookcount = value
        }
        if let facebookcount = dic.value(forKey: "facebookcount") as? String, let value = facebookcount.int {
            self.facebookcount = value
        }
        if let instagramcount = dic.value(forKey: "instagramcount") as? String, let value = instagramcount.int {
            self.instagramcount = value
        }
        if let linkedIncount = dic.value(forKey: "linkedIncount") as? String, let value = linkedIncount.int {
            self.linkedIncount = value
        }
        if let twittercount = dic.value(forKey: "twittercount") as? String, let value = twittercount.int {
            self.twittercount = value
        }
        if let you_tubecount = dic.value(forKey: "you_tubecount") as? String, let value = you_tubecount.int {
            self.you_tubecount = value
        }
        if let hulucount = dic.value(forKey: "hulucount") as? String, let value = hulucount.int {
            self.yelpcount = value
        }
        if let tindercount = dic.value(forKey: "tindercount") as? String, let value = tindercount.int {
            self.tindercount = value
        }
        if let redditcount = dic.value(forKey: "redditcount") as? String, let value = redditcount.int {
            self.redditcount = value
        }
        if let flickrcount = dic.value(forKey: "flickrcount") as? String, let value = flickrcount.int {
            self.flickrcount = value
        }
        if let whatsappcount = dic.value(forKey: "whatsappcount") as? String, let value = whatsappcount.int {
            self.whatsappcount = value
        }
        if let tumblrcount = dic.value(forKey: "tumblrcount") as? String, let value = tumblrcount.int {
            self.tumblrcount = value
        }
        if let matchcount = dic.value(forKey: "matchcount") as? String, let value = matchcount.int {
            self.matchcount = value
        }
        if let meet_upcount = dic.value(forKey: "meet_upcount") as? String, let value = meet_upcount.int {
            self.meet_upcount = value
        }
        if let my_spacecount = dic.value(forKey: "my_spacecount") as? String, let value = my_spacecount.int {
            self.my_spacecount = value
        }
        if let shaadicount = dic.value(forKey: "shaadicount") as? String, let value = shaadicount.int {
            self.pinterestcount = value
        }
        if let zooskcount = dic.value(forKey: "zooskcount") as? String, let value = zooskcount.int {
            self.zooskcount = value
        }
        if let okcupidcount = dic.value(forKey: "okcupidcount") as? String, let value = okcupidcount.int {
            self.okcupidcount = value
        }
        if let jdatecount = dic.value(forKey: "jdatecount") as? String, let value = jdatecount.int {
            self.jdatecount = value
        }
        if let hingecount = dic.value(forKey: "hingecount") as? String, let value = hingecount.int {
            self.hingecount = value
        }
        if let qqcount = dic.value(forKey: "qqcount") as? String, let value = qqcount.int {
            self.bumblecount = value
        }
        if let wechatcount = dic.value(forKey: "wechatcount") as? String, let value = wechatcount.int {
            self.wechatcount = value
        }
        if let vibercount = dic.value(forKey: "vibercount") as? String, let value = vibercount.int {
            self.vibercount = value
        }
        if let quoracount = dic.value(forKey: "quoracount") as? String, let value = quoracount.int {
            self.quoracount = value
        }
        if let plenty_of_fishcount = dic.value(forKey: "plenty_of_fishcount") as? String, let value = plenty_of_fishcount.int {
            self.plenty_of_fishcount = value
        }
        if let personal_web_sitecount = dic.value(forKey: "personal_web_sitecount") as? String, let value = personal_web_sitecount.int {
            self.personal_web_sitecount = value
        }
        if let business_web_sitecount = dic.value(forKey: "business_web_sitecount") as? String, let value = business_web_sitecount.int {
            self.business_web_sitecount = value
        }
        if let profilecount = dic.value(forKey: "profilecount") as? Int {
            self.profilecount = profilecount
        }
        if let tiktokcount = dic.value(forKey: "tiktokcount") as? String, let value = tiktokcount.int {
            self.tiktokcount = value
        }
        if let dating_status = dic.value(forKey: "dating_status") as? String {
            self.dating_status = dating_status.bool ?? false
        }
        if let dinner_status = dic.value(forKey: "dinner_status") as? String {
            self.dinner_status = dinner_status.bool
        }
        if let travel_status = dic.value(forKey: "travel_status") as? String {
            self.travel_status = travel_status.bool
        }
        if let album_status = dic.value(forKey: "album_status") as? String {
            if isPrivacy {
                self.album_status = album_status.bool ?? false
            } else {
                self.album_status = !(album_status.bool ?? true)
            }
        }
        if let blog_status = dic.value(forKey: "blog_status") as? String {
            self.blog_status = blog_status.bool ?? false
            print("self.blog_status--->",self.blog_status)
        }
        if let job_status = dic.value(forKey: "job_status") as? String {
            self.job_status = job_status.bool ?? false
        }
        if let review_status = dic.value(forKey: "review_status") as? String {
            self.review_status = review_status.bool ?? false
        }
        if let circle_status = dic.value(forKey: "circle_status") as? String {
            self.circle_status = circle_status.bool ?? false
        }
        if let totalcircle = dic.value(forKey: "totalcircle") as? Int {
            self.totalcircle = totalcircle
        }
        if let genderStr = dic.value(forKey: "gender") as? String, let gender = Gender(rawValue: genderStr) {
            self.gender = gender
        }
        if let album_count = dic.value(forKey: "album_count") as? Int {
            self.album_count = album_count
        }
        if let blog_count = dic.value(forKey: "blog_count") as? Int {
            self.blog_count = blog_count
        }
        if let job_count = dic.value(forKey: "job_count") as? Int {
            self.job_count = job_count
        }
        if let review_count = dic.value(forKey: "review_count") as? Int {
            self.review_count = review_count
        }
        if let zip = dic.value(forKey: "zip") as? String {
            self.zip = zip.trimmed
        } else if let zipCode = dic.value(forKey: "zip") as? Int {
            self.zip = "\(zipCode)"
        }
        
        if let city = dic.value(forKey: "city") as? String {
            self.city = city.trimmed
        }
        if let state = dic.value(forKey: "state") as? String {
            self.state = state.trimmed
        }
        if let blog = dic.value(forKey: "blog") as? String {
            self.blog = blog.trimmed
        }
        if let bio = dic.value(forKey: "bio") as? String {
            self.bio = bio.trimmed
        }
        if let title = dic.value(forKey: "title") as? String {
            self.title = title.trimmed
        }
        if let banner_image = dic.value(forKey: "banner_image") as? String {
            self.banner_image = banner_image.trimmed
        }
        if let premium = dic.value(forKey: "premium") as? Bool {
            self.premium = premium
        } else if let premium = dic.value(forKey: "premium") as? Int {
            self.premium = premium.bool
        } else if let premium = dic.value(forKey: "premium") as? String {
            self.premium = premium.bool ?? false
        }
        
        if let is_verified = dic.value(forKey: "is_verified") as? Bool {
            self.is_verified = is_verified
        } else if let is_verified = dic.value(forKey: "is_verified") as? Int {
            self.is_verified = is_verified.bool
        } else if let is_verified = dic.value(forKey: "is_verified") as? String {
            self.is_verified = (is_verified.bool ?? true)
        }
        
        self.followingcount = dic.int(forKey: "followingcount") ?? 0
        self.followercount = dic.int(forKey: "followercount") ?? 0
        self.isfollowingcount = dic.int(forKey: "isfollowingcount") ?? 0
        self.isfollowercount = dic.int(forKey: "isfollowercount") ?? 0
        
    }
    
    init() {
    }
    
    func mergeUser(with privacyUser: UserInfomation?) -> UserInfomation {
        guard let privacyUser = privacyUser else { return self}
        let user = self
        user.facebook_status = privacyUser.facebook_status
        user.instagram_status = privacyUser.instagram_status
        user.linkedIn_status = privacyUser.linkedIn_status
        user.twitter_status = privacyUser.twitter_status
        user.tiktok_status = privacyUser.tiktok_status
        user.pinterest_status = privacyUser.pinterest_status
        user.snap_chat_status = privacyUser.snap_chat_status
        user.you_tube_status = privacyUser.you_tube_status
        user.skype_status = privacyUser.skype_status
        user.whatsapp_status = privacyUser.whatsapp_status
        user.viber_status = privacyUser.viber_status
        user.match_status = privacyUser.match_status
        user.yelp_status = privacyUser.yelp_status
        user.meet_up_status = privacyUser.meet_up_status
        user.tinder_status = privacyUser.tinder_status
        user.okcupid_status = privacyUser.okcupid_status
        user.zoosk_status = privacyUser.zoosk_status
        user.hinge_status = privacyUser.hinge_status
        user.plenty_of_fish_status = privacyUser.plenty_of_fish_status
        user.wechat_status = privacyUser.wechat_status
        user.tumblr_status = privacyUser.tumblr_status
        user.flickr_status = privacyUser.flickr_status
        user.quora_status = privacyUser.quora_status
        user.bumble_status = privacyUser.bumble_status
        user.personal_web_site_status = privacyUser.personal_web_site_status
        user.business_web_site_status = privacyUser.business_web_site_status
        user.album_status = privacyUser.album_status
        user.resume_status = privacyUser.resume_status
        user.review_status = privacyUser.review_status
        
        return user
    }
}

struct BusinessUserObject {
    var id: String = ""
    var username: String = ""
    
    init(dic: NSDictionary) {
        if let id = dic.value(forKey: "id") as? String {
            self.id = id
        }
        
        if let username = dic.value(forKey: "username") as? String {
            self.username = username
        }
    }
}

struct UserCircleObject {
    var id: String = ""
    var dating_status: Bool?
    var travel_status: Bool?
    var dine_status: Bool?
    
    init(dic: NSDictionary) {
        self.id = dic.string(forKey: "id") ?? ""
        self.dating_status = dic.string(forKey: "Data")?.bool
        self.travel_status = dic.string(forKey: "travel_status")?.bool
        self.dine_status = dic.string(forKey: "dine_status")?.bool
    }
}
