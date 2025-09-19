//
//  SignInWithTwitter.swift
//  CircleCue
//
//  Created by QTS Coder on 12/30/20.
//

import Foundation
import Swifter
import SafariServices

struct TwitterConstants {
    
    static let API_KEY = "KwBqHghnDEwyp5OHxSeaqideW"
    static let API_SECRET_KEY = "iiRP6vdyhcsLB0tpw3iFRsWVBP1VjWEZ9XRo057RUecG7cLbbj"
    static let CALLBACK_URL = "circlecueapp://"
}

extension RegisterViewController {
    func signInWithTwitter(_ completion: @escaping (_ username: String?) -> Void) {
        let swifter = Swifter(consumerKey: TwitterConstants.API_KEY, consumerSecret: TwitterConstants.API_SECRET_KEY)
        swifter.authorize(withCallback: URL(string: TwitterConstants.CALLBACK_URL)!, presentingFrom: self, success: { accessToken, _ in
            self.getUserProfile(swifter: swifter, completion)
        }, failure: { _ in
            print("ERROR: Trying to authorize")
            completion(nil)
        })
    }
    
    func getUserProfile(swifter: Swifter, _ completion: @escaping (_ username: String?) -> Void) {
        self.showSimpleHUD()
        swifter.verifyAccountCredentials(includeEntities: false, skipStatus: false, includeEmail: true, success: {[weak self] json in
            guard let self = self else { return completion(nil) }
            self.hideLoading()
            guard let twitterHandle = json["screen_name"].string else {
                return completion(nil)
            }
            
            print("Twitter Handle: \(twitterHandle)")
            completion(twitterHandle)
        }) { error in
            self.hideLoading()
            print("ERROR: \(error.localizedDescription)")
            completion(nil)
        }
    }
}

extension RegisterViewController: SFSafariViewControllerDelegate {}

extension EditProfileViewController {
    func signInWithTwitter(_ completion: @escaping (_ username: String?) -> Void) {
        let swifter = Swifter(consumerKey: TwitterConstants.API_KEY, consumerSecret: TwitterConstants.API_SECRET_KEY)
        swifter.authorize(withCallback: URL(string: TwitterConstants.CALLBACK_URL)!, presentingFrom: self, success: { accessToken, _ in
            self.getUserProfile(swifter: swifter, completion)
        }, failure: { _ in
            print("ERROR: Trying to authorize")
            completion(nil)
        })
    }
    
    func getUserProfile(swifter: Swifter, _ completion: @escaping (_ username: String?) -> Void) {
        self.showSimpleHUD()
        swifter.verifyAccountCredentials(includeEntities: false, skipStatus: false, includeEmail: true, success: {[weak self] json in
            guard let self = self else { return completion(nil) }
            self.hideLoading()
            guard let twitterHandle = json["screen_name"].string else {
                return completion(nil)
            }
            
            print("Twitter Handle: \(twitterHandle)")
            completion(twitterHandle)
        }) { error in
            self.hideLoading()
            print("ERROR: \(error.localizedDescription)")
            completion(nil)
        }
    }
}

extension EditProfileViewController: SFSafariViewControllerDelegate {}
