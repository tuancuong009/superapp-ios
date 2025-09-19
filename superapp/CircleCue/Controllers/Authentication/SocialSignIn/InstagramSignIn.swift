//
//  InstagramSignIn.swift
//  CircleCue
//
//  Created by QTS Coder on 10/22/20.
//

import Foundation

extension RegisterViewController {
    
    func signInWithInstagram() {
        let controller = AuthenticationInstagramVC.instantiate(from: StoryboardName.authentication.rawValue)
        controller.delegate = self
        self.present(controller, animated: true, completion: nil)
    }
}

extension RegisterViewController: AuthenticationInstagramDelegate {
    func didReceivedUserInfo(userInfo: NSDictionary?) {
        guard let username = userInfo?.value(forKey: "username") as? String else { return }
        if let index = self.socialMedias.firstIndex(where: {$0.type == .instagram}) {
            self.socialMedias[index].username = username
            DispatchQueue.main.async {
                self.tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
            }
        }
    }
}

extension EditProfileViewController {
    func signInWithInstagram() {
        let controller = AuthenticationInstagramVC.instantiate(from: StoryboardName.authentication.rawValue)
        controller.delegate = self
        self.present(controller, animated: true, completion: nil)
    }
}

extension EditProfileViewController: AuthenticationInstagramDelegate {
    func didReceivedUserInfo(userInfo: NSDictionary?) {
        guard let username = userInfo?.value(forKey: "username") as? String else { return }
        DispatchQueue.main.async {
            runloop: for section in 0..<self.socialItems.count {
                let items = self.socialItems[section].socialItems
                for index in 0..<items.count {
                    if items[index].type == .instagram {
                        print(section, index)
                        self.socialItems[section].socialItems[index].link = username
                        break runloop
                    }
                }
            }
            self.tableView.reloadData()
        }
    }
}
