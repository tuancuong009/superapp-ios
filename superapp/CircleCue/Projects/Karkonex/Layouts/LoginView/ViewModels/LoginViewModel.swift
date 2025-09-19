//
//  LoginViewModel.swift
//  SwiftUIBlueprint
//
//  Created by Dino Trnka on 19. 4. 2022..
//

import Foundation
import UIKit
class LoginViewModel: ObservableObject {

    @Published var email: String = ""
    @Published var password: String = ""
    @Published var msgError: String = ""
  
}


class RegisterViewModel: ObservableObject {
    @Published var isPrivateOwner: Bool = true
    @Published var isCompanyDealer: Bool = false
    @Published var isVisiblePhone: Bool = true
    @Published var isHiddenPhone: Bool = false
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var company: String = ""
    @Published var username: String = ""
    @Published var phone: String = ""
    @Published var address: String = ""
    @Published var city: String = ""
    @Published var zipCode: String = ""
    @Published var country:  NSDictionary =  NSDictionary.init()
    @Published var state:  NSDictionary =  NSDictionary.init()
    @Published var avatar: UIImage?
    @Published var msgError: String = ""
    @Published var countries:  [NSDictionary] =  []
    @Published var states:  [NSDictionary] =  []
}


class UserModel {
    var status: Bool = true
    var phone_status: Bool = false
    var email: String = ""
    var password: String = ""
    var firstName: String = ""
    var lastName: String = ""
    var company: String = ""
    var username: String = ""
    var phone: String = ""
    var address: String = ""
    var city: String = ""
    var zipCode: String = ""
    var country: String = ""
    var state: String = ""
    var id: String = ""
    var img: String = ""
    init(_ dict: NSDictionary) {
        self.status = (dict.object(forKey: "status") as? String ?? "0") == "1" ? true : false
        self.phone_status = (dict.object(forKey: "phone_status") as? String ?? "0") == "1" ? true : false
        self.email = dict.object(forKey: "email") as? String ?? ""
        self.password = dict.object(forKey: "password") as? String ?? ""
        self.firstName = dict.object(forKey: "fname") as? String ?? ""
        self.lastName = dict.object(forKey: "lname") as? String ?? ""
        self.company = dict.object(forKey: "company") as? String ?? ""
        self.username = dict.object(forKey: "username") as? String ?? ""
        self.phone = dict.object(forKey: "phone") as? String ?? ""
        self.address = dict.object(forKey: "address") as? String ?? ""
        self.city = dict.object(forKey: "city") as? String ?? ""
        self.id = dict.object(forKey: "id") as? String ?? ""
        self.img = dict.object(forKey: "img") as? String ?? ""
        self.country = dict.object(forKey: "country") as? String ?? ""
        self.state = dict.object(forKey: "state") as? String ?? ""
        self.zipCode = dict.object(forKey: "zip") as? String ?? ""
    }
}

