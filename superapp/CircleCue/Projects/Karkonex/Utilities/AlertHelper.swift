//
//  AlertHelper.swift
//  Karkonex
//
//  Created by QTS Coder on 12/04/2024.
//

import SwiftUI

class AlertHelper: ObservableObject {
    static let shared: AlertHelper = AlertHelper()
    func showAlertMessage(_ message: String)-> Alert{
        Alert(title: Text(APP_NAME), message: Text(message), dismissButton: .cancel(Text("OK"), action: {
            
        }))
    }
    
    
}
