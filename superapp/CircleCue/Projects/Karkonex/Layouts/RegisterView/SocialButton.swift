//
//  SocialButton.swift
//  Karkonex
//
//  Created by QTS Coder on 31/12/24.
//
import SwiftUI

struct SocialButton: View {
    let imageName: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(imageName)
                .resizable()
                .frame(width: 50, height: 50)
                .padding(10)
                .background(Color.white)
                .cornerRadius(10)
              //  .clipShape(Circle())
//                .overlay(
//                    Circle()
//                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
//                )
                .shadow(color: Color.gray.opacity(0.3), radius: 3, x: 0, y: 2)
        }
    }
}
