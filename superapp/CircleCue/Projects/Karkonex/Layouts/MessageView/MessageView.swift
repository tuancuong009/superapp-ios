//
//  MessageView.swift
//  Karkonex
//
//  Created by QTS Coder on 28/10/24.
//

import SwiftUI

struct MessageView: View {
    @StateObject var messageModel = MessageModel()

    var body: some View {
        VStack{
            if messageModel.apiState == .loading{
                HStack{
                    ProgressView {
                        
                    }
                }
                Spacer()
            }
            else{
                if messageModel.messages.count == 0 {
                    NoDataView(message: "No messages")
                    Spacer()
                }
                else{
                    Collection(data: $messageModel.messages, cols: 1, spacing: 0) { message in
//                        NavigationLink(destination: ChatMessageView(profileID: message.value(forKey: "id2") as? String ?? "", profileName: message.value(forKey: "username") as? String ?? "")) {
//                            MessageCell(message: message)
//                                .frame(height: 80)
//                        }
//                        .isDetailLink(false)
//                        .buttonStyle(ButtonNormal())
                        
                        MessageCell(message: message)
                        .frame(height: 80)
                    }.padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
                        .scrollIndicators(ScrollIndicatorVisibility.hidden)
                    Spacer()
                }
               
               
            }
        }
        .onAppear {
            messageModel.loadAPI()
        }
       
    }
}

#Preview {
    MessageView()
}
