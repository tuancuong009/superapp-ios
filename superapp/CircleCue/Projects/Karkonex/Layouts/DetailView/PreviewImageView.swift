//
//  PreviewImageView.swift
//  Karkonex
//
//  Created by QTS Coder on 1/11/24.
//

import SwiftUI
import SDWebImageSwiftUI
struct PreviewImageView: View {
    @Environment(\.presentationMode) var presentationMode
    let carModel: CarObj
    var body: some View {
        VStack{
            header
            Spacer()
            ScrollView(.horizontal, showsIndicators: false){
              
                HStack(alignment: .center, content: {
                    if !carModel.img1.isEmpty{
                        WebImage(url: URL(string: carModel.img1)) { image in
                            image.resizable() // Control layout like SwiftUI.AsyncImage, you must use this modifier or the view will use the image bitmap size
                            
                        } placeholder: {
                            Rectangle().foregroundColor(.gray)
                        }
                        // Supports options and context, like `.delayPlaceholder` to show placeholder only when error
                        .onSuccess { image, data, cacheType in
                            // Success
                            // Note: Data exist only when queried from disk cache or network. Use `.queryMemoryData` if you really need data
                        }
                        .indicator(.activity) // Activity Indicator
                        .scaledToFit()
                        .transition(.fade(duration: 0.5))
                        .frame(width: UIScreen.main.bounds.size.width)
                        .clipShape(RoundedRectangle(cornerRadius: 0))
                        .foregroundColor(.gray)
                    }
                   
              
                    
                    if !carModel.img2.isEmpty{
                        WebImage(url: URL(string: carModel.img2)) { image in
                            image.resizable() // Control layout like SwiftUI.AsyncImage, you must use this modifier or the view will use the image bitmap size
                            
                        } placeholder: {
                            Rectangle().foregroundColor(.gray)
                        }
                        // Supports options and context, like `.delayPlaceholder` to show placeholder only when error
                        .onSuccess { image, data, cacheType in
                            // Success
                            // Note: Data exist only when queried from disk cache or network. Use `.queryMemoryData` if you really need data
                        }
                        .indicator(.activity) // Activity Indicator
                        .scaledToFit()
                        .transition(.fade(duration: 0.5))
                        .frame(width: UIScreen.main.bounds.size.width)
                        .clipShape(RoundedRectangle(cornerRadius: 0))
                        .foregroundColor(.gray)
                    }
                    if !carModel.img3.isEmpty{
                        WebImage(url: URL(string: carModel.img3)) { image in
                            image.resizable() // Control layout like SwiftUI.AsyncImage, you must use this modifier or the view will use the image bitmap size
                            
                        } placeholder: {
                            Rectangle().foregroundColor(.gray)
                        }
                        // Supports options and context, like `.delayPlaceholder` to show placeholder only when error
                        .onSuccess { image, data, cacheType in
                            // Success
                            // Note: Data exist only when queried from disk cache or network. Use `.queryMemoryData` if you really need data
                        }
                        .indicator(.activity) // Activity Indicator
                        .scaledToFit()
                        .transition(.fade(duration: 0.5))
                        .frame(width: UIScreen.main.bounds.size.width)
                        .clipShape(RoundedRectangle(cornerRadius: 0))
                        .foregroundColor(.gray)
                    }
                    if !carModel.img4.isEmpty{
                        WebImage(url: URL(string: carModel.img4)) { image in
                            image.resizable() // Control layout like SwiftUI.AsyncImage, you must use this modifier or the view will use the image bitmap size
                            
                        } placeholder: {
                            Rectangle().foregroundColor(.gray)
                        }
                        // Supports options and context, like `.delayPlaceholder` to show placeholder only when error
                        .onSuccess { image, data, cacheType in
                            // Success
                            // Note: Data exist only when queried from disk cache or network. Use `.queryMemoryData` if you really need data
                        }
                        .indicator(.activity) // Activity Indicator
                        .scaledToFit()
                        .transition(.fade(duration: 0.5))
                        .frame(width: UIScreen.main.bounds.size.width)
                        .clipShape(RoundedRectangle(cornerRadius: 0))
                        .foregroundColor(.gray)
                    }
                })
              
            }
            //.scrollTargetBehavior(.paging)
            Spacer()
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
            .navigationBarHidden(true)
    }
}

extension PreviewImageView {
    private var header: some View {
        VStack(spacing: 0) {
            HStack {
                
                Button {
                    withAnimation {
                        self.presentationMode.wrappedValue.dismiss()
                    }
                } label: {
                    Text("Close").font(.custom(FONT_NAME.FUTURA_REGULAR, size: 18)).lineLimit(1)
                        .foregroundColor(Color.white)
                }
                
                Spacer()
                
            }
            .padding(.horizontal)
            .padding(.vertical, 10)
        }
    }
}
