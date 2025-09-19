//
//  SellBuyView 2.swift
//  Karkonex
//
//  Created by QTS Coder on 17/6/25.
//


import SwiftUI

struct SellBuyViewHome: View {
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        VStack{
            headerNavi
            VStack(spacing: 20) {
                NavigationLink(destination: WebView(url: "https://karkonnex.com/rent.php?src=api")) {
                    Text("RENT")
                        .frame(maxWidth: .infinity, maxHeight: 50)
                        .padding(EdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5))
                        .background(Color.red)
                        .foregroundColor(.white)
                        .clipShape(Capsule())
                        .font(.custom("futura", size: 18.0))
                }
               
                NavigationLink(destination: WebView(url: "https://karkonnex.com/buy.php?src=api")) {
                    Text("BUY")
                        .frame(maxWidth: .infinity, maxHeight: 50)
                        .padding(EdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5))
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .clipShape(Capsule())
                        .font(.custom("futura", size: 18.0))
                }
                
                NavigationLink(destination: WebView(url: "https://karkonnex.com/login.php")) {
                    Text("SELL")
                        .frame(maxWidth: .infinity, maxHeight: 50)
                        .padding(EdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5))
                        .background(Color.orange)
                        .foregroundColor(.white)
                        .clipShape(Capsule())
                        .font(.custom("futura", size: 18.0))
                }
                
            }.padding()
            Spacer()
        }.navigationBarHidden(true)
    }
    
    var headerNavi: some View {
        VStack(spacing: 0) {
            HStack {
                Button {
                    self.presentationMode.wrappedValue.dismiss()
                } label: {
                    Image("btnback")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 24, height: 24)
                }
                
                Spacer()
                
            }
            .padding(.horizontal)
            .padding(.vertical, 10)
            
            Divider()
        }
        .overlay(
            Text("INQUIRY".uppercased())
                .font(.custom(FONT_NAME.FUTURA_REGULAR, size: SIZE_FONT_NAV))
                .foregroundColor(Color.init(hex: "#870B0B"))
        )
    }
}

