//
//  InquiryModel.swift
//  Karkonex
//
//  Created by QTS Coder on 29/10/24.
//

import SwiftUI
import Alamofire
class InquiryModel: ObservableObject {
    @Published var resultSents: [NSDictionary] = []
    @Published var resultReceivers: [NSDictionary] = []
    @Published var apiState: APIState = .loading
    @Published var apiStateReceiver: APIState = .loading
    
    //API
    func loadAPISent(complete:@escaping (_ success: Bool) ->Void){
        APIKarkonexHelper.shared.getInquirySent(AuthKaKonex.shared.getUserId()) { success, dict in
           
            if let dict = dict{
                self.resultSents = dict
                self.apiState = .success
                
            }
            else{
                self.apiState = .failure
            }
            complete(true)
        }
    }
    
    
    func loadAPIReceivers(complete:@escaping (_ success: Bool) ->Void){
        APIKarkonexHelper.shared.getInquiryRecieved(AuthKaKonex.shared.getUserId()) { success, dict in
            if let dict = dict{
              
                self.resultReceivers = dict
                self.apiStateReceiver = .success
                
            }
            else{
                self.apiStateReceiver = .failure
            }
            complete(true)
        }
    }
}

class CarObj{
    var pid = ""
    var id = ""
    var name = ""
    var uid = ""
    var sale_price = ""
    var offer_price = ""
    var address = ""
    var mobile = ""
    var email = ""
    var date = ""
    var date2 = ""
    var amount = ""
    var due = ""
    var city = ""
    var zip = ""
    var state = ""
    var country = ""
    var desc = ""
    var make = ""
    var model = ""
    var year = ""
    var username = ""
    var rent = ""
    var rentw = ""
    var rentm = ""
    var img1 = ""
    var img2 = ""
    var img3 = ""
    var img4 = ""
    var type =  false
    var created = ""
    init(dict: NSDictionary) {
        self.pid = dict.object(forKey: "pid") as? String ?? ""
        self.created = dict.object(forKey: "created") as? String ?? ""
        self.id = dict.object(forKey: "id") as? String ?? ""
        self.name = dict.object(forKey: "name") as? String ?? ""
        self.uid = dict.object(forKey: "uid") as? String ?? ""
        self.sale_price = dict.object(forKey: "sale_price") as? String ?? ""
        self.offer_price = dict.object(forKey: "offer_price") as? String ?? ""
        self.address = dict.object(forKey: "address") as? String ?? ""
        self.mobile = dict.object(forKey: "mobile") as? String ?? ""
        self.email = dict.object(forKey: "email") as? String ?? ""
        self.date = dict.object(forKey: "date") as? String ?? ""
        self.date2 = dict.object(forKey: "date2") as? String ?? ""
        self.amount = dict.object(forKey: "amount") as? String ?? ""
        self.due = dict.object(forKey: "due") as? String ?? ""
        self.city = dict.object(forKey: "city") as? String ?? ""
        self.state = dict.object(forKey: "state") as? String ?? ""
        self.country = dict.object(forKey: "country") as? String ?? ""
        self.desc = dict.object(forKey: "discription") as? String ?? ""
        self.model = dict.object(forKey: "modal") as? String ?? ""
        self.username = dict.object(forKey: "username") as? String ?? ""
        self.make = dict.object(forKey: "make") as? String ?? ""
        self.year = dict.object(forKey: "year") as? String ?? ""
        self.rent = dict.object(forKey: "rent") as? String ?? ""
        self.rentw = dict.object(forKey: "rentw") as? String ?? ""
        self.rentm = dict.object(forKey: "rentm") as? String ?? ""
        self.zip = dict.object(forKey: "zip") as? String ?? ""
        self.img1 = dict.object(forKey: "img1") as? String ?? ""
        self.img2 = dict.object(forKey: "img2") as? String ?? ""
        self.img3 = dict.object(forKey: "img3") as? String ?? ""
        self.img4 = dict.object(forKey: "img4") as? String ?? ""
        if  let type = dict.object(forKey: "type") as? String{
            if type == "0"{
                self.type = true
            }
            else{
                
                self.type = false
            }
            
        }
        else if  let type = dict.object(forKey: "type") as? Int{
            if type == 0{
                self.type = true
            }
            else{
                
                self.type = false
            }
        }
        
    }
}

