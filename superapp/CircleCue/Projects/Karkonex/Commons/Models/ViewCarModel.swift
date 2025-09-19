//
//  ViewCarModel.swift
//  Karkonex
//
//  Created by QTS Coder on 30/10/24.
//

import Foundation
import SwiftUI
import Combine
class ViewCarModel: ObservableObject {
    
    @Published var carObj: CarObj = CarObj(dict: NSDictionary())
    @Published var mycars: [NSDictionary] = []
    @Published var apiState: APIState = .loading

    

    
    func loadApi(cardID: String, uid: String, complete:@escaping (_ success: Bool) ->Void){
        apiState = .loading
        APIKarkonexHelper.shared.viewCar(id: cardID, uid: uid) { success, dict in
            if let dict = dict{
                self.carObj = CarObj(dict: dict)
                self.apiState = .success
                
            }
            else{
                self.apiState = .failure
            }
            complete(true)
        }
    }
    
    
    func loadMyCars(isLoad: Bool) {
        if !isLoad{
            apiState = .loading
        }
        
        APIKarkonexHelper.shared.myCards { success, dict in
            if let dict = dict{
                self.mycars = dict
                self.apiState = .success
                
            }
            else{
                self.apiState = .failure
            }
        }
    }
    
}
