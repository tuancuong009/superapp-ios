//
//  SearchModel.swift
//  Karkonex
//
//  Created by QTS Coder on 1/11/24.
//
import SwiftUI
class SearchModel: ObservableObject {
   
    @Published var city: String = ""
    @Published var zipCode: String = ""
    @Published var country:  NSDictionary =  NSDictionary.init()
    @Published var state:  NSDictionary =  NSDictionary.init()
    @Published var countries:  [NSDictionary] =  []
    @Published var states:  [NSDictionary] =  []
}
