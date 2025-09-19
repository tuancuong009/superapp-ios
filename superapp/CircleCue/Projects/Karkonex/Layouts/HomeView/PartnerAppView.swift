//
//  PartnerAppView.swift
//  Karkonex
//
//  Created by QTS Coder on 8/1/25.
//

import SwiftUI

struct PartnerAppView: View {
    @Environment(\.openURL) var openURL
    var body: some View {
        
        ScrollView {
                    VStack(spacing: 20) {
                        // Logo and Header
                        VStack(spacing: 10) {
                            Image("logo_big") // Replace with your actual logo image
                                .resizable()
                                .scaledToFit()
                                .frame(height: 100)
                            
                            Text("AppMonarchy delivers cutting-edge social technologies designed to elevate businesses across a diverse range of sectors listed below:")
                                .font(.custom(FONT_NAME.FUTURA_REGULAR, size: 15))
                                .multilineTextAlignment(.center)
                               // .padding(.horizontal)
                        }
                        
                        // Cards
                        VStack(spacing: 15) {
                            Button {
                                openURL(URL(string: "https://apps.apple.com/us/app/circlecue-1-social-media-app/id1500649857")!)
                            } label: {
                                AppCardView(
                                    icon: "logo_cc",
                                    title: "CIRCLECUE",
                                    description: "Social media networking.",
                                    color: .init(hex: "#25A8E0")
                                )
                            }

                           
                            Button {
                                openURL(URL(string: "https://apps.apple.com/us/app/circlecue-1-social-media-app/id6737510790")!)
                            } label: {
                                AppCardView(
                                    icon: "logo_kar",
                                    title: "KarKonnex",
                                    description: "Rent, buy, and sell cars.",
                                    color: .init(hex: "#1B1464")
                                )
                            }

                            Button {
                                openURL(URL(string: "https://apps.apple.com/us/app/circlecue-1-social-media-app/id6695737762")!)
                            } label: {
                                AppCardView(
                                    icon: "logo_mat",
                                    title: "Matcheron",
                                    description: "Dating, find the perfect match.",
                                    color: .init(hex: "#EF7380")
                                )
                            }
                            
                            Button {
                                openURL(URL(string: "https://apps.apple.com/us/app/circlecue-1-social-media-app/id6467609375")!)
                            } label: {
                                AppCardView(
                                    icon: "logo_roomrently",
                                    title: "ROOMRENTLY",
                                    description: "Rent, buy, and sell homes.",
                                    color: .init(hex: "#F7941D")
                                )
                            }
                            
                        }
                        Spacer()
                        .padding(.horizontal)
                    }
                    .padding(.leading, 20)
                    .padding(.trailing, 20)
                   
                }
        .background(Color.clear)
                .edgesIgnoringSafeArea(.bottom)
    }
}

struct AppCardView: View {
    var icon: String
    var title: String
    var description: String
    var color: Color
    
    var body: some View {
        HStack(spacing: 15) {
            
            
            VStack(alignment: .leading, spacing: 5) {
                Image(icon)
                   
                    .scaledToFit()
                Text(description)
                    .font(.custom(FONT_NAME.FUTURA_REGULAR, size: 18)).multilineTextAlignment(.trailing)
                    .foregroundColor(color)
            }
            
            Spacer()
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}
