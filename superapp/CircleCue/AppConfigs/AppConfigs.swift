//
//  AppConfigs.swift
//  CircleCue
//
//  Created by QTS Coder on 10/16/20.
//

import UIKit
let APP_DELEGATE = UIApplication.shared.delegate as! AppDelegate
class AppConfiguration {
    
    static let GOOGLE_API_KEY = "AIzaSyD-MkssJdyVMjElpv5G1JCacW0uZEJH9_w"
    static let MILE_CONVERT_VALUE: Double = 1609.344
    static let yourAppID = 1837663712
    static let yourAppSign = "45c10012b49d59e27b2399e9213e13aa383b231b88ed1e625901b114fbd3cf42"
}

class Constants {
    static let red_brown = UIColor(named: "DarkBrown_4d0f28") ?? UIColor.init(hex: "4d0f28")
    static let yellow = UIColor(named: "Yellow_ECE590") ?? UIColor.init(hex: "ECE590")
    static let light_blue = UIColor(named: "Blue_22a9e1") ?? UIColor.init(hex: "22a9e1")
    static let gray_holder = UIColor(named: "Gray_Place_Holder") ?? UIColor.init(hex: "C8C8C8")
    static let violet = UIColor(named: "Violet_672f90") ?? UIColor.init(hex: "672f90")
    static let KEY_USERNAME = "KEY_USERNAME"
    static let KEY_PASSWORD = "KEY_PASSWORD"
    static let KEY_UPDATE_MENU = "KEY_UPDATE_MENU"
    static let SOCIAL_LOGIN = "SOCIAL_LOGIN"
    static let USER_ID = "USER_ID_CC"
    
    static let HOME_PAGE_WEBSITE = "https://www.circlecue.com/"
    static let UPLOAD_URL = "https://www.circlecue.com/api/uploads/"
    static let UPLOAD_URL_RETURN = "https://circlecue.com/api/uploads/"
    
    static let TRAVEL_CIRCLE_REQUEST_MESSSAGE = "Hello: I am interested to explore Travel Circle option with you. You can take a look at my CircleCue Profile; if interested please reply.\n\nThanks"
    static let DINEOUT_CIRCLE_REQUEST_MESSSAGE = "Hello: I am interested to explore Dine out Circle option with you. You can take a look at my CircleCue Profile; if interested please reply.\n\nThanks"
    static let DATING_CIRCLE_REQUEST_MESSSAGE = "Hello: I am interested to explore Dating Circle option with you. You can take a look at my CircleCue Profile; if interested please reply.\n\nThanks"
    static let DATING_CIRCLE_DECLINE_MESSSAGE = "Sorry not interested to explore"
    static let DATING_CIRCLE_ACCEPT_MESSSAGE = "Yes we can explore."
    
    static let URL_RR = "https://roomrently.com/rrently"
}


let DATE_HIDDEN_PAYWALL = "2025-09-24"
