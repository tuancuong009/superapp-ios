//
//  BlockModel.swift
//  Karkonex
//
//  Created by QTS Coder on 29/10/24.
//

import SwiftUI
import Alamofire
class BlockModel: ObservableObject {
    
    @Published var results: [NSDictionary] = []
    
    @Published var apiState: APIState = .loading

    
    //API
    func loadAPI(complete:@escaping (_ success: Bool) ->Void){
        apiState = .loading
        APIKarkonexHelper.shared.getListBlock(Auth.shared.getUserId()) { success, dict in
            if let dict = dict{
                self.results = dict
                self.apiState = .success
                
            }
            else{
                self.apiState = .failure
            }
            complete(true)
        }
    }
    
    func callAddBlock(_ param: Parameters, complete:@escaping (_ success: Bool) ->Void){
        APIKarkonexHelper.shared.addBlock(param) { success, erro in
            self.apiState = .success
            complete(true)
        }
    }
    
    func deleteBlock(_ id: String, complete:@escaping (_ success: Bool) ->Void){
        APIKarkonexHelper.shared.removeBlock(id) { success, erro in
            complete(true)
        }
    }
}
