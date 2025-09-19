//
//  HomeCell.swift
//  Karkonex
//
//  Created by QTS Coder on 22/10/24.
//

import SwiftUI
import SDWebImageSwiftUI
struct HomeCell: View {
    let carModel: CarObj
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            if !carModel.created.isEmpty, let dateCreate = self.converCreateAt(carModel.created){
                if (dateCreate.timeIntervalSince1970 + DATETIMESHOWCAR) > Date().timeIntervalSince1970{
                    Text(carModel.pid.uppercased() + "🚙")
                        .font(.custom(FONT_NAME.FUTURA_REGULAR, size: 18))
                        .padding(10)
                        .frame(maxWidth: .infinity)
                        .background(Color.init(hex: "#870B0B"))
                        .foregroundColor(.white)
                }
                else{
                    Text(carModel.pid.uppercased())
                        .font(.custom(FONT_NAME.FUTURA_REGULAR, size: 18))
                        .padding(10)
                        .frame(maxWidth: .infinity)
                        .background(Color.init(hex: "#870B0B"))
                        .foregroundColor(.white)
                }
            }
            else{
                Text(carModel.pid.uppercased())
                    .font(.custom(FONT_NAME.FUTURA_REGULAR, size: 18))
                    .padding(10)
                    .frame(maxWidth: .infinity)
                    .background(Color.init(hex: "#870B0B"))
                    .foregroundColor(.white)
            }
                
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
                VStack{
                    HStack(alignment: .top, spacing: 0) {
                        Spacer()
                        Text(carModel.type ? "$\(carModel.rent)/Day" : "$\(carModel.rent)")
                            .font(.custom(FONT_NAME.FUTURA_REGULAR, size: 15))
                            .padding(5)
                            .background(Color.green)
                            .foregroundColor(.white)
                        
                    }
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
                }
               
                Spacer()
                HStack(alignment: .bottom, spacing: 0) {
                    
                    Text(carModel.type ? "For Rent" : "For Sale")
                        .font(.custom(FONT_NAME.FUTURA_REGULAR, size: 11))
                        .padding(5)
                        .background(Color.init(hex: "#870B0B"))
                        .foregroundColor(.white)
                        .cornerRadius(5)
                    Spacer()
                    
                }.padding(.leading, 5)
                    .padding(.bottom, 5)
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .bottomLeading)
                
               
            }
            Spacer(minLength: 0)
            Text(carModel.city)
                .font(.custom(FONT_NAME.FUTURA_REGULAR, size: 20.0))
                .padding(10)
                .frame(maxWidth: .infinity)
                .background(Color.gray.opacity(0.2))
                .foregroundColor(.init(hex: "#1B1464"))
            
            Spacer(minLength: 0)
            Text("VIEW")
                .font(.headline)
                .padding(10)
                .frame(maxWidth: .infinity)
                .background(Color.red)
                .foregroundColor(.white)
            Spacer(minLength: 0)
        }
        
        .background(Color.white)
        .padding(.leading, 10)
    }
    
    private func converCreateAt(_ date: String)-> Date?{
        //2024-10-11 01:14:27
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd HH:mm:ss"
        format.timeZone = TimeZone(abbreviation: "EST")
        return format.date(from: date)
        
    }
}
