//
//  LinkedInAuthenticationViewController.swift
//  CircleCue
//
//  Created by QTS Coder on 12/10/20.
//

import UIKit
import WebKit
import Alamofire

protocol LinkedInAuthenticationDelegate: AnyObject {
    func didFaileAuthentication(_ error: String?)
    func didAuthentication(_ fullName: String?)
}

extension LinkedInAuthenticationViewController {
    private struct LinkedInConstants {
        static let CLIENT_ID = "78j94wja6biapm"
        static let CLIENT_SECRET = "QeDAPLSbSZY3lfc9"
        static let REDIRECT_URI = "https://www.linkedin.com/company/circlecue/"
        static let SCOPE = "r_liteprofile"
        static let AUTHURL = "https://www.linkedin.com/oauth/v2/authorization"
        static let TOKENURL = "https://www.linkedin.com/oauth/v2/accessToken"
    }
}

class LinkedInAuthenticationViewController: UIViewController {
    
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    weak var delegate: LinkedInAuthenticationDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            self.isModalInPresentation = true
        }
        setupWebview()
    }
    
    private func setupWebview() {
        webView.navigationDelegate = self
        loadingIndicator.startAnimating()
        loadRequest()
    }
    
    private func loadRequest() {
        let state = "linkedin\(Int(Date().timeIntervalSince1970))"
        let authURLFull = LinkedInConstants.AUTHURL + "?response_type=code&client_id=" + LinkedInConstants.CLIENT_ID + "&scope=" + LinkedInConstants.SCOPE + "&state=" + state + "&redirect_uri=" + LinkedInConstants.REDIRECT_URI
        
        guard let url = URL.init(string: authURLFull) else { return }
        let urlRequest = URLRequest.init(url: url)
        webView.load(urlRequest)
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension LinkedInAuthenticationViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.loadingIndicator.stopAnimating()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        self.loadingIndicator.stopAnimating()
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let urlStr = navigationAction.request.url?.absoluteString, urlStr.contains("?code=") {
            requestForCallbackURL(request: navigationAction.request)
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }
    
    func requestForCallbackURL(request: URLRequest) {
        // Get the authorization code string after the '?code=' and before '&state='
        guard let requestURLString = request.url?.absoluteString, requestURLString.hasPrefix(LinkedInConstants.REDIRECT_URI), requestURLString.contains("?code="), let range = requestURLString.range(of: "=") else {
            return
        }
        
        let linkedinCode = requestURLString[range.upperBound...]
        
        guard let stateRange = linkedinCode.range(of: "&state=") else  {
            return
        }

        let linkedinCodeFinal = linkedinCode[..<stateRange.lowerBound]
        handleAuth(linkedInAuthorizationCode: String(linkedinCodeFinal))
    }
    
    func handleAuth(linkedInAuthorizationCode: String) {
        linkedinRequestForAccessToken(authCode: linkedInAuthorizationCode)
    }
    
    func linkedinRequestForAccessToken(authCode: String) {
        let para: Parameters = ["grant_type": "authorization_code", "code": authCode, "redirect_uri": LinkedInConstants.REDIRECT_URI, "client_id": LinkedInConstants.CLIENT_ID, "client_secret": LinkedInConstants.CLIENT_SECRET]
        
        let url = URL(string: LinkedInConstants.TOKENURL)!
        
        AF.request(url, method: .post, parameters: para).responseJSON { (response) in
            print(response)
            switch response.result {
            case .success(let value):
                guard let data = value as? NSDictionary, let access_token = data.value(forKey: "access_token") as? String else {
                    DispatchQueue.main.async {
                        self.dismiss(animated: true) {
                            self.delegate?.didFaileAuthentication(response.error?.localizedDescription)
                        }
                    }
                    return
                }
                
                self.fetchLinkedInUserProfile(accessToken: access_token)
            case .failure(let error):
                DispatchQueue.main.async {
                    self.dismiss(animated: true) {
                        self.delegate?.didFaileAuthentication(error.localizedDescription)
                    }
                }
            }
        }
    }
    
    func fetchLinkedInUserProfile(accessToken: String) {
        let para: Parameters = ["projection": "(id,firstName,lastName,profilePicture(displayImage~:playableStreams))",
                                "oauth2_access_token": accessToken]
        
        let url = URL.init(string: "https://api.linkedin.com/v2/me")!
        
        AF.request(url, parameters: para).responseDecodable(of: LinkedInProfileModel.self) { (response) in
            guard let profile = response.value else { return }
            
            //AccessToken
            print("LinkedIn Access Token: \(accessToken)")
            // LinkedIn Id
            print("LinkedIn Id: \(profile.id)")
            // LinkedIn First Name
            print("LinkedIn First Name: \(profile.firstName.localized.enUS)")
            // LinkedIn Last Name
            print("LinkedIn Last Name: \(profile.lastName.localized.enUS)")
            
            // LinkedIn Full Name
            print("LinkedIn Last Name: \(profile.fullname)")
            
            DispatchQueue.main.async {
                self.delegate?.didAuthentication(profile.fullname)
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
}

// MARK: - LinkedInProfileModel
struct LinkedInProfileModel: Codable {
    let firstName, lastName: StName
    let profilePicture: ProfilePicture
    let id: String
    
    var fullname: String {
        firstName.localized.enUS + lastName.localized.enUS
    }
}

// MARK: - StName
struct StName: Codable {
    let localized: Localized
}

// MARK: - Localized
struct Localized: Codable {
    let enUS: String
    
    enum CodingKeys: String, CodingKey {
        case enUS = "en_US"
    }
}

// MARK: - ProfilePicture
struct ProfilePicture: Codable {
    let displayImage: DisplayImage
    
    enum CodingKeys: String, CodingKey {
        case displayImage = "displayImage~"
    }
}

// MARK: - DisplayImage
struct DisplayImage: Codable {
    let elements: [ProfilePicElement]
}

// MARK: - Element
struct ProfilePicElement: Codable {
    let identifiers: [ProfilePicIdentifier]
}

// MARK: - Identifier
struct ProfilePicIdentifier: Codable {
    let identifier: String
}

// MARK: - LinkedInEmailModel
struct LinkedInEmailModel: Codable {
    let elements: [Element]
}

// MARK: - Element
struct Element: Codable {
    let elementHandle: Handle
    let handle: String
    
    enum CodingKeys: String, CodingKey {
        case elementHandle = "handle~"
        case handle
    }
}

// MARK: - Handle
struct Handle: Codable {
    let emailAddress: String
}
