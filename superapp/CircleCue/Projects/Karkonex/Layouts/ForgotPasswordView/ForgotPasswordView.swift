//
//  ForgotPasswordView.swift
//  Karkonex
//
//  Created by QTS Coder on 21/10/24.
//

import SwiftUI

struct ForgotPasswordView: View {
    @ObservedObject var viewModel: LoginViewModel = LoginViewModel()
    @State var isAlert = false
    @State var isLoading = false
    @State var messageSuccess = ""
    @EnvironmentObject var appRouter: AppRouter
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    init() {
      UITextField.appearance().clearButtonMode = .whileEditing
    }
    var btnBack : some View { Button(action: {
        self.presentationMode.wrappedValue.dismiss()
    }) {
        HStack {
            Image("btnback") // set image here
                .aspectRatio(contentMode: .fit)
                .foregroundColor(.white)
            Text("")
        }
    }
    }
    var body: some View {
        ActivityIndicatorView(isDisplayed: .constant(isLoading)) {
            VStack {
                Image("logo")
                    .resizable()
                    .frame(width: 125, height: 41)
                    .padding(.top)
               
                VStack(spacing: 20.0){
             
                    VStack(alignment: .leading, spacing: 5){
                        Text("Email")
                            .font(.custom(FONT_NAME.FUTURA_REGULAR, size: SIZE_FONT_LABEL))
                            .foregroundColor(Color.black)
                        TextField("Email", text: $viewModel.email)
                            .textFieldStyle(OvalTextFieldStyle())
                            .keyboardType(.emailAddress)
                            .submitLabel(.next)
                            .textContentType(.emailAddress)
                            .onSubmit {
                                print("Next")
                            }
                    }
                    
                    
                    Button (
                        action: {
                          //  appRouter.state = .home
                            if viewModel.email.isEmpty{
                                viewModel.msgError = "Email is required"
                                isAlert = true
                            }
                            else if !viewModel.email.isValidEmail(){
                                viewModel.msgError = "Email is invalid"
                                isAlert = true
                            }
                           
                            else{
                                UIApplication.shared.endEditing()
                                isLoading = true
                                let param = ["email": viewModel.email]
                                APIKarkonexHelper.shared.forgotpassword(param) { success, error in
                                    isLoading = false
                                    if success!{
                                        isAlert = true
                                        if let error = error{
                                            messageSuccess = error
                                        }
                                        
                                    }
                                    else{
                                        if let error = error{
                                            viewModel.msgError = error
                                            isAlert = true
                                        }
                                    }
                                }
                            }
                        },
                        label: {
                        Text("Submit")
                            .frame(maxWidth: .infinity, maxHeight: 30)
                    })
                    .buttonStyle(BlueButton())
                    
                }.padding()
                Spacer()
              
            }
            .alert(isPresented: $isAlert) {
                if messageSuccess.isEmpty{
                    AlertHelper.shared.showAlertMessage(viewModel.msgError)
                }
                else{
                    Alert(title: Text(APP_NAME), message: Text(messageSuccess), dismissButton: .cancel(Text("OK"), action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }))
                }
               
            }
            .padding()
            .navigationTitle("Forgot Password".uppercased())
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(leading: btnBack)
            .navigationBarBackButtonHidden(true)
        }
        
    }
}

#Preview {
    ForgotPasswordView()
}
