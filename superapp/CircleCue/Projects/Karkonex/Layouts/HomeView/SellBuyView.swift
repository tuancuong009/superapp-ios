//
//  SellBuyView.swift
//  SuperApp
//
//  Created by QTS Coder on 17/6/25.
//

import SwiftUI

struct SellBuyView: View {
    var body: some View {
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
    }
}

