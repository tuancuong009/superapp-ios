//
//  Config.swift.swift
//  SwiftUIBlueprint
//
//  Created by Dino Trnka on 16. 1. 2023..
//

import Foundation

class Config {
    static let shared = Config()
    
    let scheme: String = "https"
    let host: String = "karkonnex.com"
    
    let URL_SERVER = "https://karkonnex.com/api/"
}
enum APIState {
    case loading
    case success
    case failure
}
