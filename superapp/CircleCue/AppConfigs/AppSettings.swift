//
//  AppSettings.swift
//  CircleCue
//
//  Created by QTS Coder on 10/3/20.
//

import UIKit
import MapKit

class AppSettings {
    
    static let shared = AppSettings()
    
    var currentLocation: CLLocation?
    var userLogin: UserLogin?
    var currentUser: UserInfomation?
    var discoverUser: UniversalUser?
    var isUseFirebase: Bool = false
    var menuItems: [MenuItem] {
        guard let user = currentUser else { return [.settings]}
        switch user.accountType {
        case .personal:
            return [.dashboard, .benifit,.feed, .profile, .search, .premier_circle_showcase, .mycirlce, .album, .personal_service, .circular_chat, .message, .settings]
        case .business:
            return [.dashboard, .benifit, .feed, .profile, .search, .premier_circle_showcase, .ourCircle, .album, .business_service, .circular_chat, .message, .settings]
        }
    }
    
    var showPurchaseView: Bool {
        //return true
        let expiredDate: Date? = DATE_HIDDEN_PAYWALL.toDate("yyyy-MM-dd", timezone: TimeZone(secondsFromGMT: 0))
        let currentDate = Date().toDateString("yyyy-MM-dd", timezone: nil)?.toDate("yyyy-MM-dd", timezone: TimeZone(secondsFromGMT: 0))

        guard let current = currentDate, let expired = expiredDate else {
            return false
        }

        if current.timeIntervalSince1970 < expired.timeIntervalSince1970 {
            return false
        }

        return true
    }
    
    var showPurchaseViewSpin2Win: Bool {
        return false
//        let expiredDate: Date? = "2033-05-04".toDate("yyyy-MM-dd", timezone: TimeZone(secondsFromGMT: 0))
//        let currentDate = Date().toDateString("yyyy-MM-dd", timezone: nil)?.toDate("yyyy-MM-dd", timezone: TimeZone(secondsFromGMT: 0))
//
//        guard let current = currentDate, let expired = expiredDate else {
//            return false
//        }
//
//        if current.timeIntervalSince1970 < expired.timeIntervalSince1970 {
//            return false
//        }
//
//        return true
    }
    
    var didUpdateToken: Bool = false
    var token: String?
    
    func updateToken(completion: (() -> Void)? = nil) {
        guard !UIDevice.current.isSimulator else { return }
        guard !didUpdateToken, let token = token, let userId = userLogin?.userId else { return }
        ManageAPI.shared.updateUserToken(token, userId: userId) {[weak self] error in
            guard let self = self else { return }
            if error == nil {
                print("Update Token for user \(userId) success: ", token)
                self.didUpdateToken = true
                completion?()
            } else {
                print("Update Token for user \(userId) failed: ", error?.msg as Any)
            }
        }
    }
    
    func deleteToken() {
        guard !UIDevice.current.isSimulator else { return }
        guard let userId = userLogin?.userId else { return }
        ManageAPI.shared.updateUserToken("", userId: userId) {[weak self] error in
            guard let self = self else { return }
            if error == nil {
                print("Delete Token for user \(userId) success")
                self.didUpdateToken = false
            } else {
                print("Delete Token for user \(userId) failed: ", error?.msg as Any)
            }
        }
    }
    
    func reset() {
        didUpdateToken = false
        userLogin = nil
        currentUser = nil
        discoverUser = nil
        deleteLoginInfo()
    }
    
    func updateNewPassword(_ password: String) {
        let standard = UserDefaults.standard
        standard.setValue(password, forKey: Constants.KEY_PASSWORD)
    }
    
    func saveLoginInfo(userId: String, username: String, password: String) {
        let standard = UserDefaults.standard
        standard.removeObject(forKey: Constants.SOCIAL_LOGIN)
        standard.setValue(userId, forKey: Constants.USER_ID)
        standard.setValue(username.isEmpty ? nil : username, forKey: Constants.KEY_USERNAME)
        standard.setValue(password.isEmpty ? nil : password, forKey: Constants.KEY_PASSWORD)
    }
    
    func saveSocialLogin(userId: String) {
        let standard = UserDefaults.standard
        standard.setValue(true, forKey: Constants.SOCIAL_LOGIN)
        standard.setValue(userId, forKey: Constants.USER_ID)
        standard.removeObject(forKey: Constants.KEY_USERNAME)
        standard.removeObject(forKey: Constants.KEY_PASSWORD)
    }
    
    func deleteLoginInfo() {
        let standard = UserDefaults.standard
        standard.removeObject(forKey: Constants.KEY_USERNAME)
        standard.removeObject(forKey: Constants.KEY_PASSWORD)
        standard.removeObject(forKey: Constants.SOCIAL_LOGIN)
        standard.removeObject(forKey: Constants.USER_ID)
    }
}
