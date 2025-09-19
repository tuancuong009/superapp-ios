//
//  DummyData.swift
//  CircleCue
//
//  Created by QTS Coder on 10/14/20.
//

import UIKit
import AVKit

class DummyData {
    
    static let share = DummyData()
    
    var editSocialItems: [EditSocialObject] {
        guard let user = AppSettings.shared.currentUser else { return [] }
        let typeA_personal: EditSocialObject = .init(type: .sociallinks("A"),
                                                     socialItems: [.init(type: .selectAll),
                                                                   .init(type: .facebook, link: user.facebook, numberOfClick: user.facebookcount, isPrivate: user.facebook_status),
                                                                   .init(type: .instagram, link: user.instagram, numberOfClick: user.instagramcount, isPrivate: user.instagram_status),
                                                                   .init(type: .linkedin, link: user.linkedIn, numberOfClick: user.linkedIncount, isPrivate: user.linkedIn_status),
                                                                   .init(type: .twitter, link: user.twitter, numberOfClick: user.twittercount, isPrivate: user.twitter_status),
                                                                   .init(type: .tiktok, link: user.tiktok, numberOfClick: user.tiktokcount, isPrivate: user.tiktok_status),
                                                                   .init(type: .website, link: user.personal_web_site, numberOfClick: user.personal_web_sitecount, isPrivate: user.personal_web_site_status)])
        
        let typeA_business: EditSocialObject = .init(type: .sociallinks("A"),
                                                     socialItems: [.init(type: .selectAll),
                                                                   .init(type: .facebook, link: user.facebook, numberOfClick: user.facebookcount, isPrivate: user.facebook_status),
                                                                   .init(type: .instagram, link: user.instagram, numberOfClick: user.instagramcount, isPrivate: user.instagram_status),
                                                                   .init(type: .linkedin, link: user.linkedIn, numberOfClick: user.linkedIncount, isPrivate: user.linkedIn_status),
                                                                   .init(type: .twitter, link: user.twitter, numberOfClick: user.twittercount, isPrivate: user.twitter_status),
                                                                   .init(type: .tiktok, link: user.tiktok, numberOfClick: user.tiktokcount, isPrivate: user.tiktok_status),
                                                                   .init(type: .website, link: user.business_web_site, numberOfClick: user.business_web_sitecount, isPrivate: user.business_web_site_status)])
        
        let typeB: EditSocialObject = .init(type: .sociallinks("B"),
                                            socialItems: [.init(type: .pinterest, link: user.pinterest, numberOfClick: user.pinterestcount, isPrivate: user.pinterest_status),
                                                          .init(type: .snapchat, link: user.snap_chat, numberOfClick: user.snap_chatcount, isPrivate: user.snap_chat_status),
                                                          .init(type: .youtube, link: user.you_tube, numberOfClick: user.you_tubecount, isPrivate: user.you_tube_status),
                                                          .init(type: .skype, link: user.skype, numberOfClick: user.skypecount, isPrivate: user.skype_status),
                                                          .init(type: .whatsapp, link: user.whatsapp, numberOfClick: user.whatsappcount, isPrivate: user.whatsapp_status)])
        
        let typeC: EditSocialObject = .init(type: .sociallinks("C"),
                                            socialItems: [.init(type: .viber, link: user.viber, numberOfClick: user.vibercount, isPrivate: user.viber_status),
                                                          .init(type: .match, link: user.match, numberOfClick: user.matchcount, isPrivate: user.match_status),
                                                          .init(type: .yelp, link: user.yelp, numberOfClick: user.yelpcount, isPrivate: user.yelp_status),
                                                          .init(type: .meetup, link: user.meet_up, numberOfClick: user.meet_upcount, isPrivate: user.meet_up_status)])
        
        let typeD: EditSocialObject = .init(type: .sociallinks("D"),
                                            socialItems: [.init(type: .tinder, link: user.tinder, numberOfClick: user.tindercount, isPrivate: user.tinder_status),
                                                          .init(type: .okcupid, link: user.okcupid, numberOfClick: user.okcupidcount, isPrivate: user.okcupid_status),
                                                          .init(type: .zoosk, link: user.zoosk, numberOfClick: user.zooskcount, isPrivate: user.zoosk_status),
                                                          .init(type: .hinge, link: user.hinge, numberOfClick: user.hingecount, isPrivate: user.hinge_status),
                                                          .init(type: .plenty, link: user.plenty_of_fish, numberOfClick: user.plenty_of_fishcount, isPrivate: user.plenty_of_fish_status)])
        
        let typeE: EditSocialObject = .init(type: .sociallinks("E"),
                                            socialItems: [.init(type: .wechat, link: user.wechat, numberOfClick: user.wechatcount, isPrivate: user.wechat_status),
                                                          .init(type: .tumblr, link: user.tumblr, numberOfClick: user.tumblrcount, isPrivate: user.tumblr_status),
                                                          .init(type: .flickr, link: user.flickr, numberOfClick: user.flickrcount, isPrivate: user.flickr_status),
                                                          .init(type: .quora, link: user.quora, numberOfClick: user.quoracount, isPrivate: user.quora_status),
                                                          .init(type: .bumble, link: user.bumble, numberOfClick: user.bumblecount, isPrivate: user.bumble_status)])
        
        let customLink: EditSocialObject = .init(type: .customlink, isExpanding: false, socialItems: [], profileItems: [], customLinkItems: [.init(type: .addMore, name: "", link: "", isPrivate: false)])
        
        switch user.accountType {
        case .personal:
            return [.init(type: .personalInfo, isExpanding: false, socialItems: [], profileItems: [.init(type: .email),
                                                                                                   .init(type: .emailNotification),
                                                                                                   .init(type: .pushNotification),
                                                                                                   .init(type: .city),
                                                                                                   .init(type: .title),
                                                                                                   .init(type: .bio),
                                                                                                   .init(type: .blog),
                                                                                                   .init(type: .location),
                                                                                                   .init(type: .uploadResume),
                                                                                                   .init(type: .album),
                                                                                                   .init(type: .review),
                                                                                                   .init(type: .circle_number)]),
                    typeA_personal, typeB, customLink, typeC, typeD, typeE]
            
        case .business:
            return [.init(type: .businessInfo, isExpanding: false, socialItems: [], profileItems: [.init(type: .email),
                                                                                                   .init(type: .emailNotification),
                                                                                                   .init(type: .pushNotification),
                                                                                                   .init(type: .city),
                                                                                                   .init(type: .title),
                                                                                                   .init(type: .bio),
                                                                                                   .init(type: .blog),
                                                                                                   .init(type: .location),
                                                                                                   
                                                                                                   .init(type: .album),
                                                                                                   .init(type: .review),
                                                                                                   .init(type: .circle_number)]),
                    typeA_business, typeB, customLink, typeC, typeD, typeE]
        }
    }
    
    func getSocialItem(with user: UserInfomation?) -> [HomeSocialItem] {
        guard let user = user else { return [] }
        var website = HomeSocialItem(type: .website)
        if user.accountType == .business {
            website.link = user.business_web_site
            website.isPrivate = user.business_web_site_status
            website.numberOfClick = user.business_web_sitecount
        } else {
            website.link = user.personal_web_site
            website.isPrivate = user.personal_web_site_status
            website.numberOfClick = user.personal_web_sitecount
        }
        
        return [
                .init(type: .blog, link: user.blog, numberOfClick: user.blog_count, isPrivate: user.blog_status),
                .init(type: .facebook, link: user.facebook, numberOfClick: user.facebookcount, isPrivate: user.facebook_status),
                .init(type: .instagram, link: user.instagram, numberOfClick: user.instagramcount, isPrivate: user.instagram_status),
                .init(type: .linkedin, link: user.linkedIn, numberOfClick: user.linkedIncount, isPrivate: user.linkedIn_status),
                .init(type: .twitter, link: user.twitter, numberOfClick: user.twittercount, isPrivate: user.twitter_status),
                .init(type: .tiktok, link: user.tiktok, numberOfClick: user.tiktokcount, isPrivate: user.tiktok_status),
                .init(type: .pinterest, link: user.pinterest, numberOfClick: user.pinterestcount, isPrivate: user.pinterest_status),
                .init(type: .snapchat, link: user.snap_chat, numberOfClick: user.snap_chatcount, isPrivate: user.snap_chat_status),
                .init(type: .youtube, link: user.you_tube, numberOfClick: user.you_tubecount, isPrivate: user.you_tube_status),
                .init(type: .skype, link: user.skype, numberOfClick: user.skypecount, isPrivate: user.skype_status),
                .init(type: .whatsapp, link: user.whatsapp, numberOfClick: user.whatsappcount, isPrivate: user.whatsapp_status),
                .init(type: .viber, link: user.viber, numberOfClick: user.vibercount, isPrivate: user.viber_status),
                .init(type: .match, link: user.match, numberOfClick: user.matchcount, isPrivate: user.match_status),
                .init(type: .yelp, link: user.yelp, numberOfClick: user.yelpcount, isPrivate: user.yelp_status),
                .init(type: .meetup, link: user.meet_up, numberOfClick: user.meet_upcount, isPrivate: user.meet_up_status),
                .init(type: .tinder, link: user.tinder, numberOfClick: user.tindercount, isPrivate: user.tinder_status),
                .init(type: .okcupid, link: user.okcupid, numberOfClick: user.okcupidcount, isPrivate: user.okcupid_status),
                .init(type: .zoosk, link: user.zoosk, numberOfClick: user.zooskcount, isPrivate: user.zoosk_status),
                .init(type: .hinge, link: user.hinge, numberOfClick: user.hingecount, isPrivate: user.hinge_status),
                .init(type: .plenty, link: user.plenty_of_fish, numberOfClick: user.plenty_of_fishcount, isPrivate: user.plenty_of_fish_status),
                .init(type: .wechat, link: user.wechat, numberOfClick: user.wechatcount, isPrivate: user.wechat_status),
                .init(type: .tumblr, link: user.tumblr, numberOfClick: user.tumblrcount, isPrivate: user.tumblr_status),
                .init(type: .flickr, link: user.flickr, numberOfClick: user.flickrcount, isPrivate: user.flickr_status),
                .init(type: .quora, link: user.quora, numberOfClick: user.quoracount, isPrivate: user.quora_status),
                .init(type: .bumble, link: user.bumble, numberOfClick: user.bumblecount, isPrivate: user.bumble_status), website]
    }
    
    func getPrivacyItem(with user: UserInfomation) -> [PrivacyItem] {
        var website = PrivacyItem(type: .socialItem(.website))
        if user.accountType == .business {
            website.isPrivate = user.business_web_site_status
            return [.init(type: .socialItem(.facebook), isPrivate: user.facebook_status),
                    .init(type: .socialItem(.instagram), isPrivate: user.instagram_status),
                    .init(type: .socialItem(.linkedin), isPrivate: user.linkedIn_status),
                    .init(type: .socialItem(.twitter), isPrivate: user.twitter_status),
                    .init(type: .socialItem(.tiktok), isPrivate: user.tiktok_status),
                    .init(type: .socialItem(.pinterest), isPrivate: user.pinterest_status),
                    .init(type: .socialItem(.snapchat), isPrivate: user.snap_chat_status),
                    .init(type: .socialItem(.youtube), isPrivate: user.you_tube_status),
                    .init(type: .socialItem(.skype), isPrivate: user.skype_status),
                    .init(type: .socialItem(.whatsapp), isPrivate: user.whatsapp_status),
                    .init(type: .socialItem(.viber), isPrivate: user.viber_status),
                    .init(type: .socialItem(.match), isPrivate: user.match_status),
                    .init(type: .socialItem(.yelp), isPrivate: user.yelp_status),
                    .init(type: .socialItem(.meetup), isPrivate: user.meet_up_status),
                    .init(type: .socialItem(.tinder), isPrivate: user.tinder_status),
                    .init(type: .socialItem(.okcupid), isPrivate: user.okcupid_status),
                    .init(type: .socialItem(.zoosk), isPrivate: user.zoosk_status),
                    .init(type: .socialItem(.hinge), isPrivate: user.hinge_status),
                    .init(type: .socialItem(.plenty), isPrivate: user.plenty_of_fish_status),
                    .init(type: .socialItem(.wechat), isPrivate: user.wechat_status),
                    .init(type: .socialItem(.tumblr), isPrivate: user.tumblr_status),
                    .init(type: .socialItem(.flickr), isPrivate: user.flickr_status),
                    .init(type: .socialItem(.quora), isPrivate: user.quora_status),
                    .init(type: .socialItem(.bumble), isPrivate: user.bumble_status),
                    website,
                    .init(type: .album, isPrivate: user.album_status),
                    .init(type: .review, isPrivate: user.review_status)]
        } else {
            website.isPrivate = user.personal_web_site_status
            return [.init(type: .socialItem(.facebook), isPrivate: user.facebook_status),
                    .init(type: .socialItem(.instagram), isPrivate: user.instagram_status),
                    .init(type: .socialItem(.linkedin), isPrivate: user.linkedIn_status),
                    .init(type: .socialItem(.twitter), isPrivate: user.twitter_status),
                    .init(type: .socialItem(.tiktok), isPrivate: user.tiktok_status),
                    .init(type: .socialItem(.pinterest), isPrivate: user.pinterest_status),
                    .init(type: .socialItem(.snapchat), isPrivate: user.snap_chat_status),
                    .init(type: .socialItem(.youtube), isPrivate: user.you_tube_status),
                    .init(type: .socialItem(.skype), isPrivate: user.skype_status),
                    .init(type: .socialItem(.whatsapp), isPrivate: user.whatsapp_status),
                    .init(type: .socialItem(.viber), isPrivate: user.viber_status),
                    .init(type: .socialItem(.match), isPrivate: user.match_status),
                    .init(type: .socialItem(.yelp), isPrivate: user.yelp_status),
                    .init(type: .socialItem(.meetup), isPrivate: user.meet_up_status),
                    .init(type: .socialItem(.tinder), isPrivate: user.tinder_status),
                    .init(type: .socialItem(.okcupid), isPrivate: user.okcupid_status),
                    .init(type: .socialItem(.zoosk), isPrivate: user.zoosk_status),
                    .init(type: .socialItem(.hinge), isPrivate: user.hinge_status),
                    .init(type: .socialItem(.plenty), isPrivate: user.plenty_of_fish_status),
                    .init(type: .socialItem(.wechat), isPrivate: user.wechat_status),
                    .init(type: .socialItem(.tumblr), isPrivate: user.tumblr_status),
                    .init(type: .socialItem(.flickr), isPrivate: user.flickr_status),
                    .init(type: .socialItem(.quora), isPrivate: user.quora_status),
                    .init(type: .socialItem(.bumble), isPrivate: user.bumble_status),
                    website,
                    .init(type: .album, isPrivate: user.album_status),
                    .init(type: .resume, isPrivate: user.resume_status),
                    .init(type: .review, isPrivate: user.review_status)]
        }
    }
}
