//
//  Album.swift
//  CircleCue
//
//  Created by QTS Coder on 11/10/20.
//

import UIKit
import AVKit

struct Gallery {
    var id: String = ""
    var uid: String = ""
    var title: String = ""
    var date: String = ""
    var description: String = ""
    var pic: String = ""
    var likes: [PhotoLike]?
    var showOnFeed: Bool = true
    
    var player: AVPlayer?
    
    var albumType: MediaType {
        if pic.lowercased().contains(".mp4") {
            return .video
        }
        
        return .image
    }
    
    var timeInterval: TimeInterval {
        guard !date.isEmpty else {
            return 0
        }
        return date.toDate(.addNote)?.timeIntervalSince1970 ?? Date().timeIntervalSince1970
    }
    
    var year: Int {
        guard !date.isEmpty else {
            return Calendar.current.component(.year, from: Date())
        }
        return Calendar.current.component(.year, from: date.toDate(.addNote) ?? Date())
    }
    
    
    init(id: String) {
        self.id = id
    }
    
    init(dic: NSDictionary) {
        if let id = dic.value(forKey: "id") as? String {
            self.id = id
        }
        if let uid = dic.value(forKey: "uid") as? String {
            self.uid = uid
        }
        if let title = dic.value(forKey: "title") as? String {
            self.title = title
        }
        if let date = dic.value(forKey: "date") as? String {
            self.date = date
        }
        if let description = dic.value(forKey: "description") as? String {
            self.description = description.trimmed
        }
        if let showOnFeed = dic.value(forKey: "showOnFeed") as? Int {
            self.showOnFeed = showOnFeed.bool
        } else if let showOnFeed = dic.value(forKey: "showOnFeed") as? String {
            self.showOnFeed = showOnFeed.bool ?? true
        }
        if let pic = dic.value(forKey: "pic") as? String, !pic.isEmpty {
            if pic.hasPrefix("http") {
                self.pic = pic
            } else {
                self.pic = Constants.UPLOAD_URL + pic
            }
        }
    }
}
