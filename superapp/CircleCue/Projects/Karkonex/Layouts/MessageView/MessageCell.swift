//
//  MessageCekk.swift
//  Karkonex
//
//  Created by QTS Coder on 28/10/24.
//

import SwiftUI
import SDWebImageSwiftUI
struct MessageCell: View {
    let message: NSDictionary
    var body: some View {
        VStack(alignment: .leading) {
            Spacer()
            HStack(spacing: 10, content: {
                WebImage(url: URL(string: message.object(forKey: "pic") as? String ?? "")) { image in
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
                .scaledToFill()
                .clipShape(Circle())
                .frame(width: 60, height: 60)
                
                VStack(alignment: .leading, spacing: 2, content: {
                    Text(message.object(forKey: "username") as? String ?? "")
                        .font(.custom(FONT_NAME.FUTURA_MEDIUM, size: 20.0)).multilineTextAlignment(.leading)
                        .foregroundColor(.black)
                    HStack(spacing: 2, content: {
                        Text(message.object(forKey: "msg") as? String ?? "").lineLimit(1)
                             .font(.custom(FONT_NAME.FUTURA_REGULAR, size: 16)).multilineTextAlignment(.leading)
                             .foregroundColor(.black)
                        Spacer()
                        if let readstatus = message.object(forKey: "readstatus") as? String, let intread = Int(readstatus), intread == 0{
                            Image("ic_received")
                                 .resizable()
                                .frame(width: 12.0, height: 12.0)
                                .scaledToFit()
                        }
                       
                    })
                    HStack{
                        Spacer()
                        Text( self.formatTimeAgo((message.object(forKey: "time") as? String ?? "")))
                             .font(.custom(FONT_NAME.FUTURA_REGULAR, size: 12)).multilineTextAlignment(.trailing)
                             .foregroundColor(.gray)
                    }
                   
                    Spacer()
                    
                })
            })
            Spacer()
            Divider()
        }
    }
    
    private func formatTimeAgo(_ strDate: String)-> String{
        let format = DateFormatter.init()
        format.dateFormat = "yyyy-MM-dd HH:mm:ss"
        format.timeZone = TimeZone(abbreviation: "EST")
        //format.locale = self.getPreferredLocale()
        if let dateS = format.date(from: strDate){
            print(dateS)
            return DateHelper.timeAgoTwoDate(dateS)
        }
        return ""
    }
}

#Preview {
    MessageCell(message: NSDictionary())
}
