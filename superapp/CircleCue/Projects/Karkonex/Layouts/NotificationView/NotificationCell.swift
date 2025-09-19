//
//  NotificationCell.swift
//  Karkonex
//
//  Created by QTS Coder on 28/10/24.
//

import SwiftUI

struct NotificationCell: View {
    let message: NSDictionary
    var body: some View {
        VStack(alignment: .leading) {
           
            VStack(alignment: .leading, spacing: 2, content: {
                HStack(content: {
                    if let seen = message.object(forKey: "seen") as? String, let intseen = Int(seen), intseen == 0{
                        RedDotView()
                        Text(message.object(forKey: "description") as? String ?? "")
                             .font(.custom(FONT_NAME.FUTURA_MEDIUM, size: 16)).multilineTextAlignment(.leading)
                    }
                    else{
                        Text(message.object(forKey: "description") as? String ?? "")
                             .font(.custom(FONT_NAME.FUTURA_REGULAR, size: 16)).multilineTextAlignment(.leading)
                    }
                    
                })
                
                HStack{
                    Spacer()
                    Text(self.formatTimeAgo((message.object(forKey: "created") as? String ?? "")))
                         .font(.custom(FONT_NAME.FUTURA_REGULAR, size: 12)).multilineTextAlignment(.trailing)
                         .foregroundColor(.gray)
                }
               
                
            })
            Divider()
        }
        .padding(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0))
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
    NotificationCell(message: NSDictionary())
}
struct RedDotView: View {
    var body: some View {
        Circle()
            .fill(Color.red)        // Set the color to red
            .frame(width: 10, height: 10) // Set the size of the dot
    }
}
