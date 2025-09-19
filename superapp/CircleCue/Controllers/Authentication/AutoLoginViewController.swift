//
//  AutoLoginViewController.swift
//  CircleCue
//
//  Created by QTS Coder on 11/27/20.
//

import UIKit
import Alamofire

class AutoLoginViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkRememberLogin()
    }
    
    private func checkRememberLogin() {
        let standard = UserDefaults.standard
        if let social_login = standard.object(forKey: Constants.SOCIAL_LOGIN) as? Bool, social_login == true, let userId = standard.object(forKey: Constants.USER_ID) as? String {
            let user = UserLogin(userId: userId)
            AppSettings.shared.userLogin = user
            self.fetchSocialLoginUserInfo(userId: userId)
        } else if let username = standard.object(forKey: Constants.KEY_USERNAME) as? String, !username.trimmed.isEmpty, let password = standard.object(forKey: Constants.KEY_PASSWORD) as? String, !password.trimmed.isEmpty {
            performAutoLogin(username: username, password: password)
        } else if let userId = standard.object(forKey: Constants.USER_ID) as? String {
            let user = UserLogin(userId: userId)
            AppSettings.shared.userLogin = user
            fetchUserInfo(userId: userId, username: "", password: "")
        } else {
            let navigationController = BaseNavigationController(rootViewController: PremierCircleShowcaseController.instantiate())
            self.switchRootViewController(navigationController)
        }
    }
    
    private func performAutoLogin(username: String, password: String) {
        let para: Parameters = ["type": "1", "id": username, "password": password]
        ManageAPI.shared.login(para) {[weak self] (userID, error) in
            guard let self = self else { return }
            if let userID = userID {
                self.fetchUserInfo(userId: userID, username: username, password: password)
                return
            }
            let navigationController = BaseNavigationController()
            navigationController.viewControllers = [LoginVC.instantiate(from: StoryboardName.authentication.rawValue), RegisterViewController.instantiate(from: StoryboardName.authentication.rawValue)]
            self.switchRootViewController(navigationController)
        }
    }
    
    private func fetchUserInfo(userId: String, username: String, password: String) {
        ManageAPI.shared.fetchUserInfo(userId) {[weak self] (user, error) in
            guard let self = self else { return }
            DispatchQueue.main.async {
                if let user = user, user.is_verified {
                    ManageAPI.shared.updateUserLoginStatus(userId)
                    AppSettings.shared.currentUser = user
                    AppSettings.shared.saveLoginInfo(userId: userId, username: username, password: password)
                    self.switchRootViewController(BaseNavigationController(rootViewController: CircleFeedNewViewController.instantiate()))
                } else {
                    let navigationController = BaseNavigationController()
                    navigationController.viewControllers = [LoginVC.instantiate(from: StoryboardName.authentication.rawValue), RegisterViewController.instantiate(from: StoryboardName.authentication.rawValue)]
                    self.switchRootViewController(navigationController)
                }
            }
        }
    }
    
    private func fetchSocialLoginUserInfo(userId: String) {
        ManageAPI.shared.fetchUserInfo(userId) {[weak self] (user, error) in
            guard let self = self else { return }
            DispatchQueue.main.async {
                if let user = user, user.is_verified {
                    ManageAPI.shared.updateUserLoginStatus(userId)
                    AppSettings.shared.currentUser = user
                    AppSettings.shared.saveSocialLogin(userId: userId)
                    self.switchRootViewController(BaseNavigationController(rootViewController: CircleFeedNewViewController.instantiate()))
                } else {
                    let navigationController = BaseNavigationController()
                    navigationController.viewControllers = [LoginVC.instantiate(from: StoryboardName.authentication.rawValue), RegisterViewController.instantiate(from: StoryboardName.authentication.rawValue)]
                    self.switchRootViewController(navigationController)
                }
            }
        }
    }
}
