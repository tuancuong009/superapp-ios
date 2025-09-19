//
//  ButtonStyles.swift
//  Routing


import Foundation
import SwiftUI

struct BlueButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(EdgeInsets(top: 15, leading: 5, bottom: 15, trailing: 5))
            .background(Color.init(hex: "#870B0B"))
            .foregroundColor(.white)
            .clipShape(Capsule())
            .font(.custom("futura", size: 18.0))
            .scaleEffect(configuration.isPressed ? 1.02 : 1.0)
    }
}

struct GrayButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(Color.gray)
            .foregroundColor(.white)
            .clipShape(Capsule())
            .scaleEffect(configuration.isPressed ? 1.1 : 1.0)
    }
}

struct ButtonNormal: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(EdgeInsets(top: 10, leading: 5, bottom: 10, trailing: 5))
            .background(Color.clear)
            .foregroundColor(.gray)
            .font(.custom("futura", size: 15.0))
            .scaleEffect(configuration.isPressed ? 1.02 : 1.0)
        
    }
}
struct ButtonSelectStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(EdgeInsets(top: 10, leading: 5, bottom: 10, trailing: 5))
            .foregroundColor(.white)
            .clipShape(Capsule())
            .font(.custom("futura", size: 16.0))
            .scaleEffect(configuration.isPressed ? 1.02 : 1.0)
            .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                )
    }
}

struct PikcerButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(EdgeInsets(top: 10, leading: 5, bottom: 10, trailing: 5))
            .background(Color.init(hex: "#870B0B"))
            .foregroundColor(.white)
            .clipShape(Capsule())
            .font(.custom("futura", size: 18.0))
            .scaleEffect(configuration.isPressed ? 1.02 : 1.0)
    }
}
struct EditButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(EdgeInsets(top: 10, leading: 5, bottom: 10, trailing: 5))
            .background(Color.init(hex: "#870B0B"))
            .foregroundColor(.white)
            .clipShape(Capsule())
            .font(.custom("futura", size: 18.0))
            .scaleEffect(configuration.isPressed ? 1.02 : 1.0)
    }
}
struct RedButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(EdgeInsets(top: 10, leading: 5, bottom: 10, trailing: 5))
            .background(Color.red)
            .foregroundColor(.white)
            .clipShape(Capsule())
            .font(.custom("futura", size: 18.0))
            .scaleEffect(configuration.isPressed ? 1.02 : 1.0)
    }
}


struct CustomSwiftUIButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(Color.init(hex: "#870B0B"))
            .foregroundColor(.white)
            .cornerRadius(5)
            .font(.custom("futura", size: 18.0))
            .scaleEffect(configuration.isPressed ? 1.02 : 1.0)
    }
}
struct LoginButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(Color.init(hex: "#1B1464"))
            .foregroundColor(.white)
            .cornerRadius(5)
            .font(.custom("futura", size: 18.0))
            .scaleEffect(configuration.isPressed ? 1.02 : 1.0)
    }
}
struct CustomBlueButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(Color.green)
            .foregroundColor(.white)
            .cornerRadius(5)
            .font(.custom("futura", size: 18.0))
            .scaleEffect(configuration.isPressed ? 1.02 : 1.0)
    }
}
