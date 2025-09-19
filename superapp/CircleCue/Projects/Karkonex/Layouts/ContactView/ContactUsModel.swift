//
//  ContactUsModel.swift
//  Karkonex
//
//  Created by QTS Coder on 25/10/24.
//

import SwiftUI

class ContactUsModel: ObservableObject {

    @Published var fullName: String = ""
    @Published var phone: String = ""
    @Published var email: String = ""
    @Published var messages: String = ""
    @Published var msgError: String = ""
  
}
