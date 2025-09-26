//
//  AppRouter.swift
//  Routing

import Foundation
import SwiftUI

class AppRouter: ObservableObject {
    @Published var state: AppState = AuthKaKonex.shared.hasAccessToken() ? .home : .login
    @Published var stateSideMenu: AppStateSideMenu = .home
}

enum AppState {
    case login
    case home
}

enum AppStateSideMenu {
    case home
    case search
    case showcase
    case contactus
    case profile
    case mycar
    case myuniqiry
    case sellbuy
    case messages
    case notificatons
    case term
    case fav
    case partnerApp
}
