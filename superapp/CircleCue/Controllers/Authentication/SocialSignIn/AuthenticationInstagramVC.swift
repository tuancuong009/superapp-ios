//
//  AuthenticationInstagramVC.swift
//  HammockLife
//
//  Created by QTS Coder on 12/26/19.
//  Copyright © 2019 QTS Coder. All rights reserved.
//

import UIKit
import WebKit
import Alamofire

protocol AuthenticationInstagramDelegate: AnyObject {
    func didReceivedUserInfo(userInfo: NSDictionary?)
}

class AuthenticationInstagramVC: BaseViewController {
    
    @IBOutlet weak var webview: WKWebView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    weak var delegate: AuthenticationInstagramDelegate?
    
    private let INSTAGRAM_APP_ID = "389936048880285"
    private let INSTAGRAM_APP_SECRECT = "d9ca69058972213ad127d6edf2d1b000"
    private let INSTAGRAM_REDIRECT = "https://circlecue.com/"
    private let INSTAGRAM_SCOPE = "user_profile,user_media"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            self.isModalInPresentation = true
        }
        webview.navigationDelegate = self
        loadRequest()
    }
    
    private func loadRequest() {
        if let url = URL.init(string: "https://api.instagram.com/oauth/authorize?app_id=\(INSTAGRAM_APP_ID)&redirect_uri=\(INSTAGRAM_REDIRECT)&scope=\(INSTAGRAM_SCOPE)&response_type=code") {
            let request = URLRequest.init(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 30)
            webview.load(request)
        }
    }
    
    @IBAction func backAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func checkRequestForCallbackURL(request: URLRequest) {
        let requestURLString = (request.url?.absoluteString)! as String
        
        if requestURLString.hasPrefix(INSTAGRAM_REDIRECT) {
            if let range: Range<String.Index> = requestURLString.range(of: "code=") {
                let code = requestURLString.suffix(from: range.upperBound).replacingOccurrences(of: "#_", with: "")
                handleAuth(code: code)
            }
        }
    }
    
    func handleAuth(code: String)  {
        print("Instagram authentication code ==", code)
        getToken(code) { (token) in
            if let token = token {
                self.getUserInfo(token) { (result) in
                    self.delegate?.didReceivedUserInfo(userInfo: result)
                    self.dismiss(animated: true, completion: nil)
                }
            } else {
                self.delegate?.didReceivedUserInfo(userInfo: nil)
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    private func getToken(_ code: String, completion: @escaping (_ token: String?)->()) {
        let url = URL.init(string: "https://api.instagram.com/oauth/access_token")!
        let parameter: Parameters = ["client_id": INSTAGRAM_APP_ID, "app_secret": INSTAGRAM_APP_SECRECT, "grant_type": "authorization_code", "redirect_uri": INSTAGRAM_REDIRECT, "code": code]
        print(parameter)
        AF.request(url, method: .post, parameters: parameter).responseJSON { (response) in
            print(response)
            switch response.result {
            case .success(let value):
                guard let dic = value as? NSDictionary, let token = dic.value(forKey: "access_token") as? String else {
                    return completion(nil)
                }
                
                completion(token)
            case .failure(_):
                completion(nil)
            }
        }
    }
    
    private func getUserInfo(_ token: String, completion: @escaping (_ user: NSDictionary?)->()) {
        let url = URL.init(string: "https://graph.instagram.com/me")!
        let parameter: Parameters = ["fields":"id,username", "access_token": "\(token)"]
        AF.request(url, method: .get, parameters: parameter).responseJSON { (response) in
            print(response)
            switch response.result {
            case .success(let value):
                completion(value as? NSDictionary)
            case .failure(_):
                completion(nil)
            }
        }
    }
    
    private func deleteCookie() {
        if let cookies = HTTPCookieStorage.shared.cookies {
            for cookie in cookies {
                print("cookie.domain =", cookie.domain)
                if cookie.domain.contains(".instagram.com") {
                    HTTPCookieStorage.shared.deleteCookie(cookie)
                }
            }
        }
    }
}

extension AuthenticationInstagramVC: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        print(navigationAction.request)
        if navigationAction.request.url?.absoluteString.hasPrefix(INSTAGRAM_REDIRECT) == true {
            checkRequestForCallbackURL(request: navigationAction.request)
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        loadingIndicator.stopAnimating()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        loadingIndicator.stopAnimating()
    }
}
