//
//  FullMessageModel.swift
//  Karkonex
//
//  Created by QTS Coder on 29/10/24.
//

import SwiftUI

class FullMessageModel: ObservableObject {
    
    @Published var messages: [MessageObj] = []
    
    @Published var apiState: APIState = .loading

    
    //API
    func loadAPI(_ profileId: String) {
        var arrs = [MessageObj]()
        APIKarkonexHelper.shared.getMessageChatByUser(profileId, complete: { success, dict in
            arrs.removeAll()
            if let dict = dict{
                var postion = 0
                for item in dict.reversed(){
                    let obj = MessageObj.init(item)
                    obj.index = postion
                    arrs.append(obj)
                    postion = postion + 1
                }
                self.messages = arrs
                self.apiState = .success
                
            }
            else{
                self.apiState = .failure
            }
        })
    }
}

