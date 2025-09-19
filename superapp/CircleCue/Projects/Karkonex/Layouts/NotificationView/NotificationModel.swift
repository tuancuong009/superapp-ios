//
//  NotificationModel.swift
//  Karkonex
//
//  Created by QTS Coder on 29/10/24.
//

import SwiftUI
import Combine
class NotificationModel: ObservableObject {
    
    @Published var messages: [NSDictionary] = []
    
    @Published var apiState: APIState = .loading

    
    //API
    func loadAPI() {
        APIKarkonexHelper.shared.getNotifications(Auth.shared.getUserId()) { success, dict in
            if let dict = dict{
                self.messages = dict
                self.apiState = .success
                
            }
            else{
                self.apiState = .failure
            }
        }
    }
    
    func readNotification(_ id: String){
        APIKarkonexHelper.shared.seenNotification(id) { success, erro in
            self.apiState = .success
        }
    }
}
