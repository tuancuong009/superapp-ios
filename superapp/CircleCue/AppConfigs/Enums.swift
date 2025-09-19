//
//  Enums.swift
//  CircleCue
//
//  Created by QTS Coder on 10/14/20.
//

import UIKit

enum StoryboardName: String {
    case authentication = "AuthenticationStoryboard"
    case main = "Main"
}

enum AppDateFormat: String {
    case noteAPI = "MMM,dd yyyy"
    case addNote = "MM/dd/yyyy"
    case noteDashboard = "MMM dd, yyyy"
    case messageDashboard = "MMM dd, hh:mm a"
    case messageAPI = "MMM,dd hh:mm a"
    case album = "MMM dd"
    case full = "yyyy-MM-dd HH:mm:ss"
    case timeZone = "yyyy-MM-dd HH:mm:ss Z"
    case messageStream = "MMMM dd.yyyy"
}

enum ErrorMessage: String {
    case emailInvalid = "Email address is invalid format."
    case emailEmpty = "Email/Username is required."
    case passwordIsEmpty = "Password is required."
    case newPasswordIsEmpty = "New Password is required."
    case confirmDoesNotMatch = "Confirm Password does not match."
    case usernameIsEmpty = "Username is required."
    case emailIsEmpty = "Email address is required."
    case phoneEmpty = "Business Telephone is required."
    case phoneInvalid = "Phone number is invalid format."
    case pictureMissing = "Please upload a photo (Must upload real photo or the profile will not be activated)."
    case termNotAgree = "Please accept terms and conditions."
    case titleEmpty = "Title is required."
    case noteEmpty = "Note is required."
    case dateEmpty = "Date is required."
    case businessUserEmpty = "Business User is required."
    case contentEmpty = "Content/Detail is required."
    case photoEmpty = "Photo/Video is required."
    case captionEmpty = "Caption is required."
    case locationEmpty = "Location is required."
    case zipcodeEmpty = "Zip Code is required."
    case bioEmpty = "Bio/Details is required."
    case cityEmpty = "City is required."
    
    case businessNameEmpty = "Name/Address of the Business is required."
    case notRating = "Select a star rating."
    case reviewEmpty = "Review message is required."
    
    case paymentMobilephoneEmpty = "Mobile phone is required"
    case paymentCashAppIdEmpty = "Cash App ID is required"
    case paymentPaypalEmailEmpty = "Pay Pal Email ID is required"
    case paymentPaypalEmailInvalid = "Pay Pal Email ID is invalid format"
    case paymentFullNameEmpty = "Full Name is required"
    case paymentAddressEmpty = "Address is required"
    case paymentCityEmpty = "City is required"
    case paymentStateEmpty = "State is required"
    case paymentZipEmpty = "Zip is required"
    case selectPayPalSelect = "Please check the box on how you want the winning paid"
    case firstNameIsEmpty = "First Name is required."
    case lastNameIsEmpty = "Last Name is required."
    case businessNameIsEmpty = "Business Name is required."
}

enum Authentication: String {
    case text = "By using our app, you agree to our Term and Conditions and Privacy Policy"
    case term = "Term and Conditions"
    case pp = "Privacy Policy"
    
    var urlString: String {
        switch self {
        case .term:
            return "https://circlecue.com/terms.html"
        case .pp:
            return "https://circlecue.com/user/privacy"
        default:
            return ""
        }
    }
}

enum AppInfomation: Int {
    case about = 0
    case FAQ = 1
    case showcase = 2
    
    var url: String {
        switch self {
        case .about:
            return "https://circlecue.com/about.php"
        case .FAQ:
            return "https://circlecue.com/faq.php"
        case .showcase:
            return "https://circlecue.com/user/showcase"
        }
    }
}

enum AccountType: String {
    case personal = "0"
    case business = "1"
    
    var text: String? {
        switch self {
        case .business:
            return "Business Account"
        case .personal:
            return "Personal Account"
        }
    }
}

enum FavoriteStatus {
    case favorite
    case unFavorite
    
    var description: String {
        switch self {
        case .favorite:
            return "  Remove from Favorite"
        case .unFavorite:
            return "  Add to Favorite"
        }
    }
    
    mutating func toogle() {
        switch self {
        case .favorite:
            self = .unFavorite
        case .unFavorite:
            self = .favorite
        }
    }
}

enum Gender: String {
    case woman = "0"
    case man = "1"
    
    var searchValue: String {
        switch self {
        case .woman:
            return "1"
        case .man:
            return "0"
        }
    }
}

enum InnerCircleStatus: String {
    case receivedPending = "0"
    case inner = "1"
    case sentPending = "3"
    case no = "4"
    
    var description: String {
        switch self {
        case .no:
            return "INNER CIRCLE REQUEST"
        case .inner:
            return "ALREADY IN YOUR CIRCLE"
        case .receivedPending:
            return "APPROVE REQUEST"
        case .sentPending:
            return "REQUEST PENDING"
        }
    }
}

enum MenuItem: String {
    case dashboard = "Dashboard"
    case benifit = "Benefits"
    case feed = "Feed"
    case profile = "Profile"
    case notification = "Notifications"
    case search = "SEARCH"
    case ourCircle = "Our Circle"
    case crowdFunding = "Crowdfunding"
    case mycirlce = "My Circle"
    case favorites = "Favorites"
    case message = "Inbox Messages"
    case notes = "Notes/Reminders"
    case myResume = "Resume/Bio"
    case album = "Album/Gallery"
    case jobOffer = "Job Postings"
    case datingCircle = "Dating Circle"
    case dineoutCircle = "Dinning Circle"
    case travelCircle = "Travel Circle"
    case business_review = "Reviews/Feedback "
    case personal_review = "Reviews/Feedback"
    case nearby = "Nearby Users"
    case changepassword = "Change Password"
    case help = "Help"
    case logout = "Logout"
    case blog = "Blogs/Events"
    case settings = "Settings"
    case circular_chat = "Circular Chat"
    case upgrade_premier_circle = "Upgrade"
    case business_service = "BUSINESS SERVICES"
    case personal_service = "SERVICES"
    case pro_circles = "Pro Circles"
    case referral_credit_payout = "Referral Credit Payout"
    case premier_circle_showcase = "VIP Circle"
    case status = "DeActivate"
    case contact_support = ""
    case special_promos = "Special Promos"
    case expo = "Expo/Seminars"
    case QA = "Q & A"
    case ForSale = "CC Shop"
    case GoLive = "GO LIVE"
    case roomrently = "Partner Apps"
    var image: UIImage? {
        switch self {
        case .dashboard:
            return #imageLiteral(resourceName: "menu_dashboard")
        case .profile:
            return #imageLiteral(resourceName: "menu_profile")
        case .search:
            return #imageLiteral(resourceName: "menu_search")
        case .mycirlce, .ourCircle:
            return #imageLiteral(resourceName: "menu_mycircle")
        case .favorites:
            return #imageLiteral(resourceName: "menu_fav")
        case .message:
            return #imageLiteral(resourceName: "menu_chat")
        case .notes:
            return #imageLiteral(resourceName: "menu_notes")
        case .nearby:
            return #imageLiteral(resourceName: "menu_nearby")
        case .changepassword:
            return #imageLiteral(resourceName: "menu_changepw")
        case .help:
            return #imageLiteral(resourceName: "menu_help")
        case .logout:
            return #imageLiteral(resourceName: "menu_logout")
        case .business_review, .personal_review:
            return #imageLiteral(resourceName: "menu_feedback")
        case .myResume:
            return #imageLiteral(resourceName: "menu_resume")
        case .jobOffer:
            return #imageLiteral(resourceName: "menu_job")
        case .album:
            return UIImage(named: "menu_album")
        case .blog:
            return UIImage(named: "menu_news")
        case .premier_circle_showcase:
            return UIImage(named: "menu_showcase")
        case .feed:
            return UIImage(named: "menu_feed")
        case .settings:
            return UIImage(named: "menu_settings")
        case .circular_chat:
            return UIImage(named: "menu_circular_chat")
        case .upgrade_premier_circle:
            return UIImage(named: "menu_marketing")
        case .business_service, .personal_service:
            return UIImage(named: "menu_services")
        case .pro_circles:
            return UIImage(named: "menu_pro")
        case .referral_credit_payout:
            return UIImage(named: "menu_referral")
        case .contact_support:
            return nil
        case .notification:
            return UIImage(named: "menu_noti")
        case .benifit:
            return UIImage(named: "menu_benefits")
        case .travelCircle:
            return UIImage(named: "menu_travel")
        case .dineoutCircle:
            return UIImage(named: "menu_dine")
        case .datingCircle:
            return UIImage(named: "menu_dating")
        case .status:
            return UIImage(named: "menu_status")
        case .special_promos:
            return UIImage(named: "menu_specialpromos")
        case .expo:
            return UIImage(named: "menu_expo")
        case .QA:
            return UIImage(named: "menu_qa")
        case .ForSale:
            return UIImage(named: "menu_sale")
        case .GoLive:
            return UIImage(named: "menu_live")
        case .crowdFunding:
            return UIImage.init(named: "menu_funding")
        case .roomrently:
            return UIImage.init(named: "menu_logo")
        }
    }
}

enum SocialMedia: String, Comparable {
    static func < (lhs: SocialMedia, rhs: SocialMedia) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }
    
    case facebook = "Facebook"
    case instagram = "Instagram"
    case linkedin = "Linkedin"
    case twitter = "Twitter"
    case website = "Website"
    case tiktok = "Tiktok"
    case pinterest = "Pinterest"
    case snapchat = "Snapchat"
    case youtube = "Youtube"
    case skype = "Skype"
    case whatsapp = "Tel #"
    case viber = "Viber"
    case match = "Match"
    case yelp = "Yelp"
    case meetup = "Meet up"
    case tinder = "Tinder"
    case okcupid = "OkCupid"
    case zoosk = "Zoosk"
    case hinge = "Hinge"
    case plenty = "POF"
    case wechat = "WeChat"
    case tumblr = "Tumblr"
    case flickr = "Flickr"
    case quora = "Quora"
    case bumble = "Bumble"
    case reddit = "Reddit"
    case custom = ""
    case selectAll = "selectAll"
    case blog = "Blog"
    var image: UIImage? {
        switch self {
        case .facebook:
            return #imageLiteral(resourceName: "app_fb")
        case .instagram:
            return #imageLiteral(resourceName: "app_instagram")
        case .linkedin:
            return #imageLiteral(resourceName: "app_linkedin")
        case .twitter:
            return #imageLiteral(resourceName: "app_tt")
        case .website:
            return #imageLiteral(resourceName: "app_web")
        case .tiktok:
            return #imageLiteral(resourceName: "app_tiktok")
        case .pinterest:
            return #imageLiteral(resourceName: "app_pinterest")
        case .snapchat:
            return #imageLiteral(resourceName: "app_snapchat")
        case .youtube:
            return #imageLiteral(resourceName: "app_yt")
        case .skype:
            return #imageLiteral(resourceName: "app_skype")
        case .whatsapp:
            return #imageLiteral(resourceName: "app_whatsapp")
        case .viber:
            return #imageLiteral(resourceName: "app_viber")
        case .match:
            return #imageLiteral(resourceName: "app_match")
        case .yelp:
            return #imageLiteral(resourceName: "app_yelp")
        case .meetup:
            return #imageLiteral(resourceName: "app_meetup")
        case .tinder:
            return #imageLiteral(resourceName: "app_tinder")
        case .okcupid:
            return #imageLiteral(resourceName: "app_okcupid")
        case .zoosk:
            return #imageLiteral(resourceName: "app_zoosk")
        case .hinge:
            return #imageLiteral(resourceName: "app_hinge")
        case .plenty:
            return #imageLiteral(resourceName: "app_plentyoffish")
        case .wechat:
            return #imageLiteral(resourceName: "app_wechat")
        case .tumblr:
            return #imageLiteral(resourceName: "app_tumblr")
        case .flickr:
            return #imageLiteral(resourceName: "app_flickr")
        case .quora:
            return #imageLiteral(resourceName: "app_quora")
        case .bumble:
            return #imageLiteral(resourceName: "app_bumble")
        case .reddit:
            return #imageLiteral(resourceName: "app_reddit")
        case .blog:
            return UIImage(named: "ic_blog")
        default:
            return #imageLiteral(resourceName: "app_web")
        }
    }
    
    var domain: String? {
        switch self {
        case .facebook:
            return "https://www.facebook.com/"
        case .instagram:
            return "https://www.instagram.com/"
        case .linkedin:
            return "https://www.linkedin.com/in/"
        case .twitter:
            return "https://www.twitter.com/"
        case .tiktok:
            return "https://www.tiktok.com/"
        case .pinterest:
            return "https://www.pinterest.com/"
        case .snapchat:
            return "https://www.snapchat.com/add/"
        case .youtube:
            return "https://www.youtube.com/c/"
        case .skype:
            return nil
        case .whatsapp:
            return nil
        case .viber:
            return nil
        case .match:
            return "https://match.com/"
        case .yelp:
            return "https://www.yelp.com/user_details?userid="
        case .meetup:
            return "https://www.meetup.com/"
        case .tinder:
            return "https://tinder.com/"
        case .okcupid:
            return "https://www.okcupid.com/"
        case .zoosk:
            return "https://www.zoosk.com/"
        case .hinge:
            return "https://hinge.co/"
        case .plenty:
            return "https://www.pof.com/"
        case .wechat:
            return "https://www.wechat.com/"
        case .tumblr:
            return "https://www.tumblr.com/"
        case .flickr:
            return "https://www.flickr.com/photos/"
        case .quora:
            return "https://www.quora.com/"
        case .bumble:
            return "https://bumble.com/"
        case .reddit:
            return "https://www.reddit.com/"
        case .website:
            return nil
        case .blog:
            return nil
        case .custom:
            return nil
        case .selectAll:
            return nil
        }
    }
    
    var placeHolder: String? {
        switch self {
        case .facebook:
            return "Facebook username"
        case .instagram:
            return "Instagram username"
        case .twitter:
            return "Twitter username"
        case .linkedin:
            return "Linkedin username"
        case .website:
            return "www.yourwebsite.com"
        case .blog:
            return "Blog username"
        default:
            return nil
        }
    }
    
    var key: String? {
        switch self {
        case .facebook:
            return "facebook"
        case .instagram:
            return "instagram"
        case .linkedin:
            return "linkedIn"
        case .twitter:
            return "twitter"
        case .website:
            if let user = AppSettings.shared.currentUser {
                if user.accountType == .personal {
                    return "personal_web_site"
                }
                return "business_web_site"
            }
            return nil
        case .tiktok:
            return "tiktok"
        case .pinterest:
            return "shaadi"
        case .snapchat:
            return "Snap"
        case .youtube:
            return "you_tube"
        case .skype:
            return "skype"
        case .whatsapp:
            return "whatsapp"
        case .viber:
            return "viber"
        case .match:
            return "match"
        case .yelp:
            return "hulu"
        case .meetup:
            return "meet_up"
        case .tinder:
            return "tinder"
        case .okcupid:
            return "okcupid"
        case .zoosk:
            return "zoosk"
        case .hinge:
            return "hinge"
        case .plenty:
            return "plenty_of_fish"
        case .wechat:
            return "wechat"
        case .tumblr:
            return "tumblr"
        case .flickr:
            return "flickr"
        case .quora:
            return "quora"
        case .bumble:
            return "qq"
        case .reddit:
            return "reddit"
        case .blog:
            return "blog"
        case .custom:
            return ""
        default:
            return nil
        }
    }
    
    var key_status: String? {
        guard let key = self.key else { return nil }
        return key + "_status"
    }
}

enum TopProfileItem: String {
    case addLinks = "Add Your Social Media Links"
    case expand = "Expand your Inner Circle"
    case submitResume = "Submit Resumes to Companies"
    case activateFeedback = "Activate Dating Circle\nProvide Feedback"
    case postJob = "Post Job Opportunities"
    case collectResume = "Collect Resumes"
    case provideFeedback = "Provide Feedback"
    case viewPublicProfile = "View my Public Profile"
}

enum ProfileItemType: Comparable {
    case personalInfo
    case businessInfo
    case sociallinks(String)
    case customlink
    
    var title: String {
        switch self {
        case .personalInfo:
            return "Personal Info"
        case .businessInfo:
            return "Business Info"
        case .sociallinks(let title):
            return "Group \(title)"
        case .customlink:
            return "+ Custom Links"
        }
    }
}

enum ProfileItem: String, Comparable {
    case email = "Email"
    case pushNotification = "Push Notification"
    case emailNotification = "Receive Email Notification"
    case city = "City"
    case title = "Title"
    case bio = "Bio/Details"
    case blog = "Blog"
    case location = "Hide Location"
    case uploadResume = "Resume"
    case album = "Album Gallery"
    case review = "Reviews"
    case circle_number = "Circle Number"
    case blog_status = "Blog Status"
    var key: String {
        switch self {
        case .email:
            return "email"
        case .pushNotification:
            return "push"
        case .emailNotification:
            return "notification"
        case .city:
            return "city"
        case .title:
            return "title"
        case .bio:
            return "bio"
        case .location:
            return "llocation"
        case .blog:
            return "blog"
        case .uploadResume:
            return "resume_status"
        case .album:
            return "album_status"
        case .review:
            return "review_status"
        case .circle_number:
            return "circle_status"
        case .blog_status:
            return "blog_status"
        }
    }
    
    static func < (lhs: ProfileItem, rhs: ProfileItem) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }
}

enum CustomLinkType {
    case addMore
    case custom
}

enum MessageSender {
    case me
    case friend
}

enum MyCircleAction: Int {
    case privacy = 0
    case remove = 1
    case pending = 2
    case cancel = 3
    case accept = 4
    case decline = 5
}

enum BusinessUserType: Int {
    case circleUser = 0
    case any = 1
}

enum MediaUploadType {
    case image
    case video
    
    var mimeType: String {
        switch self {
        case .image:
            return "image/jpg"
        case .video:
            return "video/mp4"
        }
    }
}

enum PrivacyType: Comparable {

    case socialItem(_ item: SocialMedia)
    case album
    case resume
    case review
    
    var title: String? {
        switch self {
        case .album:
            return "Album Gallery"
        case .resume:
            return "Resume"
        case .review:
            return "Review"
        case .socialItem(let item):
            return item.rawValue
        }
    }
    
    var key_status: String? {
        switch self {
        case .socialItem(let item):
            return item.key_status
        case .album:
            return "album_status"
        case .review:
            return "review_status"
        case .resume:
            return "resume_status"
        }
    }
    
    var icon: UIImage? {
        switch self {
        case .socialItem(let item):
            return item.image
        case .album:
            return MenuItem.album.image
        case .review:
            return MenuItem.business_review.image
        case .resume:
            return MenuItem.myResume.image
        }
    }
}
