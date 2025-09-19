//
//  MessageMeView.swift
//  Karkonex
//
//  Created by QTS Coder on 29/10/24.
//

import SwiftUI
struct MessageMeView: View {
    @StateObject var addMessageModel = AddMessageModel()
    @Environment(\.presentationMode) var presentationMode
    let  profileId: String
    let profileName: String
    @FocusState private var amountIsFocused: Bool
    @State private var isLoading = false
    @State private var isAlert = false
    @State private var msgError:String  = ""
    @State private var message: String = ""
    var body: some View {
        ActivityIndicatorView(isDisplayed: .constant(isLoading)) {
            VStack {
                header
                
                Spacer()
                Text("Are you sure to send Message to \(profileName)?").font(.custom(FONT_NAME.FUTURA_REGULAR, size: 16))
                    .foregroundColor(Color.black).padding(EdgeInsets(top: 10, leading: 10, bottom: 0, trailing: 10)).lineLimit(1).minimumScaleFactor(0.6)
                VStack(alignment: .leading, spacing: 5){
                    Text("Messages")
                        .font(.custom(FONT_NAME.FUTURA_REGULAR, size: SIZE_FONT_LABEL))
                        .foregroundColor(Color.black)
                    TextField("Messages", text: $message, axis: .vertical)
                        .textFieldStyle(OvalTextFieldStyle())
                        .keyboardType(.default)
                        .submitLabel(.next)
                        .onSubmit {
                            print("Next")
                        }.focused($amountIsFocused)
                        .textInputAutocapitalization(.words)
                        .lineLimit(5...10)
                       
                }
                .padding()
                Button (
                    action: {
                        if message.isEmpty{
                            msgError = "Message is required"
                            isAlert = true
                        }
                        else{
                            UIApplication.shared.endEditing()
                            isLoading = true
                            let param = ["sid": Auth.shared.getUserId(), "rid": self.profileId, "message": message]
                            addMessageModel.callApiAddMsg(param) { success in
                                withAnimation {
                                    isLoading = false
                                    presentationMode.wrappedValue.dismiss()
                                }
                                
                            }
                        }
                        

                    },
                    label: {
                        Text("DONE")
                            .frame(maxWidth: .infinity, maxHeight: 50)
                    })
                .buttonStyle(PikcerButton()).padding(.bottom, 0)
                .padding()
                Spacer()
            }.toolbar(){
                ToolbarItemGroup(placement: .keyboard){
                    Spacer()
                    Button("Done"){
                        amountIsFocused = false
                    }.font(.custom(FONT_NAME.FUTURA_REGULAR, size: SIZE_FONT_LABEL))
                        .foregroundColor(Color.black)
                }
            }.alert(isPresented: $isAlert) {
                
                AlertHelper.shared.showAlertMessage(msgError)
            }
        }
       
    }
}
extension MessageMeView {
    var header: some View {
        VStack(spacing: 0) {
            HStack {
                
                Text("Message").font(.custom(FONT_NAME.FUTURA_REGULAR, size: 22))
                    .foregroundColor(Color.black)
                
            }
            .padding(.horizontal)
            .padding(.vertical, 10)
            
            Divider()
        }
    }
}
