//
//  BaseViewController.swift
//  CircleCue
//
//  Created by QTS Coder on 10/3/20.
//

import UIKit
import SafariServices
import JGProgressHUD
import IQKeyboardManagerSwift
import Alamofire
import RappleProgressHUD
class BaseViewController: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    @IBOutlet weak var topBarMenuView: TopbarView! {
        didSet {
            topBarMenuView.delegate = self
        }
    }
    
    var safeAreaInsets: UIEdgeInsets {
        return UIApplication.shared.keyWindow?.safeAreaInsets ?? UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
    }
    
    private let simpleHUD: JGProgressHUD = {
        let hud = JGProgressHUD(style: .dark)
        hud.vibrancyEnabled = true
        hud.textLabel.font = UIFont.myriadProRegular(ofSize: 16)
        hud.detailTextLabel.font = UIFont.myriadProRegular(ofSize: 14)
        hud.shadow = JGProgressHUDShadow(color: .black, offset: .zero, radius: 5.0, opacity: 0.2)
        hud.contentInsets = UIEdgeInsets(top: 40, left: 40, bottom: 40, right: 40)
        return hud
    }()
    
    private let successHUD: JGProgressHUD = {
        let hud = JGProgressHUD(style: .dark)
        hud.vibrancyEnabled = true
        hud.textLabel.font = UIFont.myriadProRegular(ofSize: 16)
        hud.detailTextLabel.font = UIFont.myriadProRegular(ofSize: 14)
        hud.shadow = JGProgressHUDShadow(color: .black, offset: .zero, radius: 5.0, opacity: 0.2)
        hud.contentInsets = UIEdgeInsets(top: 40, left: 40, bottom: 40, right: 40)
        return hud
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func showWebViewContent(urlString: String) {
        if let url = URL.init(string: urlString.invalidURL()) {
            let sf = SFSafariViewController(url: url)
            self.present(sf, animated: true, completion: nil)
        }
    }
    
    func showOutsideAppWebContent(urlString: String) {
//        if let url = URL.init(string: urlString.invalidURL()) {
//            UIApplication.shared.open(url, options: [:], completionHandler: nil)
//        }
        showWebViewContent(urlString: urlString)
    }
    
    func makePhoneCall(_ urlString: String) {
        var trimString = urlString.trimmed.replacingOccurrences(of: " ", with: "")
        trimString = trimString.replacingOccurrences(of: "(", with: "")
        trimString = trimString.replacingOccurrences(of: ")", with: "")
        trimString = trimString.replacingOccurrences(of: "-", with: "")
        if let phoneCallURL = URL(string: trimString), UIApplication.shared.canOpenURL(phoneCallURL) {
            UIApplication.shared.open(phoneCallURL, options: [:], completionHandler: nil)
        }
    }
    
    func showSimpleHUD(text: String? = nil, fromView: UIView? = nil) {
        successHUD.dismiss()
        if let text = text {
            simpleHUD.textLabel.text = text
            simpleHUD.contentInsets = UIEdgeInsets(top: 20, left: 40, bottom: 20, right: 40)
        } else {
            simpleHUD.textLabel.text = nil
            simpleHUD.contentInsets = UIEdgeInsets(top: 40, left: 40, bottom: 40, right: 40)
        }
        
        if let fromView = fromView {
            simpleHUD.show(in: fromView)
        } else {
            simpleHUD.show(in: UIApplication.shared.keyWindow?.rootViewController?.view ?? self.view)
        }
    }
    
    func hideLoading(delay: TimeInterval = 0) {
        simpleHUD.dismiss(afterDelay: delay)
        successHUD.dismiss(afterDelay: delay)
    }
    
    func showSuccessHUD(text: String? = nil, dismisAfter: TimeInterval = 1.5) {
        simpleHUD.dismiss()
        if let text = text {
            successHUD.textLabel.textColor = .green
            successHUD.textLabel.text = text
            successHUD.contentInsets = UIEdgeInsets(top: 20, left: 40, bottom: 20, right: 40)
        } else {
            successHUD.textLabel.textColor = .clear
            successHUD.textLabel.text = nil
            successHUD.contentInsets = UIEdgeInsets(top: 40, left: 40, bottom: 40, right: 40)
        }
        successHUD.indicatorView = JGProgressHUDSuccessIndicatorView()
        successHUD.show(in: UIApplication.shared.keyWindow?.rootViewController?.view ?? self.view)
        
        successHUD.dismiss(afterDelay: dismisAfter)
    }
    
    func showErrorHUD(text: String? = nil, dismisAfter: TimeInterval = 1.5) {
        simpleHUD.dismiss()
        if let text = text {
            successHUD.textLabel.textColor = .red
            successHUD.textLabel.text = text
            successHUD.contentInsets = UIEdgeInsets(top: 20, left: 40, bottom: 20, right: 40)
        } else {
            successHUD.textLabel.textColor = .clear
            successHUD.textLabel.text = nil
            successHUD.contentInsets = UIEdgeInsets(top: 40, left: 40, bottom: 40, right: 40)
        }
        successHUD.indicatorView = JGProgressHUDErrorIndicatorView()
        successHUD.show(in: UIApplication.shared.keyWindow?.rootViewController?.view ?? self.view)
        
        successHUD.dismiss(afterDelay: dismisAfter)
    }
    func showBusy()
    {
        var attribute = RappleActivityIndicatorView.attribute(style: .apple, tintColor: .white, screenBG: .lightGray, progressBG: .black, progressBarBG: .orange, progreeBarFill: .red, thickness: 4)
        attribute[RappleIndicatorStyleKey] = RappleStyleCircle
        RappleActivityIndicatorView.startAnimatingWithLabel("", attributes: attribute)
        
    }
    
    func hideBusy()
    {
        RappleActivityIndicatorView.stopAnimation()
    }
    
    
    func switchRootViewController(_ viewcontroller: UIViewController) {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate, let window = appDelegate.window {
            window.rootViewController = viewcontroller
            UIView.transition(with: window, duration: 0.25, options: .transitionCrossDissolve, animations: nil, completion: nil)
        }
    }

    func randomString(of length: Int = 16) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        var s = ""
        for _ in 0 ..< length {
            s.append(letters.randomElement()!)
        }
        return s
    }
    
    func showSimplePhotoViewer(for view: UIView?, image: UIImage?) {
        let controller = CustomPhotoViewerController(referencedView: view, image: image)
        self.present(controller, animated: true, completion: nil)
    }
    
    func initHomePage() {
        if AppSettings.shared.userLogin?.needUpdateAvatar == true {
            self.navigationController?.pushViewController(UpdateAvatarViewController.instantiate(from: StoryboardName.authentication.rawValue), animated: true)
        } else {
            let homeVC = BaseNavigationController(rootViewController: CircleFeedNewViewController.instantiate())
            self.switchRootViewController(homeVC)
        }
    }
    
    func viewUserSocialProfile(with profile : HomeSocialItem) {
        guard let link = profile.link?.trimmed, !link.isEmpty else { return }
        if link.isValidSocialLink(host: profile.type.domain ?? "") {
            switch profile.type {
            case .tiktok:
                if let url = URL(string: link) {
                    let path = url.lastPathComponent
                    if path.hasPrefix("@") {
                        self.showOutsideAppWebContent(urlString: link)
                    } else {
                        let newPath = "@" + path
                        let newURL = url.absoluteString.replacingOccurrences(of: path, with: newPath)
                        self.showOutsideAppWebContent(urlString: newURL)
                    }
                } else {
                    self.showOutsideAppWebContent(urlString: link)
                }
            default:
                self.showOutsideAppWebContent(urlString: link)
            }
        } else {
            switch profile.type {
            case .whatsapp:
                self.makePhoneCall("tel://\(link)")
            case .tiktok:
                if link.hasPrefix("@") {
                    self.showOutsideAppWebContent(urlString: (profile.type.domain ?? "") + link)
                } else {
                    let newPath = "@" + link
                    self.showOutsideAppWebContent(urlString: (profile.type.domain ?? "") + newPath)
                }
            default:
                self.showOutsideAppWebContent(urlString: (profile.type.domain ?? "") + link)
            }
        }
    }
}

extension BaseViewController: CopyRightViewDelegate {
    func showInfomation(_ type: AppInfomation) {
        showWebViewContent(urlString: type.url)
    }
}

extension BaseViewController: TopbarViewDelegate {
    
    @objc func backAction() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func editProfile() {
        navigationController?.pushViewController(EditProfileViewController.instantiate(), animated: true)
    }
    
    @objc func addNote() {
        navigationController?.pushViewController(NewNoteViewController.instantiate(), animated: true)
    }
}
