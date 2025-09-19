//
//  DeleteAccountView.swift
//  Karkonex
//
//  Created by QTS Coder on 1/11/24.
//

import SwiftUI
struct DeleteAccountView: View {
    @StateObject var addMessageModel = AddMessageModel()
    @Environment(\.presentationMode) var presentationMode
    @FocusState private var amountIsFocused: Bool
    @State private var isLoading = false
    @State private var isAlert = false
    @State private var msgError:String  = ""
    @State private var password: String = ""
    var body: some View {
        ActivityIndicatorView(isDisplayed: .constant(isLoading)) {
            VStack {
                header
                
                Spacer()
                Text("Do you want to delete account?").font(.custom(FONT_NAME.FUTURA_REGULAR, size: 16))
                    .foregroundColor(Color.black)
                VStack(alignment: .leading, spacing: 5){
                    Text("Password")
                        .font(.custom(FONT_NAME.FUTURA_REGULAR, size: SIZE_FONT_LABEL))
                        .foregroundColor(Color.black)
                    SecureField("Password", text:$password)
                        .textFieldStyle(OvalTextFieldStyle())
                        .submitLabel(.next).focused($amountIsFocused)
                }
                .padding()
                Button (
                    action: {
                       
                        

                    },
                    label: {
                        Text("DELETE")
                            .frame(maxWidth: .infinity, maxHeight: 50)
                    })
                .buttonStyle(RedButton()).padding(.bottom, 0)
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
extension DeleteAccountView {
    var header: some View {
        VStack(spacing: 0) {
            HStack {
                
                Text("Delete Account").font(.custom(FONT_NAME.FUTURA_REGULAR, size: 22))
                    .foregroundColor(Color.red)
                
            }
            .padding(.horizontal)
            .padding(.vertical, 10)
            
            Divider()
        }
    }
}
