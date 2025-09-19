//
//  ContactView.swift
//  Karkonex
//
//  Created by QTS Coder on 25/10/24.
//

import SwiftUI

struct ContactView: View {
    @State var contactUsModel: ContactUsModel = ContactUsModel()
    @FocusState private var amountIsFocused: Bool
    init() {
      UITextField.appearance().clearButtonMode = .whileEditing
    }
    @State var isAlert = false
    @State var isLoading = false
    
    var body: some View {
        ActivityIndicatorView(isDisplayed: .constant(isLoading)) {
            ScrollView{
                VStack(spacing: 20.0){
                    Text("1-(844) KONNEX6 (844-566-6396)") .font(.custom(FONT_NAME.FUTURA_REGULAR, size: SIZE_FONT_NAV))
                        .foregroundColor(Color.black)
                    VStack(alignment: .leading, spacing: 5){
                        Text("Full Name")
                            .font(.custom(FONT_NAME.FUTURA_REGULAR, size: SIZE_FONT_LABEL))
                            .foregroundColor(Color.black)
                        TextField("Full Name", text: $contactUsModel.fullName)
                            .textFieldStyle(OvalTextFieldStyle())
                            .keyboardType(.default)
                            .submitLabel(.next)
                            .onSubmit {
                                print("Next")
                            }.focused($amountIsFocused)
                            .textInputAutocapitalization(.words)
                    }
                    VStack(alignment: .leading, spacing: 5){
                        Text("Phone")
                            .font(.custom(FONT_NAME.FUTURA_REGULAR, size: SIZE_FONT_LABEL))
                            .foregroundColor(Color.black)
                        TextField("Phone", text: $contactUsModel.phone)
                            .textFieldStyle(OvalTextFieldStyle())
                            .keyboardType(.phonePad)
                            .submitLabel(.next)
                            .onSubmit {
                                print("Next")
                            }.focused($amountIsFocused)
                            .textInputAutocapitalization(.never)
                    }
                    VStack(alignment: .leading, spacing: 5){
                        Text("Email")
                            .font(.custom(FONT_NAME.FUTURA_REGULAR, size: SIZE_FONT_LABEL))
                            .foregroundColor(Color.black)
                        TextField("Email", text: $contactUsModel.email)
                            .textFieldStyle(OvalTextFieldStyle())
                            .keyboardType(.emailAddress)
                            .submitLabel(.next)
                            .onSubmit {
                                print("Next")
                            }.focused($amountIsFocused)
                            .textInputAutocapitalization(.never)
                    }
                    VStack(alignment: .leading, spacing: 5){
                        Text("Messages")
                            .font(.custom(FONT_NAME.FUTURA_REGULAR, size: SIZE_FONT_LABEL))
                            .foregroundColor(Color.black)
                        TextField("Messages", text: $contactUsModel.messages, axis: .vertical)
                            .textFieldStyle(OvalTextFieldStyle())
                            .keyboardType(.default)
                            .submitLabel(.next)
                            .onSubmit {
                                print("Next")
                            }.focused($amountIsFocused)
                            .textInputAutocapitalization(.words)
                            .lineLimit(5...10)
                           
                    }
                    Button (
                        action: {
                            if contactUsModel.fullName.trimText().isEmpty{
                                contactUsModel.msgError = ERROR_MESSAGE.FULLNAME_REQUIRED
                                isAlert = true
                            }
                            else if contactUsModel.email.trimText().isEmpty{
                                contactUsModel.msgError = ERROR_MESSAGE.EMAIL_REQUIRED
                                isAlert = true
                            }
                            else if !contactUsModel.email.trimText().isValidEmail(){
                                contactUsModel.msgError = ERROR_MESSAGE.EMAIL_INVALID
                                isAlert = true
                            }
                            else if contactUsModel.phone.isEmpty{
                                contactUsModel.msgError = ERROR_MESSAGE.TELEPHONE_REQUIRED
                                isAlert = true
                            }
                            else if contactUsModel.messages.isEmpty{
                                contactUsModel.msgError = ERROR_MESSAGE.MESSAGE_REQUIRED
                                isAlert = true
                            }
                            else{
                                UIApplication.shared.endEditing()
                                isLoading = true
                                let param = ["email": contactUsModel.email, "name": contactUsModel.fullName, "phone": contactUsModel.phone, "msg": contactUsModel.messages]
                                APIKarkonexHelper.shared.contactUs(param) { success, error in
                                    isLoading = false
                                    if success!{
                                        print("SUCCESS")
                                        if let error = error{
                                            contactUsModel.msgError = error
                                            isAlert = true
                                        }
                                        contactUsModel.email = ""
                                        contactUsModel.phone = ""
                                        contactUsModel.fullName = ""
                                        contactUsModel.messages = ""
                                    }
                                    else{
                                        if let error = error{
                                            contactUsModel.msgError = error
                                            isAlert = true
                                        }
                                    }
                                }
                            }
                            
                        },
                        label: {
                        Text("Send")
                            .frame(maxWidth: .infinity, maxHeight: 30)
                    })
                    .buttonStyle(BlueButton())
                    Spacer()
                }.padding()
            }.toolbar(){
                ToolbarItemGroup(placement: .keyboard){
                    Spacer()
                    Button("Done"){
                        amountIsFocused = false
                    }.font(.custom(FONT_NAME.FUTURA_REGULAR, size: SIZE_FONT_LABEL))
                        .foregroundColor(Color.black)
                }
            }
            .alert(isPresented: $isAlert) {
             
                AlertHelper.shared.showAlertMessage(contactUsModel.msgError)
            }
        }
       
       
    }
}

#Preview {
    ContactView()
}
