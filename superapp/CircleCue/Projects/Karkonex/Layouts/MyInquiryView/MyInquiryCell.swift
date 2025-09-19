//
//  MyInquiryCell.swift
//  Karkonex
//
//  Created by QTS Coder on 31/10/24.
//

import SwiftUI
import SDWebImageSwiftUI
struct MyInquiryCell: View {
    let carModel: CarObj
    let isReceived: Bool
    @State private var isAlert: Bool = false
    @State private var isCallApi: Bool = false
    var deleteSuccess: () -> Void
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(carModel.pid.uppercased())
                .font(.custom(FONT_NAME.FUTURA_REGULAR, size: 18))
                .padding(10)
                .frame(maxWidth: .infinity)
                .background(Color.init(hex: "#870B0B"))
                .foregroundColor(.white)
                
            Spacer(minLength: 0)
            WebImage(url: URL(string: carModel.img1)) { image in
                image.fitToAspectRatio(((UIScreen.main.bounds.size.width - 40)/2)/120)
            } placeholder: {
                Rectangle().foregroundColor(.gray)
            }
            // Supports options and context, like `.delayPlaceholder` to show placeholder only when error
            .onSuccess { image, data, cacheType in
                // Success
                // Note: Data exist only when queried from disk cache or network. Use `.queryMemoryData` if you really need data
            }
            .indicator(.activity) // Activity Indicator
            .transition(.fade(duration: 0.5))
            .frame(height: 120)
            .clipShape(RoundedRectangle(cornerRadius: 0))
            .foregroundColor(.gray)
            .overlay {
                HStack(alignment: .top, spacing: 0) {
                    Spacer()
                    Text("$\(carModel.rent)/Day")
                        .font(.custom(FONT_NAME.FUTURA_REGULAR, size: 15))
                        .padding(5)
                        .background(Color.green)
                        .foregroundColor(.white)
                    
                }
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
            }
                
            Spacer(minLength: 0)
            Text(carModel.city)
                .font(.custom(FONT_NAME.FUTURA_REGULAR, size: 20.0))
                .padding(10)
                .frame(maxWidth: .infinity)
                .background(Color.gray.opacity(0.2))
                .foregroundColor(.init(hex: "#1B1464"))
            Spacer(minLength: 0)
            if isReceived{
                HStack{
                    Text("From: " + carModel.username)
                        .font(.custom(FONT_NAME.FUTURA_REGULAR, size: 16))
                        .padding(10)
                        .multilineTextAlignment(.leading)
                        .background(Color.white)
                        .foregroundColor(.black)
                    Spacer()
                }
                Spacer(minLength: 0)
            }
            
            Button {
                isAlert.toggle()
            } label: {
                if isCallApi{
                    VStack{
                        ProgressView()
                    }   .padding(10)
                        .frame(maxWidth: .infinity)
                        .background(Color.red)
                        .foregroundColor(.white)
                }
                else{
                    Text("DELETE")
                        .font(.headline)
                        .padding(10)
                        .frame(maxWidth: .infinity)
                        .background(Color.red)
                        .foregroundColor(.white)
                }
                    
               
            }

        
            Spacer(minLength: 0)
        }
        .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.gray.opacity(0.4), lineWidth: 1)
            )
        .background(Color.white)
        .padding(.leading, 10)
        .alert(isPresented: $isAlert) {
            Alert(
                title: Text(APP_NAME),
                            message: Text("Do you want to delete?"),
                            primaryButton: .default(Text("Yes")) {
                                isCallApi = true
                                APIKarkonexHelper.shared.delete_inquiry(id: carModel.id) { success, error in
                                    isCallApi = false
                                    self.deleteSuccess()
                                }
                            },
                            secondaryButton: .default(Text("No")) {
                            }
                        )
        }
    }
}

