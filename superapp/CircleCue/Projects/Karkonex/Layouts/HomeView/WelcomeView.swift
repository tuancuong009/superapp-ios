//
//  WelcomeView.swift
//  Karkonex
//
//  Created by QTS Coder on 12/11/24.
//

import SwiftUI

struct WelcomeView: View {
    @State var isLoading = false
    @EnvironmentObject var appRouter: AppRouter
    @State private var showPopup = false
    
    var body: some View {
        ActivityIndicatorView(isDisplayed: .constant(isLoading)) {
            ZStack{
                VStack{
                    HStack{
                        Button {
                            withAnimation {
                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "LOGOUTSUCCESS"), object: nil)
                            }
                        } label: {
                            Image("btnback")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 30, height: 30)
                        }
                        Spacer()
                        Text("Find your perfect ride securely")  .font(.custom(FONT_NAME.FUTURA_MEDIUM, size: 18))
                            .multilineTextAlignment(.center)
                            .foregroundColor(.init(hex: "870B0B"))
                        Spacer()
                    }
                    .padding(10)
                    HStack(alignment: .center, spacing: 10, content: {
                        Spacer()
                        HStack(alignment: .center, spacing: 10, content: {
                            NavigationLink(destination: SellBuyViewHome()) {
                                Text("Inquiry")
                                    .font(.custom(FONT_NAME.FUTURA_MEDIUM, size: 16.0)).padding(10)
                            }
                            .isDetailLink(false)
                            .buttonStyle(CustomBlueButton())
                            
                            NavigationLink(destination: RegisterView(appRouter: self.appRouter)) {
                                Text("Register")
                                    .font(.custom(FONT_NAME.FUTURA_MEDIUM, size: 16.0)).padding(10)
                            }
                            .isDetailLink(false)
                            .buttonStyle(CustomSwiftUIButton())
                            
                            NavigationLink(destination: LoginView(appRouter: self.appRouter)) {
                                Text("Login")
                                    .font(.custom(FONT_NAME.FUTURA_MEDIUM, size: 16.0)).padding(10)
                            }
                            .isDetailLink(false)
                            .buttonStyle(LoginButton())
                            
                        })
                        
                        Spacer()
                    })
                    Spacer(minLength: 10)
                    HStack{
                        Image("logo")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 250, height: 60, alignment: .center)
                            .padding(.bottom, 0)
                    }
                    VStack(){
                        ScrollView{
                            LazyVGrid(columns: [GridItem(.flexible(), spacing: 13), GridItem(.flexible(), spacing: 13)], spacing: 13) {
                                ForEach(0...7, id: \.self) { i in
                                    Button {
                                        showPopup.toggle()
                                    } label: {
                                        WelcomeCell(index: i)
                                    }
                                    
                                    
                                }
                                
                            }
                        }
                        .padding(13)
                        .scrollIndicators(ScrollIndicatorVisibility.hidden)
                        Spacer()
                    }
                }
                
                if showPopup {
                    Color.black.opacity(0.4)
                        .edgesIgnoringSafeArea(.all)
                        .onTapGesture {
                            showPopup = false
                        }
                    
                    VStack(spacing: 20) {
                        Image("logo")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 250, height: 60, alignment: .center)
                            .padding(.bottom, 0)
                    
                        HStack(spacing: 5) {
                            Text("Please")
                                .font(.custom(FONT_NAME.FUTURA_REGULAR, size: 16.0)).foregroundColor(.init(hex: "870B0B"))
                            NavigationLink(destination: LoginView(appRouter: self.appRouter)) {
                                Text("LOGIN")
                                    .font(.custom(FONT_NAME.FUTURA_MEDIUM, size: 16.0)).foregroundColor(.init(hex: "1B1464"))
                            }
                            .isDetailLink(false)
                            .buttonStyle(ButtonNormal())
                            
                          

                            Text("if already Member")
                                .font(.custom(FONT_NAME.FUTURA_REGULAR, size: 16.0)).foregroundColor(.init(hex: "870B0B"))
                        }
                        HStack{
                            Text("Or")
                                .font(.custom(FONT_NAME.FUTURA_REGULAR, size: 16.0)).foregroundColor(.init(hex: "870B0B"))
                        }
                        HStack(spacing: 5, content: {
                            Text("Join Karkonnex Free")
                                .font(.custom(FONT_NAME.FUTURA_REGULAR, size: 16.0)).foregroundColor(.init(hex: "870B0B"))
                            
                            NavigationLink(destination: RegisterView(appRouter: self.appRouter)) {
                                Text("SIGNUP")
                                    .font(.custom(FONT_NAME.FUTURA_MEDIUM, size: 16.0)).foregroundColor(.init(hex: "1B1464"))
                            }
                            .isDetailLink(false)
                            .buttonStyle(ButtonNormal())
                        })
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(.red, lineWidth: 1)
                        )
                    .shadow(radius: 10)
                    .frame(height: 200)
                }
            }
        } .onAppear {
            
        }
        .navigationBarHidden(true)
        .edgesIgnoringSafeArea(.bottom)
    }
}

#Preview {
    WelcomeView()
}
