//
//  JobOffer.swift
//  CircleCue
//
//  Created by QTS Coder on 11/10/20.
//

import Foundation

struct JobOffer {
    var id: Int = 0
    var title: String = ""
    var content: String = ""
    var time: String = ""
    var lastUpdate: Date = Date()
}

struct Blog_Job {
    var id: Int = 0
    var title: String = ""
    var content: String = ""
    var date: String = ""
    var u_id: String = ""
    var media: String = ""
    var originMediaPath: String = ""
    var username: String = ""
    
    var imageItem: Bool {
        return !media.isEmpty
    }
    
    init(searchItem: SearchJob) {
        self.title = searchItem.title
        self.content = searchItem.content
        self.media = searchItem.media
        self.date = searchItem.username
    }
    
    init(dic: NSDictionary) {
        if let id = dic.value(forKey: "id") as? String, let idInt = id.int {
            self.id = idInt
        }
        if let title = dic.value(forKey: "title") as? String {
            self.title = title
        }
        if let content = dic.value(forKey: "content") as? String {
            self.content = content
        }
        if let date = dic.value(forKey: "date") as? String {
            self.date = date.toDate(.addNote)?.toDateString(.noteDashboard) ?? date
        }
        if let u_id = dic.value(forKey: "u_id") as? String {
            self.u_id = u_id
        }
        if let username = dic.value(forKey: "username") as? String {
            self.username = username
        }
        if let media = dic.value(forKey: "media") as? String, !media.isEmpty {
            self.originMediaPath = media
            if media.hasPrefix("http") {
                self.media = media
            } else {
                self.media = Constants.UPLOAD_URL + media
            }
        }
    }
}
