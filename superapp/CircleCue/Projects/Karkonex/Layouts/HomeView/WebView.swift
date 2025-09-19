//
//  WebView.swift
//  Karkonex
//
//  Created by QTS Coder on 17/6/25.
//

import SwiftUI
struct WebView: View {
    let url: String
    @Environment(\.presentationMode) var presentationMode
    @State private var isLoading = true
    var body: some View {
        VStack{
            headerNavi
            ZStack {
                WebViewUIKit(urlString: url, isLoading: $isLoading)

               if isLoading {
                   ProgressView()
                       .progressViewStyle(CircularProgressViewStyle())
                       .scaleEffect(1.5)
               }
           }
           .edgesIgnoringSafeArea(.all)
            Spacer()
        }
        .navigationBarHidden(true)
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
            Image("logo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 125, height: 41)
        )
    }
}
