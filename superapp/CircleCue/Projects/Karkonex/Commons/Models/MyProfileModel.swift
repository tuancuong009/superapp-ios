//
//  MyProfileModel.swift
//  Karkonex
//
//  Created by QTS Coder on 25/10/24.
//

import Foundation
import SwiftUI
import Combine
class MyProfileModel: ObservableObject {
    
    @Published var user: UserModel = UserModel.init(NSDictionary.init() )
    
    @Published var apiState: APIState = .loading

    
    //API
    func loadAPI() {
        //apiState = .loading
        APIKarkonexHelper.shared.myprofile(id: Auth.shared.getUserId()) { success, dict in
            if let dict = dict{
                self.user = UserModel.init(dict)
                self.apiState = .success
                
            }
            else{
                self.apiState = .failure
            }
        }
    }
    
    func loadAPIByUserId(userId: String) {
        apiState = .loading
        APIKarkonexHelper.shared.myprofile(id: userId) { success, dict in
            if let dict = dict{
                self.user = UserModel.init(dict)
                self.apiState = .success
                
            }
            else{
                self.apiState = .failure
            }
        }
    }
    
    func apiDeleteAccount( complete:@escaping (_ success: Bool, _ error: String?) ->Void){
        APIKarkonexHelper.shared.deleteProfile { success, erro in
            if success!{
                self.apiState = .success
                complete(true, nil)
            }
            else{
                self.apiState = .failure
                complete(false, erro)
            }
            
        }
    }
}
