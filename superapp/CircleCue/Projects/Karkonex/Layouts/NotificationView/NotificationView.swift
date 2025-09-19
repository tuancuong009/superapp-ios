//
//  NotificationView.swift
//  Karkonex
//
//  Created by QTS Coder on 28/10/24.
//

import SwiftUI

struct NotificationView: View {
    @StateObject var notificationModel = NotificationModel()
    var body: some View {
        VStack{
            if notificationModel.apiState == .loading{
                HStack{
                    ProgressView {
                        
                    }
                }
                Spacer()
            }
            else{
                if notificationModel.messages.count == 0 {
                    NoDataView(message: "No notifications")
                    Spacer()
                }
                else{
                    Collection(data: $notificationModel.messages, cols: 1, spacing: 0) { notification in
                        NavigationLink(destination: ProfileView(profileId: notification.object(forKey: "sid") as? String ?? "", notificationID: notification.object(forKey: "id") as? String ?? "")) {
                            NotificationCell(message: notification).foregroundColor(.black)
                        }
                        
                    }.padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
                        .scrollIndicators(ScrollIndicatorVisibility.hidden)
                    Spacer()
                }
               
               
            }
        }
        .onAppear {
            notificationModel.loadAPI()
        }
       
    }
  
}

