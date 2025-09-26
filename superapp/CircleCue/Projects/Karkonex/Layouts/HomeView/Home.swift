//
//  Home.swift
//  SlideOutMenu
//
//  Created by パクギョンソク on 2023/09/10.
//

import SwiftUI
import FirebaseMessaging
struct Home: View {
    @EnvironmentObject var appRouter: AppRouter
    @Binding var showMenu: Bool
    @State var isActive: Bool = false
    var btnMenu : some View { Button(action: {
        showMenu.toggle()
    }) {
        HStack {
            Image("ic_menu") // set image here
                .aspectRatio(contentMode: .fit)
                .foregroundColor(.white)
            Text("")
        }
    }
    }
    var body: some View {
        
        //NavigationView {
        //header
        if appRouter.stateSideMenu == .home {
            VStack {
                NavigationStack {
                    headerHome
                    ListHome()
                }
               
            }
            .onAppear {
                self.updateToken()
            }
            .navigationBarHidden(true)
        }
        else if appRouter.stateSideMenu == .profile {
            VStack {
                NavigationStack {
                    headerNavi
                    MyProfileView( appRouter: self.appRouter)
                }
                
            } .navigationBarHidden(true)
        }
        else if appRouter.stateSideMenu == .search {
            VStack {
                NavigationStack {
                    headerNavi
                    SearchView()
                }
                
            } .navigationBarHidden(true)
            
        }else if appRouter.stateSideMenu == .contactus {
            VStack {
                headerNavi
                ContactView()
            } .navigationBarHidden(true)
            
        }
        else if appRouter.stateSideMenu == .mycar {
            VStack {
                NavigationStack {
                    headerNavi
                    MyCarsView()
                    Spacer()
                }
               
            } .navigationBarHidden(true)
            
        }
        else if appRouter.stateSideMenu == .myuniqiry {
            VStack {
                NavigationStack {
                    headerNavi
                    MyInquiryView()
                }
               
            } .navigationBarHidden(true)
            
        }
        else if appRouter.stateSideMenu == .sellbuy {
            VStack {
                NavigationStack {
                    headerNavi
                    SellBuyView()
                    Spacer()
                }
               
            } .navigationBarHidden(true)
            
        }
        else if appRouter.stateSideMenu == .messages {
            VStack {
                NavigationStack {
                    headerNavi
                    MessageView()
                    Spacer()
                }
               
            } .navigationBarHidden(true)
            
        }
        else if appRouter.stateSideMenu == .notificatons {
            VStack {
                NavigationStack {
                    headerNavi
                    NotificationView()
                    Spacer()
                }
               
            } .navigationBarHidden(true)
            
        }
        else if appRouter.stateSideMenu == .term {
            VStack {
                NavigationStack {
                    headerNavi
                    TermView(isTerm: false)
                    Spacer()
                }
               
            } .navigationBarHidden(true)
            
        }
        else if appRouter.stateSideMenu == .partnerApp {
            VStack {
                headerNaviPartnerApp
                PartnerAppView().padding(.top, -20)
                Spacer()
            } .navigationBarHidden(true)
                .edgesIgnoringSafeArea(.bottom)
                .background(Color(.systemPink).opacity(0.1))
        }
        else{
            VStack {
                headerNavi
                Spacer()
            }
        }
    }
    
    private func updateToken(){
        Messaging.messaging().token { token, error in
          if let error = error {
            print("Error fetching FCM registration token: \(error)")
          } else if let token = token {
            print("FCM registration token: \(token)")
              let param = ["id": AuthKaKonex.shared.getUserId(), "imei": token]
              APIKarkonexHelper.shared.updateToken(param) { success, erro in
                  
              }
          }
        }
    }
}

extension Home {
    var headerHome: some View {
        VStack(spacing: 0) {
            HStack {
                Button {
                    withAnimation {
                        showMenu.toggle()
                    }
                } label: {
                    Image("ic_menu")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 30, height: 30)
                }
                
                Spacer()
                
                Button {
                    withAnimation {
                        print("LOOO")
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "LOGOUTSUCCESS"), object: nil)
                    }
                } label: {
                    Image("btn_sa")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 40, height: 40)
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 10)
            
            Divider()
        }
        .overlay(
            Image("logo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 125, height: 41)
        )
    }
    var headerNavi: some View {
        VStack(spacing: 0) {
            HStack {
                
                Button {
                    withAnimation {
                        showMenu.toggle()
                    }
                } label: {
                    Image("ic_menu")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 30, height: 30)
                }
                
                Spacer()
                if appRouter.stateSideMenu == .mycar{
                    
                        NavigationLink(destination: AddCarView()) {
                            Image("ic_add_menu")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 30, height: 30)
                        }
                        .isDetailLink(false)
                        .buttonStyle(ButtonNormal())
                    
                    
                
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 10)
            if appRouter.stateSideMenu == .partnerApp{
                
            }
            else{
                Divider()
            }
            
        }
        .overlay(
            VStack{
                if appRouter.stateSideMenu == .search {
                    Text("SEARCH")
                        .font(.custom(FONT_NAME.FUTURA_REGULAR, size: SIZE_FONT_NAV))
                        .foregroundColor(Color.init(hex: "#870B0B"))
                }
                else if appRouter.stateSideMenu == .profile {
                    Text("MY PROFILE")
                        .font(.custom(FONT_NAME.FUTURA_REGULAR, size: SIZE_FONT_NAV))
                        .foregroundColor(Color.init(hex: "#870B0B"))
                }
                else if appRouter.stateSideMenu == .contactus {
                    Text("CONTACT US")
                        .font(.custom(FONT_NAME.FUTURA_REGULAR, size: SIZE_FONT_NAV))
                        .foregroundColor(Color.init(hex: "#870B0B"))
                }
                else if appRouter.stateSideMenu == .mycar {
                    Text("MY CARS")
                        .font(.custom(FONT_NAME.FUTURA_REGULAR, size: SIZE_FONT_NAV))
                        .foregroundColor(Color.init(hex: "#870B0B"))
                }
                else if appRouter.stateSideMenu == .messages {
                    Text("MESSAGES".uppercased())
                        .font(.custom(FONT_NAME.FUTURA_REGULAR, size: SIZE_FONT_NAV))
                        .foregroundColor(Color.init(hex: "#870B0B"))
                }
                else if appRouter.stateSideMenu == .myuniqiry {
                    Text("My Inquiry".uppercased())
                        .font(.custom(FONT_NAME.FUTURA_REGULAR, size: SIZE_FONT_NAV))
                        .foregroundColor(Color.init(hex: "#870B0B"))
                }
                else if appRouter.stateSideMenu == .notificatons {
                    Text("Notifications".uppercased())
                        .font(.custom(FONT_NAME.FUTURA_REGULAR, size: SIZE_FONT_NAV))
                        .foregroundColor(Color.init(hex: "#870B0B"))
                }
                else if appRouter.stateSideMenu == .term {
                    Text("TERMS".uppercased())
                        .font(.custom(FONT_NAME.FUTURA_REGULAR, size: SIZE_FONT_NAV))
                        .foregroundColor(Color.init(hex: "#870B0B"))
                }
                else if appRouter.stateSideMenu == .fav {
                    Text("FAVORITES".uppercased())
                        .font(.custom(FONT_NAME.FUTURA_REGULAR, size: SIZE_FONT_NAV))
                        .foregroundColor(Color.init(hex: "#870B0B"))
                }
                else if appRouter.stateSideMenu == .sellbuy {
                    Text("INQUIRE RENT/BUY".uppercased())
                        .font(.custom(FONT_NAME.FUTURA_REGULAR, size: SIZE_FONT_NAV))
                        .foregroundColor(Color.init(hex: "#870B0B"))
                }
//                else if appRouter.stateSideMenu == .sellbuy {
//                    Text("RENT / SELL / BUY".uppercased())
//                        .font(.custom(FONT_NAME.FUTURA_REGULAR, size: SIZE_FONT_NAV))
//                        .foregroundColor(Color.init(hex: "#870B0B"))
//                }
                else if appRouter.stateSideMenu == .partnerApp {
                    
                }
                else{
                    Text("ALL")
                        .font(.custom(FONT_NAME.FUTURA_REGULAR, size: SIZE_FONT_NAV))
                        .foregroundColor(Color.init(hex: "870B0B"))
                }
                
            }
            
        )
       
    }
    
    
    var headerNaviPartnerApp: some View {
        VStack(spacing: 0) {
            HStack {
                
                Button {
                    withAnimation {
                        showMenu.toggle()
                    }
                } label: {
                    Image("ic_menu")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 30, height: 30)
                }
                
                Spacer()
               
            }
            .padding(.horizontal)
            .padding(.vertical, 10)
            
            
        }
       
    }
}


