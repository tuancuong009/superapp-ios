//
//  SignInWithLinkedIn.swift
//  CircleCue
//
//  Created by QTS Coder on 12/28/20.
//

import Foundation

extension RegisterViewController {
    func signInWithLinkedIn() {
        let controller = LinkedInAuthenticationViewController.instantiate(from: StoryboardName.authentication.rawValue)
        controller.delegate = self
        DispatchQueue.main.async {
            self.present(controller, animated: true, completion: nil)
        }
    }
}

extension RegisterViewController: LinkedInAuthenticationDelegate {
    func didFaileAuthentication(_ error: String?) {
        self.showAlert(title: "Opps!", message: error)
    }
    
    func didAuthentication(_ fullName: String?) {
        guard let username = fullName else { return }
        if let index = self.socialMedias.firstIndex(where: {$0.type == .linkedin}) {
            self.socialMedias[index].username = username
            DispatchQueue.main.async {
                self.tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
            }
        }
    }
    
}

extension EditProfileViewController {
    func signInWithLinkedIn() {
        let controller = LinkedInAuthenticationViewController.instantiate(from: StoryboardName.authentication.rawValue)
        controller.delegate = self
        DispatchQueue.main.async {
            self.present(controller, animated: true, completion: nil)
        }
    }
}

extension EditProfileViewController: LinkedInAuthenticationDelegate {
    func didFaileAuthentication(_ error: String?) {
        self.showAlert(title: "Opps!", message: error)
    }
    
    func didAuthentication(_ fullName: String?) {
        guard let username = fullName else { return }
        DispatchQueue.main.async {
            runloop: for section in 0..<self.socialItems.count {
                let items = self.socialItems[section].socialItems
                for index in 0..<items.count {
                    if items[index].type == .linkedin {
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

