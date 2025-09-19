//
//  LoginView.swift
//  Karkonex
//
//  Created by QTS Coder on 12/04/2024.
//

import SwiftUI
import Alamofire
struct LoginView: View {
    @State var viewModel: LoginViewModel = LoginViewModel()
    
    @State var isAlert = false
    @State var isLoading = false
    @State var iShowHidePassword = false
    @State var appRouter: AppRouter
    @FocusState private var amountIsFocused: Bool
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State var isMain = false
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
        if isMain{
            BaseView().environmentObject(appRouter)
        }
        else{
            ActivityIndicatorView(isDisplayed: .constant(isLoading)) {
                VStack{
                    ScrollView(.vertical, showsIndicators: false, content: {
                        VStack {
                            Image("logo")
                                .resizable()
                                .frame(width: 125, height: 41)
                                .padding(.top)
                            SocialLoginView(textNavi: "Or Login With", appRouter: self.appRouter, onSignInSuccess: {
                                appRouter.stateSideMenu = .home
                                appRouter.state = .home
                                print("SUCCESS")
                            },
                            onSignInFailure: { error in
                                viewModel.msgError = error
                                isAlert = true
                            })
                            
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
                                        .textInputAutocapitalization(.never)
                                        .onSubmit {
                                            print("Next")
                                        }.focused($amountIsFocused)
                                    
                                }
                                VStack(alignment: .leading, spacing: 5){
                                    Text("Password")
                                        .font(.custom(FONT_NAME.FUTURA_REGULAR, size: SIZE_FONT_LABEL))
                                        .foregroundColor(Color.black)
                                    HStack{
                                        if iShowHidePassword {
                                            TextField("Password", text: $viewModel.password)
                                                .textFieldStyle(OvalPasswordTextFieldStyle())
                                                .keyboardType(.default)
                                                .submitLabel(.next)
                                                .textContentType(.password)
                                                .onSubmit {
                                                    print("Next")
                                                }.focused($amountIsFocused)
                                        } else {
                                            SecureField("Password", text:$viewModel.password)
                                                .textFieldStyle(OvalPasswordTextFieldStyle())
                                                .submitLabel(.next).focused($amountIsFocused)
                                        }
                                        
                                       
                                        Spacer()
                                        Button(action: {
                                            iShowHidePassword.toggle()
                                        }, label: {
                                            Image(!iShowHidePassword ? "ic_show" : "ic_hide")
                                                .resizable()
                                                .frame(width: 24, height: 24)
                                                .padding(5)
                                        })
                                    }.overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                                    )
                                  
                                }
                                
                                
                                Button (
                                    action: {
                                        
                                        if viewModel.email.trimText().isEmpty{
                                            viewModel.msgError = ERROR_MESSAGE.EMAIL_REQUIRED
                                            isAlert = true
                                        }
                                        else if !viewModel.email.trimText().isValidEmail(){
                                            viewModel.msgError = ERROR_MESSAGE.EMAIL_INVALID
                                            isAlert = true
                                        }
                                        else if viewModel.password.isEmpty{
                                            viewModel.msgError = ERROR_MESSAGE.PASSWORD_REQUIRED
                                            isAlert = true
                                        }
                                        else{
                                            UIApplication.shared.endEditing()
                                            isLoading = true
                                            let param = ["email": viewModel.email, "password": viewModel.password]
                                            APIKarkonexHelper.shared.loginUser(param) { success, error in
                                                isLoading = false
                                                if success!{
                                                    appRouter.stateSideMenu = .home
                                                    appRouter.state = .home
                                                    print("SUCCESS")
                                                    isMain = true
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
                                        Text("Login")
                                            .frame(maxWidth: .infinity, maxHeight: 30)
                                    })
                                .buttonStyle(BlueButton())
                                Spacer(minLength: 20)
                            }
                            Spacer()
                            
                            
                        }
                    })
                    
                    HStack{
                        NavigationLink(destination: RegisterView(appRouter: self.appRouter)) {
                            Text("Create Account")
                            
                        }
                        .isDetailLink(false)
                        .buttonStyle(ButtonNormal())
                        
                        Divider().frame(height: 10)
                        NavigationLink(destination: ForgotPasswordView()) {
                            Text("Forgot Password")
                            
                        }
                        .isDetailLink(false)
                        .buttonStyle(ButtonNormal())
                    }
                    
                    VStack(spacing: 0) {
                        HStack(spacing: 2) {
                            Text("By proceeding to use KarKonnex, you argree to our")
                                .font(.custom(FONT_NAME.FUTURA_REGULAR, size: SIZE_FONT_LABEL))
                                .foregroundColor(Color.black)
                        }
                        HStack(spacing: 2) {
                            NavigationLink(destination: DisclaimerView()) {
                                Text("Terms").foregroundColor(Color.init(hex: "#870B0B"))
                                
                            }
                            .isDetailLink(false)
                            .buttonStyle(ButtonNormal())
                            Text("and")
                                .font(.custom(FONT_NAME.FUTURA_REGULAR, size: SIZE_FONT_LABEL))
                                .foregroundColor(Color.black)
                            NavigationLink(destination: TermView(isTerm: true)) {
                                Text("Privacy Policy").foregroundColor(Color.init(hex: "#870B0B"))
                                
                            }
                            .isDetailLink(false)
                            .buttonStyle(ButtonNormal())
                        }
                    }

                }
                
                .alert(isPresented: $isAlert) {
                    
                    AlertHelper.shared.showAlertMessage(viewModel.msgError)
                }
                .onAppear(perform: {
                    
                })
                .navigationBarHidden(false)
                .edgesIgnoringSafeArea(.bottom)
                .padding()
                .navigationTitle("Login Account".uppercased())
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarItems(leading: btnBack)
                .navigationBarBackButtonHidden(true)
                .toolbar(){
                    ToolbarItemGroup(placement: .keyboard){
                        Spacer()
                        Button("Done"){
                            amountIsFocused = false
                        }.font(.custom(FONT_NAME.FUTURA_REGULAR, size: SIZE_FONT_LABEL))
                            .foregroundColor(Color.black)
                    }
                }
                .onReceive(NotificationCenter.default.publisher(for: Notification.Name("MyNotification"))) { notification in
                    appRouter.stateSideMenu = .home
                    appRouter.state = .home
                    print("SUCCESS")
                    isMain = true
                    NotificationCenter.default.removeObserver(self)
                }
            }
        }
        
        
    }
}

