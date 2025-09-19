//
//  MessageObj.swift
//  Matcheron
//
//  Created by QTS Coder on 2/10/24.
//

import Foundation
class MessageObj{
    var created_at = ""
    var id = ""
    var message = ""
    var readstatus: ReadMessageStatus = .sent
    var receiver_id = ""
    var sender_id = ""
    var media = ""
    var index = 0
    var sender: MessageSender {
        let userID = UserDefaults.standard.value(forKey: USER_ID) as? String ?? ""
        return sender_id == userID ? .me : .friend
    }
    init(_ dict: NSDictionary) {
        self.created_at = dict.object(forKey: "created_at") as? String ?? ""
        self.id = dict.object(forKey: "id") as? String ?? ""
        self.message = dict.object(forKey: "message") as? String ?? ""
        if let readstatus = dict.value(forKey: "readstatus") as? Int, let status = ReadMessageStatus(rawValue: "\(readstatus)") {
            print("readstatus--->",readstatus)
            switch sender {
            case .me:
                self.readstatus = status
            case .friend:
                self.readstatus = .read
            }
        }
        else if let readstatus = dict.value(forKey: "readstatus") as? String, let status = ReadMessageStatus(rawValue: readstatus) {
           
            switch sender {
            case .me:
                self.readstatus = status
                print("status===>",status.rawValue)
            case .friend:
                self.readstatus = status
            }
        }
        self.receiver_id = dict.object(forKey: "id2") as? String ?? ""
        self.sender_id = dict.object(forKey: "sender_id") as? String ?? ""
        self.media = dict.object(forKey: "media") as? String ?? ""
    }
}
