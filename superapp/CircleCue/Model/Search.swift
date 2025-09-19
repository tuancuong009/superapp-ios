//
//  Search.swift
//  CircleCue
//
//  Created by QTS Coder on 3/12/21.
//

import UIKit

struct SearchResume {
    var id: String = ""
    var username: String = ""
    var name: String = ""
    var email: String = ""
    var resume_title: String = ""
    var resume_text: String = ""
    var resume: String = ""
    
    var imageItem: Bool {
        return !resume.isEmpty
    }
    
    init(dic: NSDictionary) {
        if let id = dic.value(forKey: "id") as? String {
            self.id = id
        }
        if let username = dic.value(forKey: "username") as? String {
            self.username = username
        }
        if let name = dic.value(forKey: "name") as? String {
            self.name = name
        }
        if let email = dic.value(forKey: "email") as? String {
            self.email = email
        }
        if let resume_title = dic.value(forKey: "resume_title") as? String {
            self.resume_title = resume_title
        }
        if let resume_text = dic.value(forKey: "resume_text") as? String {
            self.resume_text = resume_text
        }
        if let resume = dic.value(forKey: "resume") as? String, !resume.isEmpty {
            if resume.hasPrefix("http") {
                var resumePath = resume.replacingOccurrences(of: Constants.UPLOAD_URL, with: "")
                resumePath = resume.replacingOccurrences(of: Constants.UPLOAD_URL_RETURN, with: "")
                if resumePath.isEmpty == false && resumePath.lowercased().contains("undefine") == false {
                    self.resume = resume
                }
            } else {
                self.resume = Constants.UPLOAD_URL + resume
            }
        }
    }
}

struct SearchJob {
    var id: String = ""
    var username: String = ""
    var email: String = ""
    var title: String = ""
    var content: String = ""
    var media: String = ""
    
    var imageItem: Bool {
        return !media.isEmpty
    }
    
    init(dic: NSDictionary) {
        if let id = dic.value(forKey: "id") as? String {
            self.id = id
        }
        if let username = dic.value(forKey: "username") as? String {
            self.username = username
        }
        if let email = dic.value(forKey: "email") as? String {
            self.email = email
        }
        if let title = dic.value(forKey: "title") as? String {
            self.title = title
        }
        if let content = dic.value(forKey: "content") as? String {
            self.content = content
        }
        if let media = dic.value(forKey: "media") as? String, !media.isEmpty {
            if media.hasPrefix("http") {
                let mediaPath = media.replacingOccurrences(of: Constants.UPLOAD_URL, with: "")
                if mediaPath.isEmpty == false && mediaPath.lowercased().contains("undefine") == false {
                    self.media = media
                }
            } else {
                self.media = Constants.UPLOAD_URL + media
            }
        }
    }
}

