//
//  Define.swift
//  Shereef Homes
//
//  Created by QTS Coder on 09/08/2023.
//

import Foundation
import UIKit

let APP_NAME = "Super App"
let USER_ID_RR = "USER_ID_RR"
let USER_ID = "USER_ID"
let USER_PASSWORD = "USER_PASSWORD"
let DEVICE_IPAD = UIDevice.current.userInterfaceIdiom == .pad

struct URL_APP {
    static let URL_SERVER = "https://matcheron.com/"
    static let URL_QA = "https://matcheron.com/qanda.html"
    static let URL_MAKING = "https://www.matcheron.com/making/index.html"
}


struct URL_API {
    static let SERVER = "https://matcheron.com/api/"
}
let API_SUPER_APP =  "https://superapp.app/api/"
let USER_ID_SUPER_APP =  "USER_ID_SUPER_APP"
let DATETIMESHOWMALE = 24 * 60 * 60


enum MENU_APP: String{
    case Home = "Home"
    case MyProfile = "MyProfile"
    case Search = "Search"
    case Notifications = "Notifications"
    case Messages = "Messages"
    case Likes = "Likes"
    case Maybe = "Maybe"
    case Liked = "Liked"
    case MatchMaking = "MatchMaking"
    case PartnerApps = "PartnerApps"
    case Mixers = "Mixers"
    case QA = "QA"
    case DeleteAccount = "DeleteAccount"
    case Terms = "Terms"
    case ContactUs = "ContactUs"
    case Logout = "Logout"

}
struct FONT_NAME {
    static let FUTURA_REGULAR = "Futura-Medium"
    static let FUTURA_MEDIUM = "Futura-Bold"
    static let FUTURA_LIGHT = "futura-Light"
}
extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

let SIZE_FONT_LABEL = CGFloat(16.0)
let SIZE_FONT_NAV = CGFloat(22.0)
let SIZE_FONT_TEXT = CGFloat(17.0)
let DATETIMESHOWCAR = Double(24 * 60 * 60)
struct ERROR_MESSAGE{
    static let EMAIL_REQUIRED = "Email is required"
    static let EMAIL_INVALID = "Email is invalid"
    static let PASSWORD_REQUIRED = "Password is required"
    static let FIRSTNAME_REQUIRED = "First Name is required"
    static let LASTNAME_REQUIRED = "Last Name is required"
    static let COMPANY_REQUIRED = "Company is required"
    static let USERNAME_REQUIRED = "Username is required"
    static let TELEPHONE_REQUIRED = "Telephone is required"
    static let LOCATION_REQUIRED = "Location Address is required"
    static let CITY_REQUIRED = "City is required"
    static let ZIPCODE_REQUIRED = "Zipcode is required"
    static let COUNTRY_REQUIRED = "Country is required"
    static let STATE_REQUIRED = "State is required"
    static let AVATAR_REQUIRED = "Photo is required"
    static let FULLNAME_REQUIRED = "Fullname is required"
    static let MESSAGE_REQUIRED = "Messages is required"
}
struct LINK_URL{
    static let URL_BLOG = "http://www.roomrently.com/blog.php"
    static let URL_PHOTO = "https://roomrently.com/uploads/list/"
    static let URL_CC = "https://www.circlecue.com/roomrently"
    static let URL_IS = "https://www.instagram.com/myroomrently"
    
}


struct API_URL{
    static let URL_SERVER = "https://roomrently.com/api/"
    static let URL_ADDMESSAGE = "\(URL_SERVER)addmsg.php"
    static let URL_MESSAGES = "\(URL_SERVER)messages.php"
    static let URL_CHAT_MESSAGES = "\(URL_SERVER)msglist.php"
    static let URL_DELETE_MESSAGES = "\(URL_SERVER)deletemsg.php"
    static let URL_UPDATE_TOKEN = "\(URL_SERVER)update_imei.php"
    static let URL_GETNOTIFICATIONS = "\(URL_SERVER)push_notifications.php"
    static let URL_SEEN_NOTIFICATIONS = "\(URL_SERVER)seen.php"
    static let URL_DELETE_NOTIFICATION = "\(URL_SERVER)delete_notification.php"
    
}


struct ERROR_MSG{
    static let MSG_FULLNAME = "Full Name is required"
    static let MSG_TELEPHONE = "Telephone is required"
    static let MSG_EMAIL = "Email is required"
    static let MSG_EMAIL_INVALID = "Email is invalid"
    static let MSG_MESSAGE = "Message is required"
    static let MSG_ADDRESS = "Street address is required"
    static let MSG_STATE = "State is required"
    static let MSG_ZIPCODE = "ZIP code is required"
    static let MSG_UNIT = "Unit is required"
}




enum MENU_RR: String{
    case Home = "Home"
    case Search = "Search"
    case MyProfile = "My Profile"
    case MyProperty = "MyProperty"
    case MyInquiry = "My Inquiry"
    case Wanted = "Wanted"
    case Notifications = "Notifications"
    case Messages = "Messages"
    case PartnerApps = "Partner Apps"
    case Blog = "Blog"
    case ContactUs = "Contact Us"
    case Logout = "Logout"
 

}
