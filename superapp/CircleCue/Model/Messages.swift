//
//  Messages.swift
//  CircleCue
//
//  Created by QTS Coder on 11/5/20.
//

import Foundation
import AVFoundation

class UserMessage {
    var username: String = ""
    var pic: String = ""
    var readstatus: String? = nil
    var messages: [Message] = []
    
    init(dic: NSDictionary) {
        if let username = dic.value(forKey: "username") as? String {
            self.username = username
        }
        if let pic = dic.value(forKey: "pic") as? String, !pic.isEmpty {
            self.pic = pic
        }
        if let readstatus = dic.value(forKey: "readstatus") as? String {
            self.readstatus = readstatus
        }
        if let data = dic.value(forKey: "Data") as? [NSDictionary] {
            self.messages = data.compactMap({Message.init(dic: $0)})
        }
    }
}

enum ReadMessageStatus: String {
    case sent = "1"
    case received = "3"
    case read = "0"
}

enum MessageType {
    case text
    case image
    case video
    case imageWithText
    case videoWithText
    case datingRequest
}

class Message {
    var id: String = ""
    var sender_id: String = ""
    var receiver_id: String = ""
    var message: String = ""
    var media: String = ""
    var type: String?
    var messageType: MessageType = MessageType.text
    var created_at: Date?
    var block: Int = 0
    var readstatus: ReadMessageStatus = .sent
    
    var player: AVPlayer?
    
    var mediaUrl: String {
        if media.isEmpty || media.hasPrefix("http") {
            return media
        } else {
            return Constants.UPLOAD_URL + media
        }
    }
    
    var sender: MessageSender {
        return sender_id == AppSettings.shared.userLogin?.userId ? .me : .friend
    }
    
    init(dic: NSDictionary) {
        if let id = dic.value(forKey: "id") as? String {
            self.id = id
        }
        if let sender_id = dic.value(forKey: "sender_id") as? String {
            self.sender_id = sender_id
        }
        if let receiver_id = dic.value(forKey: "receiver_id") as? String {
            self.receiver_id = receiver_id
        }
        if let message = dic.value(forKey: "message") as? String {
            self.message = message.trimmed.removingPercentEncoding ?? message.trimmed
        }
        if let media = dic.value(forKey: "media") as? String {
            self.media = media
        }
        
        if let type = dic.value(forKey: "type") as? String {
            if message.lowercased().contains(Constants.DATING_CIRCLE_REQUEST_MESSSAGE.lowercased()) ||
                message.lowercased().contains(Constants.TRAVEL_CIRCLE_REQUEST_MESSSAGE.lowercased()) ||
                message.lowercased().contains(Constants.DINEOUT_CIRCLE_REQUEST_MESSSAGE.lowercased()) {
                self.messageType = .datingRequest
            } else {
                self.type = type
                switch type.lowercased() {
                case "jpg", "png", "jpeg":
                    if message.isEmpty {
                        self.messageType = .image
                    } else {
                        self.messageType = .imageWithText
                    }
                case "mp4":
                    if message.isEmpty {
                        self.messageType = .video
                    } else {
                        self.messageType = .videoWithText
                    }
                default:
                    self.messageType = .text
                }
            }
        } else {
            if message.lowercased().contains(Constants.DATING_CIRCLE_REQUEST_MESSSAGE.lowercased()) ||
                message.lowercased().contains(Constants.TRAVEL_CIRCLE_REQUEST_MESSSAGE.lowercased()) ||
                message.lowercased().contains(Constants.DINEOUT_CIRCLE_REQUEST_MESSSAGE.lowercased()) {
                self.messageType = .datingRequest
            } else {
                self.messageType = .text
            }
        }
        if let created_at = dic.value(forKey: "created_at") as? String {
            self.created_at = created_at.toAPIDate()
        }
        
        if let block = dic.value(forKey: "block") as? Int {
            self.block = block
        }
        if let readstatus = dic.value(forKey: "readstatus") as? String, let status = ReadMessageStatus(rawValue: readstatus) {
            switch sender {
            case .me:
                self.readstatus = status
            case .friend:
                self.readstatus = .read
            }
        }
    }
    
    init(message: String) {
        self.message = message
    }
}

struct MessageDashboard {
    var value: String = ""
    var id: String = ""
    var id1: String = ""
    var id2: String = ""
    var sender_id: String = ""
    var username: String = " "
    var country: String = ""
    var pic: String = ""
    var msg: String = ""
    var time: String = ""
    var readstatus: ReadMessageStatus = .sent
    var isbusiness: Bool = false
    var paid = false
    init(dic: NSDictionary) {
        if let value = dic.value(forKey: "value") as? String {
            self.value = value
        }
        if let id = dic.value(forKey: "id") as? String {
            self.id = id
        }
        if let id1 = dic.value(forKey: "id1") as? String {
            self.id1 = id1
        }
        if let id2 = dic.value(forKey: "id2") as? String {
            self.id2 = id2
        }
        if let sender_id = dic.value(forKey: "sender_id") as? String {
            self.sender_id = sender_id
        }
        if let username = dic.value(forKey: "username") as? String {
            self.username = username
        }
        else if let name = dic.value(forKey: "name") as? String {
            self.username = name
        }
        if let isbusiness = dic.value(forKey: "isbusiness") as? String {
            self.isbusiness = isbusiness.bool ?? false
        }
        if let paid = dic.value(forKey: "paid") as? String {
            self.paid = paid.bool ?? false
        }
        else if let paid = dic.value(forKey: "paid") as? Bool {
           
                self.paid = paid
        }
        else if let paid = dic.value(forKey: "paid") as? Int {
           
            self.paid = (paid == 0 ? false : true)
        }
        if let country = dic.value(forKey: "country") as? String {
            self.country = country
        }
        if let pic = dic.value(forKey: "pic") as? String, !pic.isEmpty {
            if pic.hasPrefix("http") {
                self.pic = pic
            } else {
                self.pic = Constants.UPLOAD_URL + pic
            }
        }
        if let msg = dic.value(forKey: "msg") as? String {
            self.msg = msg.trimmed.removingPercentEncoding ?? msg.trimmed
        }
        if let time = dic.value(forKey: "time") as? String {
            self.time = time.toAPIDate(format: .messageAPI)?.toDateString(.messageDashboard) ?? time
        }
        if let readstatus = dic.value(forKey: "readstatus") as? String, let status = ReadMessageStatus(rawValue: readstatus) {
            self.readstatus = status
        }
    }
}

struct CircularMessage {
    var id: String = ""
    var msg: String = ""
    var created: Date?
    
    init(dic: NSDictionary) {
        if let id = dic.value(forKey: "id") as? String {
            self.id = id
        }
        if let msg = dic.value(forKey: "msg") as? String {
            self.msg = msg.trimmed.removingPercentEncoding ?? msg.trimmed
        }
        if let created = dic.value(forKey: "created") as? String {
            self.created = created.toAPIDate()
        }
    }
    
    init(message: String) {
        self.msg = message
        self.created = Date()
    }
}
