//
//  SocialLoginView.swift
//  Karkonex
//
//  Created by QTS Coder on 31/12/24.
//

import SwiftUI
import AuthenticationServices
import CryptoKit
import Alamofire
struct SocialLoginView: View {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    let textNavi: String
    @State var appRouter: AppRouter
    let onSignInSuccess: () -> Void
    let onSignInFailure: (String) -> Void
    var body: some View {
        VStack(spacing: 20) {
            // Divider with text
            HStack {
                Divider().frame(height: 1).background(Color.red)
                Text(textNavi)
                    .font(.custom(FONT_NAME.FUTURA_REGULAR, size: SIZE_FONT_LABEL))
                    .foregroundColor(.gray)
                Divider().frame(height: 1).background(Color.gray)
            }
            .padding(.horizontal)

            // Social login buttons
            HStack(spacing: 20) {
                SocialButton(imageName: "login_gg", action: {
                    print("Google Login Tapped")
                    appDelegate.signInWithGoogle()
                })
                
                
                SocialButton(imageName: "login_fb", action: {
                    print("Facebook Login Tapped")
                        appDelegate.signInWithFacebook()
                })
                SocialButton(imageName: "login_apple", action: {
                    print("Apple Login Tapped")
                    appDelegate.performSignInWithApple()
                })
            }
        }
        .padding(10)
    }
    
}
