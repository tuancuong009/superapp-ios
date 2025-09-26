//
//  SideMenu.swift
//  SlideOutMenu


import SwiftUI

struct SideMenu: View {
    @EnvironmentObject var appRouter: AppRouter
    @Binding var showMenu: Bool
    @State private var showSafariCC = false
    @State private var showSafariIS = false
    private let urlStringCC = "https://www.circlecue.com/karkonnex"
    private let urlStringIS = "https://www.instagram.com/karkonnex/profilecard/?igsh=dDM4bmJjYWVlZGV0"
    let datas = [MenuObj(name: "HOME", icon: "ic_home"),
                 MenuObj(name: "SEARCH", icon: "ic_search"),
                 MenuObj(name: "INQUIRE RENT/BUY", icon: "ic_inquiry"),
                 MenuObj(name: "MY PROFILE", icon: "menu_profile2"),
                 MenuObj(name: "MY CARS", icon: "ic_mycar"),
                 MenuObj(name: "MY INQUIRY", icon: "ic_myinquiry"),
                 MenuObj(name: "NOTIFICATIONS", icon: "ic_notification"),
                 MenuObj(name: "MESSAGES".uppercased(), icon: "ic_msg2"),
                 MenuObj(name: "PARTNER APPS".uppercased(), icon: "menu_logo"),
                 MenuObj(name: "TERMS", icon: "menu_help2"),
                 MenuObj(name: "CONTACT", icon: "ic_contactus"),
                 MenuObj(name: "LOGOUT", icon: "ic_logout")
    ]
    
    var body: some View {
        
        VStack {
            VStack(spacing: 5) {
                Image("logo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 250, height: 60, alignment: .center)
                    .padding(.bottom, 20)
                
                //Spacer()
                List(datas, id: \.name) { menuObj in
                    Button {
                        showMenu.toggle()
                        if menuObj.name == "HOME"{
                            appRouter.stateSideMenu = .home
                        }
                        else if menuObj.name == "SEARCH"{
                            appRouter.stateSideMenu = .search
                        }
                        else if menuObj.name == "MY PROFILE"{
                            appRouter.stateSideMenu = .profile
                        }
                        else if menuObj.name == "CONTACT"{
                            appRouter.stateSideMenu = .contactus
                        }
                        else if menuObj.name == "MY CARS"{
                            appRouter.stateSideMenu = .mycar
                        }
                        else if menuObj.name == "MY INQUIRY"{
                            appRouter.stateSideMenu = .myuniqiry
                        }
                       
                        else if menuObj.name == "MESSAGES"{
                            appRouter.stateSideMenu = .messages
                        }
                        else if menuObj.name == "INQUIRE RENT/BUY"{
                            appRouter.stateSideMenu = .sellbuy
                        }
                        else if menuObj.name == "NOTIFICATIONS"{
                            appRouter.stateSideMenu = .notificatons
                        }
                        else if menuObj.name == "TERMS"{
                            appRouter.stateSideMenu = .term
                        }
                        else if menuObj.name == "PARTNER APPS"{
                            appRouter.stateSideMenu = .partnerApp
                        }
                        else if menuObj.name == "LOGOUT"{
                            AuthKaKonex.shared.logout()
                            appRouter.state = .login
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "LOGOUTSUCCESS"), object: nil)
                        }
                    } label: {
                        HStack {
                           Image(menuObj.icon)
                                .resizable()
                               .frame(width: 20.0, height: 20.0)
                               .aspectRatio(contentMode: .fit)
                          
                           Text(menuObj.name)
                                .font(.custom(FONT_NAME.FUTURA_REGULAR, size: SIZE_FONT_TEXT))
                                .multilineTextAlignment(.leading)
                               .padding(EdgeInsets(top: 8, leading: 10, bottom: 8, trailing: 10))
                       }
                        
                    }

                }
                .scrollIndicators(ScrollIndicatorVisibility.hidden)
                .listStyle(.plain)
                .onAppear {
                    UITableView.appearance().separatorStyle = .none
                    UITableView.appearance().separatorColor = .clear
                }
                Divider()
                VStack(spacing: 5) {
                    HStack(spacing: 20, content: {
                        Button {
                            showSafariCC = true
                        } label: {
                            Image("menu_cc").scaledToFit().foregroundColor(.black)
                        }

                        Button {
                            showSafariIS = true
                        } label: {
                            Image("menu_is").scaledToFit().foregroundColor(.black)
                        }
                    })
                    Text("Patent Pending")
                        .font(.custom(FONT_NAME.FUTURA_REGULAR, size: 15.0))
                        .foregroundStyle(.black)
                        .multilineTextAlignment(.center)
                    Text("@2024 KarKonnex by App Monarchy, Inc.\nAll rights reserved")
                        .font(.custom(FONT_NAME.FUTURA_REGULAR, size: 15.0))
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }.padding(.bottom, 20)
                
            }
            .padding(EdgeInsets(top: 5, leading: 0, bottom: 5, trailing: 10))
            
        }
        .padding(.vertical)
        .frame(width: getRect().width - 90)
        .frame(maxHeight: .infinity)
        .background(
            
            Color.white
                .ignoresSafeArea(.container, edges: .vertical)
        )
        .frame(maxWidth: .infinity, alignment: .leading)
        .ignoresSafeArea(.container, edges: .bottom)
        .sheet(isPresented: $showSafariCC) {
            if let url = URL(string: urlStringCC) {
                        SafariView(url: url)
                    } else {
                        Text("Invalid URL")
                    }
                }
        .sheet(isPresented: $showSafariIS) {
            if let url = URL(string: urlStringIS) {
                        SafariView(url: url)
                    } else {
                        Text("Invalid URL")
                    }
                }
    }
    
}

