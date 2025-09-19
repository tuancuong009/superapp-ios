//
//  HomeModel.swift
//  Karkonex
//
//  Created by QTS Coder on 1/11/24.
//

import SwiftUI
import Alamofire
class HomeModel: ObservableObject {
    @Published var results: [NSDictionary] = []
    @Published var apiState: APIState = .loading
    
    //API
    func loadApi(isReload: Bool, complete:@escaping (_ success: Bool) ->Void){
        if !isReload{
            apiState = .loading
        }
        
        APIKarkonexHelper.shared.showcase(complete: { success, dict in
            
             if let dict = dict{
                 self.results = dict
                 self.apiState = .success
                 
             }
             else{
                 self.apiState = .failure
             }
             complete(true)
        })
    }
    
    func loadApiSearch(param: Parameters, complete:@escaping (_ success: Bool) ->Void){
        apiState = .loading
        APIKarkonexHelper.shared.search(param, complete: { success, dict in
            if let dict = dict{
                self.results = dict
                self.apiState = .success
                
            }
            else{
                self.apiState = .failure
            }
            complete(true)
        })
    }
    
}
