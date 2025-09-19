//
//  MyCarCell.swift
//  Karkonex
//
//  Created by QTS Coder on 28/10/24.
//

import SwiftUI
import SDWebImageSwiftUI
struct MyCarCell: View {
    let carObj: CarObj
    var changeData: () -> Void
    @State private var isAlert: Bool = false
    var body: some View {
        VStack(alignment: .leading) {
            HStack(spacing: 10, content: {
                WebImage(url: URL(string: carObj.img1)) { image in
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
                .transition(.fade(duration: 0.5)) // Fade Transition with duration
                .aspectRatio(contentMode: .fit)
                .frame(width: 80, height: 60)
                
                VStack(alignment: .leading, spacing: 2, content: {
                    Text(carObj.pid)
                        .font(.custom(FONT_NAME.FUTURA_REGULAR, size: 20.0)).multilineTextAlignment(.leading)
                    Text("Price: $\(carObj.rent)")
                         .font(.custom(FONT_NAME.FUTURA_REGULAR, size: 16)).multilineTextAlignment(.leading)
                    Text(carObj.address)
                         .font(.custom(FONT_NAME.FUTURA_REGULAR, size: 16)).multilineTextAlignment(.leading)
                    
                   
                    
                })
            })
            HStack {
                NavigationLink(destination: EditCarView(carModel: self.carObj, editSuccess: self.changeValue)) {
                    Text("Edit")
                         .font(.custom(FONT_NAME.FUTURA_REGULAR, size: 16)).multilineTextAlignment(.leading)
                         .foregroundColor(.white)
                         .frame(width: 80)
                }
                .isDetailLink(false)
                .buttonStyle(EditButton())
                Button(action: {
                    isAlert.toggle()
                }, label: {
                    Text("Delete")
                         .font(.custom(FONT_NAME.FUTURA_REGULAR, size: 16)).multilineTextAlignment(.leading)
                         .foregroundColor(.white)
                         .frame(width: 80)
                })
                .buttonStyle(RedButton())
            }
            
            Divider()
        }
        .padding(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0))
        .alert(isPresented: $isAlert) {
            Alert(
                title: Text(APP_NAME),
                            message: Text("Do you want to delete?"),
                            primaryButton: .destructive(Text("Yes")) {
                                APIKarkonexHelper.shared.deleteCar(id: carObj.id) { success, error in
                                    self.changeData()
                                }
                            },
                            secondaryButton: .default(Text("No")) {
                            }
                        )
        }
    }
    
    private func changeValue(){
        self.changeData()
    }
}

