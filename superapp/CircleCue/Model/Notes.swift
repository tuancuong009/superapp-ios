//
//  Notes.swift
//  CircleCue
//
//  Created by QTS Coder on 10/30/20.
//

import Foundation

struct Note {
    var idd: String?
    var id: String?
    var title: String?
    var note: String?
    var img: String?
    var time: String?
    
    var isNoteImage: Bool {
        if let img = img, !img.isEmpty {
            return true
        }
        return false
    }
    
    init(dic: NSDictionary?) {
        guard let dic = dic else { return }
        if let idd = dic.value(forKey: "idd") as? String {
            self.idd = idd
        }
        if let id = dic.value(forKey: "id") as? String {
            self.id = id
        }
        if let title = dic.value(forKey: "title") as? String {
            self.title = title
        }
        if let note = dic.value(forKey: "note") as? String {
            self.note = note
        }
        if let img = dic.value(forKey: "img") as? String, !img.isEmpty, !img.lowercased().contains("undefined") {
            if img.hasPrefix("http") {
                self.img = img
            } else {
                self.img = Constants.UPLOAD_URL + img
            }
        }
        if let time = dic.value(forKey: "time") as? String {
            self.time = time.toDate(.noteAPI)?.toDateString(.noteDashboard) ?? time
        }
    }
}
