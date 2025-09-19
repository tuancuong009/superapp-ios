//
//  TextFiledStyle.swift
//  Karkonex
//
//  Created by QTS Coder on 12/04/2024.
//

import SwiftUI

struct OvalTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(EdgeInsets(top: 15, leading: 10, bottom: 15, trailing: 10))
            .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                )
            .font(.custom("futura", size: 16.0))
            .background(.white)
    }
}
struct OvalPasswordTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(EdgeInsets(top: 15, leading: 10, bottom: 15, trailing: 10))
            
            .font(.custom("futura", size: 16.0))
            .background(.white)
    }
}
