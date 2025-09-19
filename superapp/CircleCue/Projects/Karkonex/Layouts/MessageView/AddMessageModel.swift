//
//  AddMessageModel.swift
//  Karkonex
//
//  Created by QTS Coder on 29/10/24.
//
import SwiftUI
import Alamofire

class AddMessageModel: ObservableObject {
    
    @Published var apiState: APIState = .loading

    
    //API
    func callApiAddMsg(_ param: Parameters, complete:@escaping (_ success: Bool) ->Void){
        apiState = .loading
        APIKarkonexHelper.shared.addMSG(param) { success, erro in
            self.apiState = .success
            complete(true)
        }
    }
    
    
    func callApiMsgMedia(_ image: UIImage?,_ param: Parameters, complete:@escaping (_ success: Bool) ->Void){
        apiState = .loading
        APIKarkonexHelper.shared.addMSGMedia(param, image, complete: { success, erro in
            self.apiState = .success
            complete(true)
        })
    }
    
}
class deleteMessageModel: ObservableObject {
    
    @Published var apiState: APIState = .loading
    @Published var error: String = ""
    //API
    func callApiAddMsg(_ id: String, complete:@escaping (_ success: Bool) ->Void){
        apiState = .loading
        APIKarkonexHelper.shared.deleteMessage(id, complete: { success, erro in
            if success!{
                self.apiState = .success
                self.error = ""
                complete(true)
            }
            else{
                self.apiState = .failure
                self.error = erro ?? ""
                complete(true)
            }
        })
    }
    
    
}
