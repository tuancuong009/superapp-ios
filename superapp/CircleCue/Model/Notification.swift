//
//  Notification.swift
//  CircleCue
//
//  Created by QTS Coder on 14/06/2021.
//

import UIKit

class NotificationObject {
    var id: String = ""
    var title: String = ""
    var description: String = ""
    var seen: Bool = false
    var created: Date?
    
    init() {
    }
    
    init(dic: NSDictionary) {
        if let id = dic.value(forKey: "id") as? String {
            self.id = id
        }
        if let title = dic.value(forKey: "title") as? String {
            self.title = title
        }
        if let description = dic.value(forKey: "description") as? String {
            self.description = description
        }
        if let seen = dic.value(forKey: "seen") as? String {
            self.seen = seen.bool ?? false
        }
        if let created = dic.value(forKey: "created") as? String {
            self.created = created.toAPIDate()
        }
    }
}
