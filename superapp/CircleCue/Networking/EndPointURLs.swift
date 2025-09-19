//
//  EndPointURLs.swift
//  CircleCue
//
//  Created by QTS Coder on 10/30/20.
//

import UIKit
import Alamofire

enum EndpointURL {
    case login
    case register
    case registerBusiness
    case declineRequest
    case acceptRequest
    case nearestUsers
    case search
    case submitContact
    case block
    case checkblock
    case unblock
    case addnote
    case listnotes
    case deletenote
    case inCircleUser
    case addtocircle
    case addtofav
    case removetofav
    case favouritelist
    case sendMessage
    case deleteMessage
    case upload
    case messsagebetweenusers
    case profileInfo
    case updateProfile
    case changePassword
    case customlink
    case visitor
    case messagelist
    case updateAvatar
    case verifyEmail
    case verifyUserName
    case gallery
    case addAlbumPhoto
    case deleteAlbumPhoto
    case blogfetch
    case addblog
    case blogupdate
    case blogdelete
    case addjob
    case jobfetch
    case jobupdate
    case jobdelete
    case userlistbusiness
    case addreviews
    case reviewdelete
    case reviewupdate
    case reviewfetch
    case reviewrply
    case update_my_dating_status
    case get_dating_status_between_users
    case add_dating_status_between_users
    case update_dating_status_between_users
    case listread
    case updateresume
    case deleteresume
    case getprivacy
    case updateprivacy
    case login_with_social
    case showcase
    case add_comment
    case fetch_comment
    case delete_comment
    case fetch_like
    case like_photo
    case unlike_photo
    case circular_list
    case send_circular_chat
    case search_reviews
    case update_gender
    case search_dating_circle
    case search_resume
    case search_job
    case new_feed
    case update_photo_status
    case update_comment
    case feed_clip
    case update_login_status
    case update_token(_ token: String, _ userID: String)
    case updatePushReceiveStatus(userID: String, status: Int)
    case notification(_ userId: String)
    case updateDineoutCircle
    case updateTravelCircle
    case addTravelStatus
    case addDineStatus
    case accountStatus(_ userId: String)
    case updateAccountStatus(_ userId: String, _ status: String)
    case deleteAccount(_ userId: String, _ password: String)
    case createSubscribe
    case cancelSubscribe
    case makeNotificationSeen(_ id: String)
    case deleteNotification(_ id: String)
    case archiveMessage(_ id1: String, _ id2: String)
    case getFollowingUsers
    case getFollowerUser
    case addFollowUser
    case unFollowUser
    case userSource
    case signup_notification(_ id: String)
    case increaseProfileViewer(_ id: String)
    case checkspin
    case addspin
    case addwinner
    case winnerlist
    case winnerhistory(_ id: String)
    case likeProfile
    case unlikeProfile
    case totalLikeProfile
    case streamChatToken(_ id: String)
    case liveStreamSubmit
    case getLiveStream
    case deleteStream(_ id: String)
    case wellcome_notification
    case messagecontent
    case categoryList
    case product_listing
    case addProduct
    case buyProduct
    case myProduct
    case deleteProduct
    case editProduct
    case inquiry_received
    case updatesoldstatus
    case upload_banner
    case radomUser(_ id: String)
    case currentcountry
    case updateNotification
    case state(_ id: String)
    case appmenus
    private var baseURL: String {
        return "https://www.circlecue.com/api/"
    }
    private var baseStripeURL: String {
        return "https://www.circlecue.com/stripe/"
    }
    
    private var baseStreamChatURL: String {
        return "https://www.circlecue.com/api/chat/"
    }
    
    private var url_mmm:String{
        return "https://matcheron.com/api/"
    }
    
    private var superAppUrl: String{
        return "https://superapp.app/api/"
    }
    
    var url: URL {
        switch self {
        case .login:
            return URL.init(string: baseURL + "logex.php")!
        case .register:
            return URL.init(string: baseURL + "regex.php")!
        case .registerBusiness:
            return URL.init(string: baseStripeURL + "regexpay.php")!
        case .declineRequest:
            return URL.init(string: baseURL + "decline.php")!
        case .acceptRequest:
            return URL.init(string: baseURL + "accept.php")!
        case .nearestUsers:
            return URL.init(string: baseURL + "data.php")!
        case .search:
            return URL.init(string: baseURL + "list.php")!
        case .submitContact:
            return URL.init(string: baseURL + "contact.php")!
        case .block:
            return URL.init(string: baseURL + "block.php")!
        case .checkblock:
            return URL.init(string: baseURL + "checkblock.php")!
        case .unblock:
            return URL.init(string: baseURL + "unblock.php")!
        case .addnote:
            return URL.init(string: baseURL + "addnote.php")!
        case .listnotes:
            return URL.init(string: baseURL + "notes.php")!
        case .deletenote:
            return URL.init(string: baseURL + "deletenote.php")!
        case .inCircleUser:
            return URL.init(string: baseURL + "circle.php")!
        case .addtocircle:
            return URL.init(string: baseURL + "addtocircle.php")!
        case .addtofav:
            return URL.init(string: baseURL + "addtofav.php")!
        case .removetofav:
            return URL.init(string: baseURL + "removetofav.php")!
        case .favouritelist:
            return URL.init(string: baseURL + "favourite.php")!
        case .sendMessage:
            return URL.init(string: baseURL + "addmsg.php")!
        case .deleteMessage:
            return URL.init(string: baseURL + "deletemsg.php")!
        case .upload:
            return URL.init(string: baseURL + "upload.php")!
        case .messsagebetweenusers:
            return URL.init(string: baseURL + "msglist.php")!
        case .profileInfo:
            return URL.init(string: baseURL + "usersociallist.php")!
        case .updateProfile:
            return URL.init(string: baseURL + "addsocial.php")!
        case .changePassword:
            return URL.init(string: baseURL + "updatepassword.php")!
        case .customlink:
            return URL.init(string: baseURL + "usersocials.php")!
        case .visitor:
            return URL.init(string: baseURL + "visitors.php")!
        case .messagelist:
            return URL.init(string: baseURL + "messages.php")!
        case .updateAvatar:
            return URL.init(string: baseURL + "uploadss.php")!
        case .verifyEmail:
            return URL.init(string: baseURL + "checkemail.php")!
        case .verifyUserName:
            return URL.init(string: baseURL + "checkusername.php")!
        case .gallery:
            return URL.init(string: baseURL + "gallery.php")!
        case .addAlbumPhoto:
            return URL.init(string: baseURL + "addphotos.php")!
        case .deleteAlbumPhoto:
            return URL.init(string: baseURL + "deletephoto.php")!
        case .blogfetch:
            return URL.init(string: baseURL + "blogfetch.php")!
        case .addblog:
            return URL.init(string: baseURL + "blog.php")!
        case .blogupdate:
            return URL.init(string: baseURL + "blogupdate.php")!
        case .blogdelete:
            return URL.init(string: baseURL + "blogdelete.php")!
        case .addjob:
            return URL.init(string: baseURL + "job.php")!
        case .jobfetch:
            return URL.init(string: baseURL + "jobfetch.php")!
        case .jobupdate:
            return URL.init(string: baseURL + "jobupdate.php")!
        case .jobdelete:
            return URL.init(string: baseURL + "jobdelete.php")!
        case .userlistbusiness:
            return URL.init(string: baseURL + "userlistbusiness.php")!
        case .addreviews:
            return URL.init(string: baseURL + "reviews.php")!
        case .reviewdelete:
            return URL.init(string: baseURL + "reviewdelete.php")!
        case .reviewupdate:
            return URL.init(string: baseURL + "reviewupdate.php")!
        case .reviewfetch:
            return URL.init(string: baseURL + "reviewfetch.php")!
        case .reviewrply:
            return URL.init(string: baseURL + "reviewrply.php")!
        case .update_my_dating_status:
            return URL.init(string: baseURL + "updatedatingstatus.php")!
        case .get_dating_status_between_users:
            return URL.init(string: baseURL + "getstatus.php")!
        case .add_dating_status_between_users:
            return URL.init(string: baseURL + "addstatus.php")!
        case .update_dating_status_between_users:
            return URL.init(string: baseURL + "updatestatus.php")!
        case .listread:
            return URL.init(string: baseURL + "listread.php")!
        case .updateresume:
            return URL.init(string: baseURL + "updateresume.php")!
        case .deleteresume:
            return URL.init(string: baseURL + "delresume.php")!
        case .getprivacy:
            return URL.init(string: baseURL + "userprivacy.php")!
        case .updateprivacy:
            return URL.init(string: baseURL + "addprivacy.php")!
        case .login_with_social:
            return URL.init(string: baseURL + "regex_social.php")!
        case .showcase:
            return URL.init(string: baseURL + "showcase.php")!
        case .add_comment:
            return URL.init(string: baseURL + "addcomment.php")!
        case .fetch_comment:
            return URL.init(string: baseURL + "comments.php")!
        case .delete_comment:
            return URL.init(string: baseURL + "deletecomment.php")!
        case .fetch_like:
            return URL.init(string: baseURL + "likes.php")!
        case .like_photo:
            return URL.init(string: baseURL + "like_photo.php")!
        case .unlike_photo:
            return URL.init(string: baseURL + "unlike_photo.php")!
        case .circular_list:
            return URL.init(string: baseURL + "bulk_msg.php")!
        case .send_circular_chat:
            return URL.init(string: baseURL + "send_bulk_msg.php")!
        case .search_reviews:
            return URL.init(string: baseURL + "search_reviews.php")!
        case .update_gender:
            return URL.init(string: baseURL + "gender.php")!
        case .search_dating_circle:
            return URL.init(string: baseURL + "search.php")!
        case .search_resume:
            return URL.init(string: baseURL + "search_resume.php")!
        case .search_job:
            return URL.init(string: baseURL + "search_job.php")!
        case .new_feed:
            return URL.init(string: baseURL + "feeds.php")!
        case .update_photo_status:
            return URL.init(string: baseURL + "update_photo_status.php")!
        case .update_comment:
            return URL.init(string: baseURL + "updatecomment.php")!
        case .feed_clip:
            return URL.init(string: baseURL + "feeds.php?onlyvideo=1")!
        case .update_login_status:
            return URL.init(string: baseURL + "update_login_status.php")!
        case .update_token(let token, let userId):
            return URL.init(string: baseURL + "update_imei.php?id=\(userId)&imei=\(token)")!
        case .updatePushReceiveStatus(let userID, let status):
            return URL.init(string: baseURL + "push.php?id=\(userID)&push=\(status)")!
        case .notification(let userId):
            return URL.init(string: baseURL + "push_notifications.php?id=\(userId)")!
        case .makeNotificationSeen(let id):
            return URL.init(string: baseURL + "seen.php?id=\(id)")!
        case .deleteNotification(let id):
            return URL.init(string: baseURL + "delete_notification.php?id=\(id)")!
        case .updateDineoutCircle:
            return URL.init(string: baseURL + "update_dinner_status.php")!
        case .updateTravelCircle:
            return URL.init(string: baseURL + "update_travel_status.php")!
        case .addTravelStatus:
            return URL.init(string: baseURL + "addstatus_travel.php")!
        case .addDineStatus:
            return URL.init(string: baseURL + "addstatus_dine.php")!
        case .accountStatus(let userId):
            return URL.init(string: baseURL + "appstatus.php?id=\(userId)")!
        case .updateAccountStatus(let userId, let status):
            return URL.init(string: baseURL + "updateappstatus.php?id=\(userId)&appstatus=\(status)")!
        case .deleteAccount(let userId, let password):
            return URL.init(string: baseURL + "delete_user.php?id=\(userId)&password=\(password)")!
        case .createSubscribe:
            return URL.init(string: "https://www.circlecue.com/stripe/create-sub.php")!
        case .cancelSubscribe:
            return URL.init(string: "https://www.circlecue.com/stripe/cancel_subs.php")!
        case .archiveMessage(let id1, let id2):
            return URL.init(string: baseURL + "archivedmsg.php?id1=\(id1)&id2=\(id2)")!
        case .getFollowingUsers:
            return URL.init(string: baseURL + "following.php")!
        case .getFollowerUser:
            return URL.init(string: baseURL + "follower.php")!
        case .addFollowUser:
            return URL.init(string: baseURL + "follow_user.php")!
        case .unFollowUser:
            return URL.init(string: baseURL + "unfollow_user.php")!
        case .userSource:
            return URL.init(string: baseURL + "user_src.php")!
        case .signup_notification(let userId):
            return URL.init(string: baseURL + "signup_notification.php?id=\(userId)")!
        case .increaseProfileViewer(let userId):
            return URL.init(string: baseURL + "addvisitor.php?uid=\(userId)")!
        case .checkspin:
            return URL.init(string: baseURL + "checkspin.php")!
        case .addspin:
            return URL.init(string: baseURL + "add_spin.php")!
        case .addwinner:
            return URL.init(string: baseURL + "addwinner.php")!
        case .winnerlist:
            return URL.init(string: baseURL + "winnerlist.php")!
        case .winnerhistory(let id):
            return URL.init(string: baseURL + "winnerhistory.php?id=\(id)")!
        case .likeProfile:
            return URL.init(string: baseURL + "addlikes.php")!
        case .unlikeProfile:
            return URL.init(string: baseURL + "removelikes.php")!
        case .totalLikeProfile:
            return URL.init(string: baseURL + "total_likes.php")!
        case .streamChatToken(let userId):
            return URL.init(string: baseStreamChatURL + "chat.php?username=\(userId)")!
        case .liveStreamSubmit:
            return URL.init(string: baseURL + "livestream_submit.php")!
        case .getLiveStream:
            return URL.init(string: baseURL + "livestream_list.php")!
        case .deleteStream(let userId):
            return URL.init(string: baseURL + "delete_livestream.php?id=\(userId)")!
        case .wellcome_notification:
            return URL.init(string: baseURL + "welcome_notification.php")!
        case .messagecontent:
            return URL.init(string: baseURL + "messagecontent.php")!
        case .categoryList:
            return URL.init(string: baseURL + "category_list.php")!
        case .product_listing:
            return URL.init(string: baseURL + "product_listing.php")!
        case .addProduct:
            return URL.init(string: baseURL + "market-submit.php")!
        case .buyProduct:
            return URL.init(string: baseURL + "buy-product.php")!
        case .myProduct:
            return URL.init(string: baseURL + "my_productlist.php")!
        case .deleteProduct:
            return URL.init(string: baseURL + "deleteproduct.php")!
        case .editProduct:
            return URL.init(string: baseURL + "editproduct.php")!
        case .inquiry_received:
            return URL.init(string: baseURL + "inquiry_received.php")!
        case .updatesoldstatus:
            return URL.init(string: baseURL + "updatesoldstatus.php")!
        case .radomUser(let userId):
            return URL.init(string: baseURL + "random_user.php?id=\(userId)")!
        case .upload_banner:
            return URL.init(string: baseURL + "banner_image.php")!
        case .updateNotification:
            return URL.init(string: baseURL + "update_notifications.php")!
        case .currentcountry:
            return URL.init(string: url_mmm + "currentcountry.php")!
        case .state(let id):
            return URL.init(string: url_mmm + "state.php?id=\(id)")!
        case .appmenus:
            return URL.init(string: superAppUrl + "listing.php")!
        }
   
    }
}



