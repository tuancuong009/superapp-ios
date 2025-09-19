//
//  AddCarModel.swift
//  Karkonex
//
//  Created by QTS Coder on 28/10/24.
//

import SwiftUI
class AddCarModel: ObservableObject {
    @Published var id: String = ""
    @Published var make: String = ""
    @Published var model: String = ""
    @Published var year: String = ""
    @Published var rentDay: String = ""
    @Published var rentweek: String = ""
    @Published var rentMonth: String = ""
    @Published var location: String = ""
    @Published var city: String = ""
    @Published var zipCode: String = ""
    @Published var description: String = ""
    @Published var country:  NSDictionary =  NSDictionary.init()
    @Published var state:  NSDictionary =  NSDictionary.init()
    
    @Published var msgError: String = ""
    @Published var countries:  [NSDictionary] =  []
    @Published var states:  [NSDictionary] =  []
}
