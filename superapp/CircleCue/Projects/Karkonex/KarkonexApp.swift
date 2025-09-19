//
//  KarkonexApp.swift
//  Karkonex
//
//  Created by QTS Coder on 12/04/2024.
//

//import SwiftUI
//@main
//struct KarkonexApp: App {
//    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
//    @StateObject var appRouter = AppRouter()
//    @ViewBuilder
//    var rootView: some View {
//        switch appRouter.state {
//        case .login:
//            WelcomeView()
//        case .home:
//            BaseView()
//        }
//               
//    }
//    init() {
//      
//        NetworkMonitor.shared.startMonitoring()
//        
//    }
//    var body: some Scene {
//        WindowGroup {
//            NavigationView {
//                rootView
//                    .environmentObject(appRouter)
//            }
//            .specialNavBar()
//            .onAppear {
//                print("USERID000-->",Auth.shared.hasAccessToken())
//            }
//        }
//    }
//    
//}
