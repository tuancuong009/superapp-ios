//
//  ReportView.swift
//  Karkonex
//
//  Created by QTS Coder on 29/10/24.
//

import SwiftUI

struct ReportView: View {
    @Environment(\.presentationMode) var presentationMode
    var clickReport: () -> Void
    var body: some View {
        VStack(spacing: 20) {
            header
            HStack{
                Button {
                   
                    self.presentationMode.wrappedValue.dismiss()
                    self.clickReport()
                } label: {
                    Text("Bullying, harassment or abuse")
                        .font(.custom(FONT_NAME.FUTURA_REGULAR, size: SIZE_FONT_LABEL))
                        .foregroundColor(Color.black)
                }
                Spacer()
            }
            HStack{
                Button {
                    self.presentationMode.wrappedValue.dismiss()
                    self.clickReport()
                } label: {
                    Text("Adult content")
                        .font(.custom(FONT_NAME.FUTURA_REGULAR, size: SIZE_FONT_LABEL))
                        .foregroundColor(Color.black)
                }
                Spacer()
            }
            HStack{
                Button {
                    self.presentationMode.wrappedValue.dismiss()
                    self.clickReport()
                } label: {
                    Text("Scam, fraud or false information")
                        .font(.custom(FONT_NAME.FUTURA_REGULAR, size: SIZE_FONT_LABEL))
                        .foregroundColor(Color.black)
                }
                Spacer()
            }
            Spacer()
           
           
            
        } .padding().onAppear {
            
        }
    }
}
extension ReportView {
    var header: some View {
        VStack(spacing: 0) {
            HStack {
                Spacer()
                Text("Report").font(.custom(FONT_NAME.FUTURA_REGULAR, size: 22))
                    .foregroundColor(Color.init(hex: "#870B0B"))
                Spacer()
                Button {
                    self.presentationMode.wrappedValue.dismiss()
                } label: {
                    Image("ic_close_tag")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 16, height: 16)
                }
                
                
            }
            .padding(.horizontal)
            .padding(.vertical, 10)
            
            Divider()
        }
    }
}
