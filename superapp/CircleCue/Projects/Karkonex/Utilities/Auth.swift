//
//  Auth.swift
//  SwiftUIBlueprint
//
//  Created by Dino Trnka on 21. 4. 2022..
//

import Foundation
import SwiftKeychainWrapper

class AuthKaKonex: ObservableObject {
    
    static let shared: AuthKaKonex = AuthKaKonex()
    private let keychain: KeychainWrapper = KeychainWrapper.standard
    
    @Published var loggedIn: Bool = false
    
    private init() {
        loggedIn = hasAccessToken()
    }
    
    func getCredentials() -> Credentials {
        return Credentials(
            accessToken: keychain.string(forKey: KeychainKey.accessToken.rawValue),
            refreshToken: keychain.string(forKey: KeychainKey.refreshToken.rawValue),
            userId: keychain.string(forKey: KeychainKey.userId.rawValue)
        )
    }
    
    func setCredentials(accessToken: String, refreshToken: String, userId: String) {
        keychain.set(accessToken, forKey: KeychainKey.accessToken.rawValue)
        keychain.set(refreshToken, forKey: KeychainKey.refreshToken.rawValue)
        keychain.set(userId, forKey: KeychainKey.userId.rawValue)
        loggedIn = true
    }
    
    func hasAccessToken() -> Bool {
        print("USERID--->",getCredentials().userId)
        return getCredentials().userId != nil
    }
    func getUserId() -> String {
        return getCredentials().userId ?? ""
    }
    func getAccessToken() -> String? {
        return getCredentials().accessToken
    }

    func getRefreshToken() -> String? {
        return getCredentials().refreshToken
    }

    func logout() {
        KeychainWrapper.standard.removeObject(forKey: KeychainKey.accessToken.rawValue)
        KeychainWrapper.standard.removeObject(forKey: KeychainKey.refreshToken.rawValue)
        KeychainWrapper.standard.removeObject(forKey: KeychainKey.userId.rawValue)
        loggedIn = false
    }
    
    
    func hasPremium()-> Bool{
        let datePremium = DATE_HIDDEN_PAYWALL
        let format = DateFormatter.init()
        format.dateFormat = "yyyy-MM-dd"
        if let dateF = format.date(from: datePremium){
            if Date().timeIntervalSince1970 > dateF.timeIntervalSince1970{
                return true
            }
        }
        return false
    }
}
